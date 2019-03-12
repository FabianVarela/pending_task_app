import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pending_task_app/database/database_helper.dart';
import 'package:pending_task_app/model/pending_task.dart';
import 'package:pending_task_app/utils/utils.dart';

class PendingTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PendingTaskScreenState();
}

class PendingTaskScreenState extends State<PendingTaskScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _itemEditingController = TextEditingController();

  var db = DatabaseHelper();
  final List<PendingTask> _itemList = <PendingTask>[];

  @override
  void initState() {
    super.initState();
    _readList();
  }

  void _handleSubmit(String value) async {
    _itemController.clear();

    PendingTask pendingTask = PendingTask(value, dateFormatted());

    int itemId = await db.saveItem(pendingTask);
    PendingTask pendingTaskAdded = await db.getItem(itemId);

    setState(() {
      _itemList.insert(0, pendingTaskAdded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  reverse: false,
                  itemCount: _itemList.length,
                  itemBuilder: (BuildContext context, int position) {
                    return Card(
                      color: Colors.white10,
                      child: ListTile(
                        title: _itemList[position],
                        onLongPress: () =>
                            _updateItem(_itemList[position], position),
                        trailing: Listener(
                          key: Key(_itemList[position].name),
                          child: Icon(Icons.remove_circle,
                              color: Colors.redAccent),
                          onPointerDown: (event) =>
                              _deleteTask(_itemList[position].id, position),
                        ),
                      ),
                    );
                  })),
          Divider(
            height: 1,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add item",
          backgroundColor: Colors.redAccent,
          child: ListTile(
            title: Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alertDialogAndroid = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _itemController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "e.g. Don't by stuff",
                  icon: Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _handleSubmit(_itemController.text);
              _itemController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );

    var alertDialogIOS = CupertinoAlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoTextField(
                placeholder: "e.g. Don't by stuff",
                controller: _itemController,
                autofocus: true),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _handleSubmit(_itemController.text);
              _itemController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Platform.isAndroid ? alertDialogAndroid : alertDialogIOS;
        });
  }

  void _readList() async {
    List items = await db.getTasks();
    items.forEach((item) {
      setState(() {
        _itemList.add(PendingTask.map(item));
      });
    });
  }

  void _deleteTask(int id, int position) async {
    debugPrint("Delete item");

    await db.deleteItem(id);

    setState(() {
      _itemList.removeAt(position);
    });
  }

  void _updateItem(PendingTask pendingTask, int position) {
    _itemEditingController.text = pendingTask.name;

    var alertDialog = AlertDialog(
      title: Text("Update item"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _itemEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "e.g. Don't by stuff",
                  icon: Icon(Icons.update)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              PendingTask pendingTaskToUpdate = PendingTask.fromMap({
                "id": pendingTask.id,
                "name": _itemEditingController.text,
                "created": dateFormatted()
              });

              _handleUpdate(position, pendingTask);
              await db.updateItem(pendingTaskToUpdate);

              setState(() {
                _readList();
              });

              _itemEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Update")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void _handleUpdate(int index, PendingTask item) {
    setState(() {
      _itemList.removeWhere((element) => element.name == item.name);
    });
  }
}
