// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:dwds/dwds.dart';
import 'package:meta/meta.dart';
import 'package:vm_service/vm_service.dart' as vmservice;

import '../application_package.dart';
import '../base/common.dart';
import '../base/file_system.dart';
import '../base/logger.dart';
import '../base/terminal.dart';
import '../base/utils.dart';
import '../build_info.dart';
import '../convert.dart';
import '../device.dart';
import '../globals.dart';
import '../project.dart';
import '../resident_runner.dart';
import '../web/web_runner.dart';
import 'web_fs.dart';

/// Injectable factory to create a [ResidentWebRunner].
class DwdsWebRunnerFactory extends WebRunnerFactory {
  @override
  ResidentRunner createWebRunner(
    Device device, {
    String target,
    @required FlutterProject flutterProject,
    @required bool ipv6,
    @required DebuggingOptions debuggingOptions
  }) {
    return ResidentWebRunner(
      device,
      target: target,
      flutterProject: flutterProject,
      debuggingOptions: debuggingOptions,
      ipv6: ipv6,
    );
  }
}

// TODO(jonahwilliams): remove this constant when the error message is removed.
// The web engine is currently spamming this message on certain pages. Filter it out
// until we remove it entirely. See flutter/flutter##37625.
const String _kBadError = 'WARNING: 3D transformation matrix was passed to BitmapCanvas.';

/// A hot-runner which handles browser specific delegation.
class ResidentWebRunner extends ResidentRunner {
  ResidentWebRunner(this.device, {
    String target,
    @required this.flutterProject,
    @required bool ipv6,
    @required DebuggingOptions debuggingOptions,
  }) : super(
          <FlutterDevice>[],
          target: target,
          debuggingOptions: debuggingOptions,
          ipv6: ipv6,
          usesTerminalUi: true,
          stayResident: true,
        );

  final Device device;
  final FlutterProject flutterProject;

  WebFs _webFs;
  DebugConnection _debugConnection;
  StreamSubscription<vmservice.Event> _stdOutSub;

  vmservice.VmService get _vmService => _debugConnection.vmService;

  @override
  bool get canHotRestart {
    return true;
  }

  @override
  Future<Map<String, dynamic>> invokeFlutterExtensionRpcRawOnFirstIsolate(
    String method, {
    Map<String, dynamic> params,
  }) async {
    final vmservice.Response response = await _vmService.callServiceExtension(method, args: params);
    return response.toJson();
  }

  @override
  Future<void> cleanupAfterSignal() async {
    await _cleanup();
  }

  @override
  Future<void> cleanupAtFinish() async {
    await _cleanup();
  }

  Future<void> _cleanup() async {
    await _debugConnection?.close();
    await _stdOutSub?.cancel();
    await _webFs?.stop();
  }

  @override
  void printHelp({bool details = true}) {
    if (details) {
      return printHelpDetails();
    }
    const String fire = '🔥';
    const String rawMessage =
        '  To hot restart (and rebuild state), press "R".';
    final String message = terminal.color(
      fire + terminal.bolden(rawMessage),
      TerminalColor.red,
    );
    const String warning = '👻 ';
    printStatus(warning * 20);
    printStatus('Warning: Flutter\'s support for building web applications is highly experimental.');
    printStatus('For more information see https://github.com/flutter/flutter/issues/34082.');
    printStatus(warning * 20);
    printStatus('');
    printStatus(message);
    const String quitMessage = 'To quit, press "q".';
    printStatus('For a more detailed help message, press "h". $quitMessage');
  }

  @override
  Future<int> run({
    Completer<DebugConnectionInfo> connectionInfoCompleter,
    Completer<void> appStartedCompleter,
    String route,
  }) async {
    final ApplicationPackage package = await ApplicationPackageFactory.instance.getPackageForPlatform(
      TargetPlatform.web_javascript,
      applicationBinary: null,
    );
    if (package == null) {
      printError('No application found for TargetPlatform.web_javascript.');
      printError('To add web support to a project, run `flutter create --web .`.');
      return 1;
    }
    if (!fs.isFileSync(mainPath)) {
      String message = 'Tried to run $mainPath, but that file does not exist.';
      if (target == null) {
        message +=
            '\nConsider using the -t option to specify the Dart file to start.';
      }
      printError(message);
      return 1;
    }
    Status buildStatus;
    try {
      buildStatus = logger.startProgress('Building application for the web...', timeout: null);
      _webFs = await webFsFactory(
        target: target,
        flutterProject: flutterProject,
        buildInfo: debuggingOptions.buildInfo,
      );
      if (supportsServiceProtocol) {
        _debugConnection = await _webFs.runAndDebug();
      }
    } catch (err, stackTrace) {
      printError(err.toString());
      printError(stackTrace.toString());
      throwToolExit('Failed to build application for the web.');
    } finally {
      buildStatus.stop();
    }
    appStartedCompleter?.complete();
    return attach(
      connectionInfoCompleter: connectionInfoCompleter,
      appStartedCompleter: appStartedCompleter,
    );
  }

