class CommonTaskName {
  late final String _id;
  late String _name;

  CommonTaskName(String id, String name,) {
    _id = id;
    _name = name;
  }

  String get id => _id;

  String get name => _name;

  void update(String name) {
    _name = name;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommonTaskName &&
          runtimeType == other.runtimeType &&
          _name == other._name;

  @override
  int get hashCode => _name.hashCode;
}