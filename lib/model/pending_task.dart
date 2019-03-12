import 'package:flutter/material.dart';

class PendingTask extends StatelessWidget {
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
    this._id = map["id"];
    this._name = map["name"];
    this._created = map["created"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _name,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Container(
              margin: EdgeInsets.only(top: 5),
              child: Text("Created on $_created",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic)))
        ],
      ),
    );
  }
}
