// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_tools/src/application_package.dart';
import 'package:flutter_tools/src/artifacts.dart';
import 'package:flutter_tools/src/base/file_system.dart';
import 'package:flutter_tools/src/base/io.dart';
import 'package:flutter_tools/src/build_info.dart';
import 'package:flutter_tools/src/cache.dart';
import 'package:flutter_tools/src/device.dart';
import 'package:flutter_tools/src/ios/devices.dart';
import 'package:flutter_tools/src/ios/mac.dart';
import 'package:flutter_tools/src/macos/xcode.dart';
import 'package:flutter_tools/src/mdns_discovery.dart';
import 'package:flutter_tools/src/project.dart';
import 'package:flutter_tools/src/reporting/reporting.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';

import '../../src/common.dart';
import '../../src/context.dart';
import '../../src/mocks.dart';

class MockIOSApp extends Mock implements IOSApp {}
class MockArtifacts extends Mock implements Artifacts {}
class MockCache extends Mock implements Cache {}
class MockDirectory extends Mock implements Directory {}
class MockFileSystem extends Mock implements FileSystem {}
class MockIMobileDevice extends Mock implements IMobileDevice {}
class MockMDnsObservatoryDiscovery extends Mock implements MDnsObservatoryDiscovery {}
class MockXcode extends Mock implements Xcode {}
class MockFile extends Mock implements File {}
class MockPortForwarder extends Mock implements DevicePortForwarder {}
class MockUsage extends Mock implements Usage {}

