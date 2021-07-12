import 'package:flutter/material.dart';
import 'package:word_game/data/user_crud.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('dfklsdahglk;dlkagdsfg');
    return Scaffold(
      appBar: AppBar(
        title: Text('UserList'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: userCrud.getAllUser(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                dynamic item = snapshot.data![index];
                print(item);
                return Dismissible(
                    key: UniqueKey(),
                    // onDismissed: (direction) {
                    //   LocalCRUD().deleteWord(item.myWord);
                    //   setState(() {});
                    // },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green[100],
                          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
                        ),
                        child: ListTile(
                          // leading: Text(item.myWord),
                          title: Text(item['name'],
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            item['count'].toString(),
                            style: TextStyle(fontSize: 25),
                          ),
                          // trailing: Text(
                          //   item['grade'],
                          //   style: TextStyle(fontSize: 25),
                          // ),
                        ),
                      ),
                    ));
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