  @override
  Future<int> attach({
    Completer<DebugConnectionInfo> connectionInfoCompleter,
    Completer<void> appStartedCompleter,
  }) async {
    // Cleanup old subscriptions. These will throw if there isn't anything
    // listening, which is fine because that is what we want to ensure.
    try {
      await _debugConnection?.vmService?.streamCancel('Stdout');
    } on vmservice.RPCError {
      // Ignore this specific error.
    }
    try {
      await _debugConnection?.vmService?.streamListen('Stdout');
    } on vmservice.RPCError  {
      // Ignore this specific error.
    }
    Uri websocketUri;
    if (supportsServiceProtocol) {
      _stdOutSub = _debugConnection.vmService.onStdoutEvent.listen((vmservice.Event log) {
        final String message = utf8.decode(base64.decode(log.bytes)).trim();
        // TODO(jonahwilliams): remove this error once it is gone from the engine #37625.
        if (!message.contains(_kBadError)) {
          printStatus(message);
        }
      });
      websocketUri = Uri.parse(_debugConnection.uri);
    }
    connectionInfoCompleter?.complete(
      DebugConnectionInfo(wsUri: websocketUri)
    );
    final int result = await waitForAppToFinish();
    await cleanupAtFinish();
    return result;
  }

  @override
  Future<OperationResult> restart({
    bool fullRestart = false,
    bool pauseAfterRestart = false,
    String reason,
    bool benchmarkMode = false,
  }) async {
    if (!fullRestart) {
      return OperationResult(1, 'hot reload not supported on the web.');
    }
    final Stopwatch timer = Stopwatch()..start();
    final Status status = logger.startProgress(
      'Performing hot restart...',
      timeout: supportsServiceProtocol
          ? timeoutConfiguration.fastOperation
          : timeoutConfiguration.slowOperation,
      progressId: 'hot.restart',
    );
    final bool success = await _webFs.recompile();
    if (!success) {
      status.stop();
      return OperationResult(1, 'Failed to recompile application.');
    }
    if (supportsServiceProtocol) {
      final vmservice.Response reloadResponse = await _vmService.callServiceExtension('hotRestart');
      status.stop();
      printStatus('Restarted application in ${getElapsedAsMilliseconds(timer.elapsed)}.');
      return reloadResponse.type == 'Success'
          ? OperationResult.ok
          : OperationResult(1, reloadResponse.toString());
    }
    // If we're not in hot mode, the only way to restart is to reload the tab.
    await _webFs.hardRefresh();
    status.stop();
    return OperationResult.ok;
  }

  @override
  Future<void> debugDumpApp() async {
    try {
      await _vmService.callServiceExtension(
        'ext.flutter.debugDumpApp',
      );
    } on vmservice.RPCError {
      return;
    }
  }

  @override
  Future<void> debugDumpRenderTree() async {
    try {
      await _vmService.callServiceExtension(
        'ext.flutter.debugDumpRenderTree',
      );
    } on vmservice.RPCError {
      return;
    }
  }

  @override
  Future<void> debugDumpLayerTree() async {
    try {
      await _vmService.callServiceExtension(
        'ext.flutter.debugDumpLayerTree',
      );
    } on vmservice.RPCError {
      return;
    }
  }

  @override
  Future<void> debugDumpSemanticsTreeInTraversalOrder() async {
    try {
      await _vmService.callServiceExtension(
          'ext.flutter.debugDumpSemanticsTreeInTraversalOrder');
    } on vmservice.RPCError {
      return;
    }
  }

  @override
  Future<void> debugDumpSemanticsTreeInInverseHitTestOrder() async {
    try {
      await _vmService.callServiceExtension(
          'ext.flutter.debugDumpSemanticsTreeInInverseHitTestOrder');
    } on vmservice.RPCError {
      return;
    }
  }


  @override
  Future<void> debugToggleDebugPaintSizeEnabled() async {
    try {
      final vmservice.Response response = await _vmService.callServiceExtension(
        'ext.flutter.debugPaint',
      );
      await _vmService.callServiceExtension(
        'ext.flutter.debugPaint',
        args: <dynamic, dynamic>{'enabled': !(response.json['enabled'] == 'true')},
      );
    } on vmservice.RPCError {
      return;
    }
  }

  @override
  Future<void> debugToggleDebugCheckElevationsEnabled() async {
    try {
      final vmservice.Response response = await _vmService.callServiceExtension(
        'ext.flutter.debugCheckElevationsEnabled',
      );
      await _vmService.callServiceExtension(
        'ext.flutter.debugCheckElevationsEnabled',
        args: <dynamic, dynamic>{'enabled': !(response.json['enabled'] == 'true')},
      );
    } on vmservice.RPCError {
      return;
    }
  }

  @override
  Future<void> debugTogglePerformanceOverlayOverride() async {
    try {
      final vmservice.Response response = await _vmService.callServiceExtension(
        'ext.flutter.showPerformanceOverlay'
      );
      await _vmService.callServiceExtension(
        'ext.flutter.showPerformanceOverlay',
        args: <dynamic, dynamic>{'enabled': !(response.json['enabled'] == 'true')},
      );
    } on vmservice.RPCError {
      return;
    }
  }

  @override
  Future<void> debugToggleWidgetInspector() async {
    try {
      final vmservice.Response response = await _vmService.callServiceExtension(
        'ext.flutter.debugToggleWidgetInspector'
      );
      await _vmService.callServiceExtension(
        'ext.flutter.debugToggleWidgetInspector',
        args: <dynamic, dynamic>{'enabled': !(response.json['enabled'] == 'true')},
      );
    } on vmservice.RPCError {
      return;
    }
  }

  @override
  Future<void> debugToggleProfileWidgetBuilds() async {
    try {
      final vmservice.Response response = await _vmService.callServiceExtension(
        'ext.flutter.profileWidgetBuilds'
      );
      await _vmService.callServiceExtension(
        'ext.flutter.profileWidgetBuilds',
        args: <dynamic, dynamic>{'enabled': !(response.json['enabled'] == 'true')},
      );
    } on vmservice.RPCError {
      return;
    }
  }
}
