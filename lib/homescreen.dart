import 'package:flutter/material.dart';
import 'package:todolistsqlite/addupdatescreen.dart';
import 'package:todolistsqlite/model/databasehandler.dart';
import 'package:todolistsqlite/model/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBhelper? dbHelper;
  late Future<List<Todomodel>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBhelper();
    loaddata();
  }

  void loaddata() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TodoList',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.help_outline_rounded, size: 30),
          ),
        ],
      ),
      body: FutureBuilder<List<Todomodel>>(
        future: dataList,
        builder:
            (BuildContext context, AsyncSnapshot<List<Todomodel>> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'NO TASKS',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  
                  key: Key(snapshot.data![index].id.toString()),
                  onDismissed: (direction) async {
                    // Remove the task from the database
                    await dbHelper!.delete(snapshot.data![index].id as int);

                    // Update the UI
                    setState(() {
                      snapshot.data!.removeAt(index);
                    });
                    // Show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task deleted'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(snapshot.data![index].title as String),
                    subtitle: Text(snapshot.data![index].desc as String),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUpdateTask(
                            initialTitle: snapshot.data![index].title!,
                            initialDesc: snapshot.data![index].desc!,
                            todoId: snapshot.data![index].id!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUpdateTask()),
          ).then((value) {
            setState(() {
              loaddata();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
