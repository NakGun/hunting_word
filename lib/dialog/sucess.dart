import 'package:flutter/material.dart';

class SucessDialog extends StatefulWidget {
  @override
  _SucessDialogState createState() => _SucessDialogState();
}

class _SucessDialogState extends State<SucessDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [],
      content: Container(
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Sucess!!',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Genius~!!',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(child: SizedBox()),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                  minimumSize: Size(120, 30),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Home',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
