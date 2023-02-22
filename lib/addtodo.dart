import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AddTodo extends StatefulWidget {
  final Map? todo;
  static const String id = 'AddTodo';
  const AddTodo({super.key, this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo=widget.todo;
    if(todo!=null){
      isEdit=true;
      final title=todo['title'];
      final description=todo['description'];
      titleController.text=title;
      descriptionController.text=description;
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEdit?'Edit Todo':'Add Todo',
          ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          ElevatedButton(onPressed: isEdit?updateData:submitData, child: Text(isEdit?'Update':'Submit'))
        ],
      ),
    );
  }

  Future<void> updateData() async{
    //get the data from form
    //submit data to server
    //show success or failure message
    final todo=widget.todo;
    final id=todo!['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final url='https://api.nstack.in/v1/todos/$id';
    final uri=Uri.parse(url);
    final response=await http.put(uri,body: jsonEncode(body),headers: {'Content-Type':'application/json'}); 
  }

  Future<void> submitData() async{
    //get the data from form
    //submit data to server
    //show success or failure message
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final url='https://api.nstack.in/v1/todos';
    final uri=Uri.parse(url);
    final response=await http.post(uri,body: jsonEncode(body),headers: {'Content-Type':'application/json'});
    // print(response.body);
    if(response.statusCode==201){
      titleController.text='';
      descriptionController.text='';
    }
  }
}
