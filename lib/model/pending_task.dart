class PendingTask {
  int _id;
  String _name;
  String _created;

  PendingTask(this._name, this._created);

  PendingTask.map(dynamic object) {
    this._id = object["id"];
    this._name = object["name"];
    this._created = object["created"];
  }

  int get id => _id;

  String get name => _name;

  String get created => _created;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_id != null) map["id"] = _id;

    map["name"] = _name;
    map["created"] = _created;

    return map;
  }

  PendingTask.fromMap(Map<String, dynamic> map) {
    this._id = map ["id"];
    this._name = map["name"];
    this._created = map["created"];
  }
}
