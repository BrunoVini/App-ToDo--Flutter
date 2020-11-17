import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/Todo.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;
  final int index;

  TodoItem({Key key, @required this.todo, @required this.index})
      : super(key: key);

  @override
  _TodoItemState createState() => _TodoItemState(todo, index); // todo
}

class _TodoItemState extends State<TodoItem> {
  Todo _todo;
  int _index;
  String appBarTitle;

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final key = GlobalKey<ScaffoldState>();

  _TodoItemState(Todo todo, int index) {
    this._todo = todo;
    this._index = index;
    if (_todo != null) {
      _tituloController.text = _todo.title;
      _descricaoController.text = _todo.description;
      appBarTitle = 'Tarefa: ${_todo.title}';
    } else {
      appBarTitle = 'Criar Item';
    }
  }

  _saveItem() async {
    if (_tituloController.text.isEmpty || _descricaoController.text.isEmpty) {
      key.currentState.showSnackBar(SnackBar(
        content: Text('Título e descrição são obrigatórios.'),
      ));
    } else if (_tituloController.text.length > 25) {
      key.currentState.showSnackBar(
          SnackBar(content: Text('O Título tem um limite de 25 caracteres')));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Todo> list = [];

      var data = prefs.getString('list');
      if (data != null) {
        var objs = jsonDecode(data) as List;
        list = objs.map((obj) => Todo.fromJson(obj)).toList();
      }

      _todo = Todo.fromTitleDescription(
          _tituloController.text, _descricaoController.text);
      if (_index != -1) {
        list[_index] = _todo;
      } else {
        list.add(_todo);
      }

      prefs.setString('list', jsonEncode(list));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(appBarTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _tituloController,
              decoration: (InputDecoration(
                  hintText: 'Título',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descricaoController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: (InputDecoration(
                  hintText: 'Descrição',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonTheme(
              minWidth: double.infinity,
              height: 45,
              child: RaisedButton(
                child: Text('Salvar', style: TextStyle(fontSize: 16)),
                onPressed: () => {_saveItem()},
                elevation: 6.2,
                color: Colors.green,
                textColor: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
