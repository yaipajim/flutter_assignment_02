import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/model/todoDB.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  } 
}

class MainPageState extends State<MainPage> {
  int _state = 0;
  static TodoCRUD todo = TodoCRUD();
  List<Todo> task = [];
  List<Todo> complete = [];

  @override
  Widget build(BuildContext context) {

    final List list_button = <Widget>[
      IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            Navigator.pushNamed(context, "/newsubject");
            },
          ),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            for(var item in complete){
              print(item.id);
              await todo.delete(item.id);
            }
            setState(() {
              complete = [];
            });
            },
          ),
    ];

    return DefaultTabController(
      length: 2,
      initialIndex: _state,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            _state == 0 ? list_button[0] : list_button[1]
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _state,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.list),
                title: Text("Task"),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.done_all),
                title: Text("Complete"),
              ),
            ],
            onTap: (index){
              setState(() {
                _state = index;
              });
              print(_state);
            }
          ),
        body: _state == 0 ?
        //is that screen 1 ? true ! 
        Container(
          child: FutureBuilder<List<Todo>>(
            future: todo.getAll(),
            builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              task = [];
              //check before load data
              if (snapshot.hasData){
                //add items in db to list
                for (var items in snapshot.data) {
                  if (items.done == false) {
                    task.add(items);
                  }
                }
                //have a data yet? yes!
                return task.length != 0 ? 
                  ListView.builder(
                    itemCount: task.length,
                    itemBuilder: (BuildContext context, int index) {
                      Todo item = task[index];
                      return ListTile(
                        title: Text(item.title),
                        trailing: Checkbox(
                        onChanged: (bool value) async {
                          setState(() {
                            item.done = value;
                          });
                          todo.update(item);
                          },
                        value: item.done,
                        ),
                      );
                    },
                  )
                  //Nope
                  : Center(
                    child: Text("No Data Found.."),
                  );
              //recieve uncomplete
              } else {
                return Center(
                  child: Text("No Data Found.."),
                );
              }
            }
          ),
        )
        :
        //Second screen
        Container(
          child: FutureBuilder<List<Todo>>(
            future: todo.getAll(),
            builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              complete = [];
              //check before load data
              if (snapshot.hasData){
                //add items in db to list
                for (var items in snapshot.data) {
                  if (items.done == true) {
                    complete.add(items);
                  }
                }
                //have a data yet? yes!
                return complete.length != 0 ? 
                  ListView.builder(
                    itemCount: complete.length,
                    itemBuilder: (BuildContext context, int index) {
                      Todo item = complete[index];
                      return ListTile(
                        title: Text(item.title),
                        trailing: Checkbox(
                        onChanged: (bool value) async {
                          setState(() {
                            item.done = value;
                          });
                          todo.update(item);
                          },
                        value: item.done,
                        ),
                      );
                    },
                  )
                  //Nope
                  : Center(
                    child: Text("No Data Found.."),
                  );
              //recieve uncomplete
              } else {
                return Center(
                  child: Text("No Data Found.."),
                );
              }
            }
          ),
        )
        ),  
    );
  }

}