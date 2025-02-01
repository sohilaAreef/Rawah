enum EntryType {
  achievement,
  gratitude,
}

class Entry {
  final EntryType type;
  final String title;
  final DateTime date;

  Entry({
    required this.type,
    required this.title,
    required this.date,
  });
}