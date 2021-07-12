import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_game/controller/user_controller.dart';
import 'package:word_game/data/user_crud.dart';
import 'package:word_game/screen/page_navigation.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  UserController _userController = Get.put(UserController());
  TextEditingController _name = TextEditingController();

  @override
  void initState() {
    _name.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Name',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: _name,
              readOnly: false,
              //textCapitalization: TextCapitalization.none,
              textAlign: TextAlign.center,
              maxLength: 20,
              style: TextStyle(fontSize: 30, color: Colors.black),
              //tab order
              autofocus: true,
              onChanged: (v) {},
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
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                  minimumSize: Size(120, 30),
                ),
                onPressed: () async {
                  String id = await _getId();

                  String result = await userCrud.addUser(id, _name.text, 0, '1');

                  if (result == '1') {
                    //유저정보 컨트롤에 등록
                    var user = await userCrud.getUser(id);
                    _userController.setUsers(
                        user['id'], user['name'], user['count'], user['grade']);

                    //유저등록되었으니 초기페이지로 이동
                    Get.offAll(() => PageNavigation());
                  }
                },
                child: Text(
                  '캐릭터생성',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
