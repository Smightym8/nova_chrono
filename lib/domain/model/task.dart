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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          _name == other._name &&
          _startTimestamp == other._startTimestamp &&
          _endTimestamp == other._endTimestamp &&
          _details == other._details;

  @override
  int get hashCode =>
      _name.hashCode ^
      _startTimestamp.hashCode ^
      _endTimestamp.hashCode ^
      _details.hashCode;
}