import 'package:flutter/material.dart';
import 'package:todorestapi/todoscreen.dart';
import 'package:todorestapi/addtodo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        TodoScreen.id:(context) => const TodoScreen(),
        AddTodo.id:(context) => const AddTodo()
      },
      initialRoute: TodoScreen.id,
    );
  }
}
