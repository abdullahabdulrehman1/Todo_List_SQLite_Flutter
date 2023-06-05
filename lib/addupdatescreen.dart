import 'package:flutter/material.dart';
import 'package:todolistsqlite/homescreen.dart';
import 'package:todolistsqlite/model/databasehandler.dart';
import 'package:todolistsqlite/model/model.dart';

class AddUpdateTask extends StatefulWidget {
  final int? todoId;
  final String? initialTitle;
  final String? initialDesc;

  const AddUpdateTask({
    Key? key,
    this.todoId,
    this.initialTitle,
    this.initialDesc,
  }) : super(key: key);

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  DBhelper? dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBhelper();
    _titleController.text = widget.initialTitle ?? '';
    _descController.text = widget.initialDesc ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitTask() async {
    String title = _titleController.text.trim();
    String desc = _descController.text.trim();

    if (title.isNotEmpty && desc.isNotEmpty) {
      if (widget.todoId != null) {
        // Edit existing task
        await dbHelper!.update(
          Todomodel(
            id: widget.todoId,
            title: title,
            desc: desc,
          ),
        );
      } else {
        // Add new task
        await dbHelper!.insert(
          Todomodel(
            title: title,
            desc: desc,
          ),
        );
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  void _clearFields() {
    _titleController.clear();
    _descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Add Task'), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _submitTask,
                  child: const Text('Submit'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
