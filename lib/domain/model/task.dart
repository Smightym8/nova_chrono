class Task {
  late final String _id;
  late final String _name;
  late final DateTime _startTimestamp;
  late final DateTime _endTimestamp;
  late final String _details;

  Task(String id, String name, DateTime startTimestamp, DateTime endTimestamp,
      String details) {
    _id = id;
    _name = name;
    _startTimestamp = startTimestamp;
    _endTimestamp = endTimestamp;
    _details = details;
  }

  String get id => _id;

  String get name => _name;

  DateTime get startTimestamp => _startTimestamp;

  DateTime get endTimestamp => _endTimestamp;

  String get details => _details;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'startTimestamp': _startTimestamp.toString(),
      'endTimestamp': _endTimestamp.toString(),
      'details': _details
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}