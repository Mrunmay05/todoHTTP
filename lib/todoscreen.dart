import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todorestapi/addtodo.dart';
import 'package:http/http.dart' as http;

class TodoScreen extends StatefulWidget {
  static const String id = 'TodoScreen';
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  bool isLoading=true;
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TODO APP'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: ((context, index) {
                final item = items[index] as Map;
                final id=item['_id'] as String;  
                return ListTile(
                  leading: CircleAvatar(child: Text('${index+1}')),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if(value=='edit'){
                        navigatetoEdit(item);
                      }
                      else{
                        deleteById(id);
                      }
                    },
                    itemBuilder:((context) {
                      return [
                        PopupMenuItem(child: Text('Edit'),value: 'edit',),
                        PopupMenuItem(child: Text('Delete'),value:'delete'),
                      ];
                    }) 
                    ),
                );
              })),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigatetoAdd();
          },
          label: const Text('Add todo')),
    );
  }

  Future<void> deleteById(String id) async{
    final url='https://api.nstack.in/v1/todos/$id';
    final uri=Uri.parse(url);
    final response=await http.delete(uri);
    if(response.statusCode==200){
      final filtered=items.where((element) => element['_id']!=id).toList();
      setState(() {
        items=filtered;
      });
    }
    else{}

  }

  Future <void> navigatetoAdd() async{
    final route=MaterialPageRoute(
      builder: (context)=>AddTodo(),
    );

    await Navigator.push(context,route);
    setState(() {
      isLoading=true;
    });
    fetchTodo();
  }

  void navigatetoEdit(Map item){
    final route=MaterialPageRoute(
      builder: (context)=>AddTodo(todo: item,),
    );

    Navigator.push(context,route);
  }


  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading=false;
    });

  }
}
