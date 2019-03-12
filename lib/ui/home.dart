import 'package:flutter/material.dart';
import 'package:pending_task_app/ui/pending_task_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Pending tasks"), backgroundColor: Colors.black54),
      body: PendingTaskScreen(),
    );
  }
}
