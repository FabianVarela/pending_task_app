import 'package:flutter/material.dart';
import 'package:pending_task_app/ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pending Tasks',
      home: Home(),
    );
  }
}
