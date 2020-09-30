class Band {
  String id;
  String name;
  int votes;

  Band({
    this.id,
    this.name,
    this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        id: obj['id'] ?? DateTime.now(),
        name: obj['name'] ?? 'no name',
        votes: obj['votes'] ?? 1,
      );
}
