import 'package:flutter/material.dart';
import 'package:word_game/data/local_crud.dart';
import 'package:word_game/data/my_data.dart';

class Collection extends StatefulWidget {
  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Collection'),
      ),
      body: FutureBuilder(
        future: LocalCRUD().getAllWords(),
        builder: (BuildContext context, AsyncSnapshot<List<MyData>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                MyData item = snapshot.data![index];
                return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      LocalCRUD().deleteWord(item.myWord);
                      setState(() {});
                    },
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
                          title: Text(item.myWord,
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            item.meaning,
                            style: TextStyle(fontSize: 25),
                          ),
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
