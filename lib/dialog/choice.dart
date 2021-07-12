import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoiceDialog extends StatefulWidget {
  @override
  _ChoiceDialogState createState() => _ChoiceDialogState();
}

class _ChoiceDialogState extends State<ChoiceDialog> {
  List<String> list = [];
  TextEditingController _first = TextEditingController();
  TextEditingController _second = TextEditingController();
  TextEditingController _third = TextEditingController();

  bool _validate1 = false;
  bool _validate2 = false;
  bool _validate3 = false;

  @override
  void initState() {
    _first.text = '';
    _second.text = '';
    _third.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    _third.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //tab order
    final focus2 = FocusNode();
    final focus3 = FocusNode();

    return AlertDialog(
      actions: [],
      contentPadding: EdgeInsets.zero,
      content: Container(
        // margin: EdgeInsets.all(0),
        height: MediaQuery.of(context).size.height / 5,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: _first,
                        readOnly: false,
                        textCapitalization: TextCapitalization.none, //대소문자
                        enableInteractiveSelection: false,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(fontSize: 30, color: Colors.black),
                        //tab order
                        autofocus: true,
                        onChanged: (v) {
                          FocusScope.of(context).requestFocus(focus2);
                        },
                        decoration: InputDecoration(
                          //length count not visible
                          counterText: "",
                          //errorText: _validate1 ? 'Input first Alphabat!' : null,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        focusNode: focus2,
                        controller: _second,
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        enableInteractiveSelection: false,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(fontSize: 30, color: Colors.black),
                        //tab order
                        // textInputAction: TextInputAction.next,
                        // autofocus: true,
                        onChanged: (v) {
                          FocusScope.of(context).requestFocus(focus3);
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          //errorText: _validate2 ? 'Input second Alphabat!' : null,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        focusNode: focus3,
                        controller: _third,
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        enableInteractiveSelection: false,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(fontSize: 30, color: Colors.black),
                        //tab order
                        // textInputAction: TextInputAction.next,
                        //autofocus: true,
                        // onChanged: (v) {
                        //   FocusScope.of(context).requestFocus(focus);
                        // },
                        decoration: InputDecoration(
                          counterText: "",
                          //errorText: _validate3 ? 'Input third Alphabat!' : null,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                  minimumSize: Size(120, 30),
                ),
                onPressed: () {
                  setState(() {
                    list.clear();
                    _first.text == '' ? _validate1 = true : _validate1 = false;
                    _second.text == '' ? _validate2 = true : _validate2 = false;
                    _third.text == '' ? _validate3 = true : _validate3 = false;

                    list.add(_first.text);
                    list.add(_second.text);
                    list.add(_third.text);
                  });

                  if (_validate1) {
                    Get.dialog(waringDialog('1'));
                  } else if (_validate2) {
                    Get.dialog(waringDialog('2'));
                  } else if (_validate3) {
                    Get.dialog(waringDialog('3'));
                  } else {
                    Navigator.of(context).pop(list);
                  }
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }

  SimpleDialog waringDialog(String position) {
    return SimpleDialog(
        title: Container(
      height: 40,
      child: Text(position == '1'
          ? 'Input first Alphabat!'
          : position == '2'
              ? 'Input second Alphabat!'
              : 'Input third Alphabat!'),
    ));
  }
}
