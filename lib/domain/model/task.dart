// TODO: Consider adding an id
class Task {
  late final String _name;
  late final DateTime _startTimestamp;
  late final DateTime _endTimestamp;
  late final String _details;

  Task(String name, DateTime startTimestamp, DateTime endTimestamp, String details) {
    _name = name;
    _startTimestamp = startTimestamp;
    _endTimestamp = endTimestamp;
    _details = details;
  }

  String get name => _name;

  DateTime get startTimestamp => _startTimestamp;

  DateTime get endTimestamp => _endTimestamp;

  String get details => _details;
}