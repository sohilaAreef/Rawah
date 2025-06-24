enum EntryType { achievement, gratitude }

class Entry {
  final String id;
  final EntryType type;
  final String text;
  final DateTime date;
  bool isCompleted;

  Entry({
    required this.id,
    required this.type,
    required this.text,
    required this.date,
    this.isCompleted = false,
  });
}
