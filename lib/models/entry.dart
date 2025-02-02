enum EntryType {
  achievement,
  gratitude,
}

class Entry {
  final EntryType type;
  final String text;
  final DateTime date;

  Entry({required this.type, required this.text, required this.date});
}
