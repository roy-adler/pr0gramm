class Pr0User {
  final List<dynamic> tags;
  final List<dynamic> comments;
  final int ts;
  final String cache;
  final int rt;
  final int qc;

  Pr0User({
    this.tags,
    this.comments,
    this.ts,
    this.cache,
    this.rt,
    this.qc,
  });

  factory Pr0User.fromJson(Map<String, dynamic> parsedJson) {
    return Pr0User(
      tags: parsedJson['tags'],
      comments: parsedJson['comments'],
      ts: parsedJson['ts'],
      cache: parsedJson['cache'],
      rt: parsedJson['ts'],
      qc: parsedJson['qc'],
    );
  }
}
