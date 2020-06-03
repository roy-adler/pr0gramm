class Pr0grammTag {
  final int id;
  final double confidence;
  final String tag;
  final double padd = 6;
  final double roundness = 6;
  final double marg = 4;

  Pr0grammTag({this.id, this.confidence, this.tag});

  factory Pr0grammTag.fromJson(Map<String, dynamic> parsedJson) {
    return Pr0grammTag(
      id: parsedJson['id'],
      confidence: parsedJson['confidence'],
      tag: parsedJson['tag'],
    );
  }
}