void main() {
  final FakePlatform macPlatform = FakePlatform.fromPlatform(const LocalPlatform());
  macPlatform.operatingSystem = 'macos';
  final FakePlatform linuxPlatform = FakePlatform.fromPlatform(const LocalPlatform());
  linuxPlatform.operatingSystem = 'linux';
  final FakePlatform windowsPlatform = FakePlatform.fromPlatform(const LocalPlatform());
  windowsPlatform.operatingSystem = 'windows';

  group('IOSDevice', () {
    final List<Platform> unsupportedPlatforms = <Platform>[linuxPlatform, windowsPlatform];

    testUsingContext('successfully instantiates on Mac OS', () {
      IOSDevice('device-123');
    }, overrides: <Type, Generator>{
      Platform: () => macPlatform,
    });

    for (Platform platform in unsupportedPlatforms) {
      testUsingContext('throws UnsupportedError exception if instantiated on ${platform.operatingSystem}', () {
        expect(
            () { IOSDevice('device-123'); },
            throwsA(isInstanceOf<AssertionError>())
        );
      }, overrides: <Type, Generator>{
        Platform: () => platform,
      });
    }

    group('startApp', () {
      MockIOSApp mockApp;
      MockArtifacts mockArtifacts;
      MockCache mockCache;
      MockFileSystem mockFileSystem;
      MockProcessManager mockProcessManager;
      MockDeviceLogReader mockLogReader;
      MockMDnsObservatoryDiscovery mockMDnsObservatoryDiscovery;
      MockPortForwarder mockPortForwarder;
      MockUsage mockUsage;

      const int devicePort = 499;
      const int hostPort = 42;
      const String installerPath = '/path/to/ideviceinstaller';
      const String iosDeployPath = '/path/to/iosdeploy';
      // const String appId = '789';
      const MapEntry<String, String> libraryEntry = MapEntry<String, String>(
          'DYLD_LIBRARY_PATH',
          '/path/to/libraries'
      );
      final Map<String, String> env = Map<String, String>.fromEntries(
          <MapEntry<String, String>>[libraryEntry]
      );

      setUp(() {
        mockApp = MockIOSApp();
        mockArtifacts = MockArtifacts();
        mockCache = MockCache();
        when(mockCache.dyLdLibEntry).thenReturn(libraryEntry);
        mockFileSystem = MockFileSystem();
        mockMDnsObservatoryDiscovery = MockMDnsObservatoryDiscovery();
        mockProcessManager = MockProcessManager();
        mockLogReader = MockDeviceLogReader();
        mockPortForwarder = MockPortForwarder();
        mockUsage = MockUsage();

        when(
            mockArtifacts.getArtifactPath(
                Artifact.ideviceinstaller,
                platform: anyNamed('platform'),
            )
        ).thenReturn(installerPath);

        when(
            mockArtifacts.getArtifactPath(
                Artifact.iosDeploy,
                platform: anyNamed('platform'),
            )
        ).thenReturn(iosDeployPath);

        when(mockPortForwarder.forward(devicePort, hostPort: anyNamed('hostPort')))
          .thenAnswer((_) async => hostPort);
        when(mockPortForwarder.forwardedPorts)
          .thenReturn(<ForwardedPort>[ForwardedPort(hostPort, devicePort)]);
        when(mockPortForwarder.unforward(any))
          .thenAnswer((_) async => null);

        const String bundlePath = '/path/to/bundle';
        final List<String> installArgs = <String>[installerPath, '-i', bundlePath];
        when(mockApp.deviceBundlePath).thenReturn(bundlePath);
        final MockDirectory directory = MockDirectory();
        when(mockFileSystem.directory(bundlePath)).thenReturn(directory);
        when(directory.existsSync()).thenReturn(true);
        when(mockProcessManager.run(installArgs, environment: env))
            .thenAnswer(
                (_) => Future<ProcessResult>.value(ProcessResult(1, 0, '', ''))
            );
      });

      tearDown(() {
        mockLogReader.dispose();
      });

      testUsingContext(' succeeds in debug mode via mDNS', () async {
        final IOSDevice device = IOSDevice('123');
        device.portForwarder = mockPortForwarder;
        device.setLogReader(mockApp, mockLogReader);
        final Uri uri = Uri(
          scheme: 'http',
          host: '127.0.0.1',
          port: 1234,
          path: 'observatory',
        );
        when(mockMDnsObservatoryDiscovery.getObservatoryUri(any, any, any))
          .thenAnswer((Invocation invocation) => Future<Uri>.value(uri));

        final LaunchResult launchResult = await device.startApp(mockApp,
          prebuiltApplication: true,
          debuggingOptions: DebuggingOptions.enabled(const BuildInfo(BuildMode.debug, null)),
          platformArgs: <String, dynamic>{},
        );
        verify(mockUsage.sendEvent('ios-mdns', 'success')).called(1);
        expect(launchResult.started, isTrue);
        expect(launchResult.hasObservatory, isTrue);
        expect(await device.stopApp(mockApp), isFalse);
      }, overrides: <Type, Generator>{
        Artifacts: () => mockArtifacts,
        Cache: () => mockCache,
        FileSystem: () => mockFileSystem,
        MDnsObservatoryDiscovery: () => mockMDnsObservatoryDiscovery,
        Platform: () => macPlatform,
        ProcessManager: () => mockProcessManager,
        Usage: () => mockUsage,
      });

      testUsingContext(' succeeds in debug mode when mDNS fails by falling back to manual protocol discovery', () async {
        final IOSDevice device = IOSDevice('123');
        device.portForwarder = mockPortForwarder;
        device.setLogReader(mockApp, mockLogReader);
        // Now that the reader is used, start writing messages to it.
        Timer.run(() {
          mockLogReader.addLine('Foo');
          mockLogReader.addLine('Observatory listening on http://127.0.0.1:$devicePort');
        });
        when(mockMDnsObservatoryDiscovery.getObservatoryUri(any, any, any))
          .thenAnswer((Invocation invocation) => Future<Uri>.value(null));

        final LaunchResult launchResult = await device.startApp(mockApp,
          prebuiltApplication: true,
          debuggingOptions: DebuggingOptions.enabled(const BuildInfo(BuildMode.debug, null)),
          platformArgs: <String, dynamic>{},
        );
        verify(mockUsage.sendEvent('ios-mdns', 'failure')).called(1);
        verify(mockUsage.sendEvent('ios-mdns', 'fallback-success')).called(1);
        expect(launchResult.started, isTrue);
        expect(launchResult.hasObservatory, isTrue);
        expect(await device.stopApp(mockApp), isFalse);
      }, overrides: <Type, Generator>{
        Artifacts: () => mockArtifacts,
        Cache: () => mockCache,
        FileSystem: () => mockFileSystem,
        MDnsObservatoryDiscovery: () => mockMDnsObservatoryDiscovery,
        Platform: () => macPlatform,
        ProcessManager: () => mockProcessManager,
        Usage: () => mockUsage,
      });

      testUsingContext(' fails in debug mode when mDNS fails and when Observatory URI is malformed', () async {
        final IOSDevice device = IOSDevice('123');
        device.portForwarder = mockPortForwarder;
        device.setLogReader(mockApp, mockLogReader);

        // Now that the reader is used, start writing messages to it.
        Timer.run(() {
          mockLogReader.addLine('Foo');
          mockLogReader.addLine('Observatory listening on http:/:/127.0.0.1:$devicePort');
        });
        when(mockMDnsObservatoryDiscovery.getObservatoryUri(any, any, any))
          .thenAnswer((Invocation invocation) => Future<Uri>.value(null));

        final LaunchResult launchResult = await device.startApp(mockApp,
            prebuiltApplication: true,
            debuggingOptions: DebuggingOptions.enabled(const BuildInfo(BuildMode.debug, null)),
            platformArgs: <String, dynamic>{},
        );
        verify(mockUsage.sendEvent('ios-mdns', 'failure')).called(1);
        verify(mockUsage.sendEvent('ios-mdns', 'fallback-failure')).called(1);
        expect(launchResult.started, isFalse);
        expect(launchResult.hasObservatory, isFalse);
      }, overrides: <Type, Generator>{
        Artifacts: () => mockArtifacts,
        Cache: () => mockCache,
        FileSystem: () => mockFileSystem,
        MDnsObservatoryDiscovery: () => mockMDnsObservatoryDiscovery,
        Platform: () => macPlatform,
        ProcessManager: () => mockProcessManager,
        Usage: () => mockUsage,
      });

      testUsingContext(' succeeds in release mode', () async {
        final IOSDevice device = IOSDevice('123');
        final LaunchResult launchResult = await device.startApp(mockApp,
          prebuiltApplication: true,
          debuggingOptions: DebuggingOptions.disabled(const BuildInfo(BuildMode.release, null)),
          platformArgs: <String, dynamic>{},
        );
        expect(launchResult.started, isTrue);
        expect(launchResult.hasObservatory, isFalse);
        expect(await device.stopApp(mockApp), isFalse);
      }, overrides: <Type, Generator>{
        Artifacts: () => mockArtifacts,
        Cache: () => mockCache,
        FileSystem: () => mockFileSystem,
        Platform: () => macPlatform,
        ProcessManager: () => mockProcessManager,
      });
    });

    group('Process calls', () {
      MockIOSApp mockApp;
      MockArtifacts mockArtifacts;
      MockCache mockCache;
      MockFileSystem mockFileSystem;
      MockProcessManager mockProcessManager;
      const String installerPath = '/path/to/ideviceinstaller';
      const String appId = '789';
      const MapEntry<String, String> libraryEntry = MapEntry<String, String>(
          'DYLD_LIBRARY_PATH',
          '/path/to/libraries'
      );
      final Map<String, String> env = Map<String, String>.fromEntries(
          <MapEntry<String, String>>[libraryEntry]
      );

      setUp(() {
        mockApp = MockIOSApp();
        mockArtifacts = MockArtifacts();
        mockCache = MockCache();
        when(mockCache.dyLdLibEntry).thenReturn(libraryEntry);
        mockFileSystem = MockFileSystem();
        mockProcessManager = MockProcessManager();
        when(
            mockArtifacts.getArtifactPath(
                Artifact.ideviceinstaller,
                platform: anyNamed('platform'),
            )
        ).thenReturn(installerPath);
      });

      testUsingContext('installApp() invokes process with correct environment', () async {
        final IOSDevice device = IOSDevice('123');
        const String bundlePath = '/path/to/bundle';
        final List<String> args = <String>[installerPath, '-i', bundlePath];
        when(mockApp.deviceBundlePath).thenReturn(bundlePath);
        final MockDirectory directory = MockDirectory();
        when(mockFileSystem.directory(bundlePath)).thenReturn(directory);
        when(directory.existsSync()).thenReturn(true);
        when(mockProcessManager.run(args, environment: env))
            .thenAnswer(
                (_) => Future<ProcessResult>.value(ProcessResult(1, 0, '', ''))
            );
        await device.installApp(mockApp);
        verify(mockProcessManager.run(args, environment: env));
      }, overrides: <Type, Generator>{
        Artifacts: () => mockArtifacts,
        Cache: () => mockCache,
        FileSystem: () => mockFileSystem,
        Platform: () => macPlatform,
        ProcessManager: () => mockProcessManager,
      });

      testUsingContext('isAppInstalled() invokes process with correct environment', () async {
        final IOSDevice device = IOSDevice('123');
        final List<String> args = <String>[installerPath, '--list-apps'];
        when(mockProcessManager.run(args, environment: env))
            .thenAnswer(
                (_) => Future<ProcessResult>.value(ProcessResult(1, 0, '', ''))
            );
        when(mockApp.id).thenReturn(appId);
        await device.isAppInstalled(mockApp);
        verify(mockProcessManager.run(args, environment: env));
      }, overrides: <Type, Generator>{
        Artifacts: () => mockArtifacts,
        Cache: () => mockCache,
        Platform: () => macPlatform,
        ProcessManager: () => mockProcessManager,
      });

      testUsingContext('uninstallApp() invokes process with correct environment', () async {
        final IOSDevice device = IOSDevice('123');
        final List<String> args = <String>[installerPath, '-U', appId];
        when(mockApp.id).thenReturn(appId);
        when(mockProcessManager.run(args, environment: env))
            .thenAnswer(
                (_) => Future<ProcessResult>.value(ProcessResult(1, 0, '', ''))
            );
        await device.uninstallApp(mockApp);
        verify(mockProcessManager.run(args, environment: env));
      }, overrides: <Type, Generator>{
        Artifacts: () => mockArtifacts,
        Cache: () => mockCache,
        Platform: () => macPlatform,
        ProcessManager: () => mockProcessManager,
      });
    });
  });

  group('getAttachedDevices', () {
    MockIMobileDevice mockIMobileDevice;

    setUp(() {
      mockIMobileDevice = MockIMobileDevice();
    });

    testUsingContext('return no devices if Xcode is not installed', () async {
      when(mockIMobileDevice.isInstalled).thenReturn(false);
      expect(await IOSDevice.getAttachedDevices(), isEmpty);
    }, overrides: <Type, Generator>{
      IMobileDevice: () => mockIMobileDevice,
      Platform: () => macPlatform,
    });

    testUsingContext('returns no devices if none are attached', () async {
      when(iMobileDevice.isInstalled).thenReturn(true);
      when(iMobileDevice.getAvailableDeviceIDs())
          .thenAnswer((Invocation invocation) => Future<String>.value(''));
      final List<IOSDevice> devices = await IOSDevice.getAttachedDevices();
      expect(devices, isEmpty);
    }, overrides: <Type, Generator>{
      IMobileDevice: () => mockIMobileDevice,
      Platform: () => macPlatform,
    });

    final List<Platform> unsupportedPlatforms = <Platform>[linuxPlatform, windowsPlatform];
    for (Platform platform in unsupportedPlatforms) {
      testUsingContext('throws Unsupported Operation exception on ${platform.operatingSystem}', () async {
        when(iMobileDevice.isInstalled).thenReturn(false);
        when(iMobileDevice.getAvailableDeviceIDs())
            .thenAnswer((Invocation invocation) => Future<String>.value(''));
        expect(
            () async { await IOSDevice.getAttachedDevices(); },
            throwsA(isInstanceOf<UnsupportedError>()),
        );
      }, overrides: <Type, Generator>{
        IMobileDevice: () => mockIMobileDevice,
        Platform: () => platform,
      });
    }

    testUsingContext('returns attached devices', () async {
      when(iMobileDevice.isInstalled).thenReturn(true);
      when(iMobileDevice.getAvailableDeviceIDs())
          .thenAnswer((Invocation invocation) => Future<String>.value('''
98206e7a4afd4aedaff06e687594e089dede3c44
f577a7903cc54959be2e34bc4f7f80b7009efcf4
'''));
      when(iMobileDevice.getInfoForDevice('98206e7a4afd4aedaff06e687594e089dede3c44', 'DeviceName'))
          .thenAnswer((_) => Future<String>.value('La tele me regarde'));
      when(iMobileDevice.getInfoForDevice('98206e7a4afd4aedaff06e687594e089dede3c44', 'ProductVersion'))
          .thenAnswer((_) => Future<String>.value('10.3.2'));
      when(iMobileDevice.getInfoForDevice('f577a7903cc54959be2e34bc4f7f80b7009efcf4', 'DeviceName'))
          .thenAnswer((_) => Future<String>.value('Puits sans fond'));
      when(iMobileDevice.getInfoForDevice('f577a7903cc54959be2e34bc4f7f80b7009efcf4', 'ProductVersion'))
          .thenAnswer((_) => Future<String>.value('11.0'));
      final List<IOSDevice> devices = await IOSDevice.getAttachedDevices();
      expect(devices, hasLength(2));
      expect(devices[0].id, '98206e7a4afd4aedaff06e687594e089dede3c44');
      expect(devices[0].name, 'La tele me regarde');
      expect(devices[1].id, 'f577a7903cc54959be2e34bc4f7f80b7009efcf4');
      expect(devices[1].name, 'Puits sans fond');
    }, overrides: <Type, Generator>{
      IMobileDevice: () => mockIMobileDevice,
      Platform: () => macPlatform,
    });

    testUsingContext('returns attached devices and ignores devices that cannot be found by ideviceinfo', () async {
      when(iMobileDevice.isInstalled).thenReturn(true);
      when(iMobileDevice.getAvailableDeviceIDs())
          .thenAnswer((Invocation invocation) => Future<String>.value('''
98206e7a4afd4aedaff06e687594e089dede3c44
f577a7903cc54959be2e34bc4f7f80b7009efcf4
'''));
      when(iMobileDevice.getInfoForDevice('98206e7a4afd4aedaff06e687594e089dede3c44', 'DeviceName'))
          .thenAnswer((_) => Future<String>.value('La tele me regarde'));
      when(iMobileDevice.getInfoForDevice('f577a7903cc54959be2e34bc4f7f80b7009efcf4', 'DeviceName'))
          .thenThrow(const IOSDeviceNotFoundError('Device not found'));
      final List<IOSDevice> devices = await IOSDevice.getAttachedDevices();
      expect(devices, hasLength(1));
      expect(devices[0].id, '98206e7a4afd4aedaff06e687594e089dede3c44');
      expect(devices[0].name, 'La tele me regarde');
    }, overrides: <Type, Generator>{
      IMobileDevice: () => mockIMobileDevice,
      Platform: () => macPlatform,
    });
  });

  group('decodeSyslog', () {
    test('decodes a syslog-encoded line', () {
      final String decoded = decodeSyslog(r'I \M-b\M^]\M-$\M-o\M-8\M^O syslog \M-B\M-/\134_(\M-c\M^C\M^D)_/\M-B\M-/ \M-l\M^F\240!');
      expect(decoded, r'I ❤️ syslog ¯\_(ツ)_/¯ 솠!');
    });

    test('passes through un-decodeable lines as-is', () {
      final String decoded = decodeSyslog(r'I \M-b\M^O syslog!');
      expect(decoded, r'I \M-b\M^O syslog!');
    });
  });
  group('logging', () {
    MockIMobileDevice mockIMobileDevice;
    MockIosProject mockIosProject;

    setUp(() {
      mockIMobileDevice = MockIMobileDevice();
      mockIosProject = MockIosProject();
    });

    testUsingContext('suppresses non-Flutter lines from output', () async {
      when(mockIMobileDevice.startLogger('123456')).thenAnswer((Invocation invocation) {
        final Process mockProcess = MockProcess(
          stdout: Stream<List<int>>.fromIterable(<List<int>>['''
Runner(Flutter)[297] <Notice>: A is for ari
Runner(libsystem_asl.dylib)[297] <Notice>: libMobileGestalt MobileGestaltSupport.m:153: pid 123 (Runner) does not have sandbox access for frZQaeyWLUvLjeuEK43hmg and IS NOT appropriately entitled
Runner(libsystem_asl.dylib)[297] <Notice>: libMobileGestalt MobileGestalt.c:550: no access to InverseDeviceID (see <rdar://problem/11744455>)
Runner(Flutter)[297] <Notice>: I is for ichigo
Runner(UIKit)[297] <Notice>: E is for enpitsu"
'''.codeUnits])
        );
        return Future<Process>.value(mockProcess);
      });

      final IOSDevice device = IOSDevice('123456');
      final DeviceLogReader logReader = device.getLogReader(
        app: BuildableIOSApp(mockIosProject),
      );

      final List<String> lines = await logReader.logLines.toList();
      expect(lines, <String>['A is for ari', 'I is for ichigo']);
    }, overrides: <Type, Generator>{
      IMobileDevice: () => mockIMobileDevice,
      Platform: () => macPlatform,
    });
    testUsingContext('includes multi-line Flutter logs in the output', () async {
      when(mockIMobileDevice.startLogger('123456')).thenAnswer((Invocation invocation) {
        final Process mockProcess = MockProcess(
          stdout: Stream<List<int>>.fromIterable(<List<int>>['''
Runner(Flutter)[297] <Notice>: This is a multi-line message,
  with another Flutter message following it.
Runner(Flutter)[297] <Notice>: This is a multi-line message,
  with a non-Flutter log message following it.
Runner(libsystem_asl.dylib)[297] <Notice>: libMobileGestalt
'''.codeUnits]),
        );
        return Future<Process>.value(mockProcess);
      });

      final IOSDevice device = IOSDevice('123456');
      final DeviceLogReader logReader = device.getLogReader(
        app: BuildableIOSApp(mockIosProject),
      );

      final List<String> lines = await logReader.logLines.toList();
      expect(lines, <String>[
        'This is a multi-line message,',
        '  with another Flutter message following it.',
        'This is a multi-line message,',
        '  with a non-Flutter log message following it.',
      ]);
      expect(device.category, Category.mobile);
    }, overrides: <Type, Generator>{
      IMobileDevice: () => mockIMobileDevice,
      Platform: () => macPlatform,
    });
  });
  testUsingContext('IOSDevice.isSupportedForProject is true on module project', () async {
    fs.file('pubspec.yaml')
      ..createSync()
      ..writeAsStringSync(r'''
name: example

flutter:
  module: {}
''');
    fs.file('.packages').createSync();
    final FlutterProject flutterProject = FlutterProject.current();

    expect(IOSDevice('test').isSupportedForProject(flutterProject), true);
  }, overrides: <Type, Generator>{
    FileSystem: () => MemoryFileSystem(),
    Platform: () => macPlatform,
  });
  testUsingContext('IOSDevice.isSupportedForProject is true with editable host app', () async {
    fs.file('pubspec.yaml').createSync();
    fs.file('.packages').createSync();
    fs.directory('ios').createSync();
    final FlutterProject flutterProject = FlutterProject.current();

    expect(IOSDevice('test').isSupportedForProject(flutterProject), true);
  }, overrides: <Type, Generator>{
    FileSystem: () => MemoryFileSystem(),
    Platform: () => macPlatform,
  });

  testUsingContext('IOSDevice.isSupportedForProject is false with no host app and no module', () async {
    fs.file('pubspec.yaml').createSync();
    fs.file('.packages').createSync();
    final FlutterProject flutterProject = FlutterProject.current();

    expect(IOSDevice('test').isSupportedForProject(flutterProject), false);
  }, overrides: <Type, Generator>{
    FileSystem: () => MemoryFileSystem(),
    Platform: () => macPlatform,
  });
}
