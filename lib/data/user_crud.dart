import 'dart:convert';

import 'package:dio/dio.dart' as http;
import 'package:get/get.dart';
import 'package:word_game/controller/users_controller.dart';

const URL = 'http://211.37.147.110/';
//const URL = 'http://localhost/';
// http.Response response = new http.Response();
http.Dio dio = new http.Dio();

class UserCrud {
  UsersController _usersController = Get.put(UsersController());

  Future<List<dynamic>> getAllUser() async {
    var formData = http.FormData.fromMap({'table': 'users', 'crud_tp': 'all'});
    http.Response response = await dio.post('$URL/crud/users_crud.php', data: formData);
    print('>>>>>>>>>>>>>>>>>>>>>>${response.data}');
    List<dynamic> users = jsonDecode(response.data);
    _usersController.setUsers(users);
    return users;
    // return jsonDecode(response.data);
  }

  Future<dynamic> getUser(String id) async {
    var whereMap = {
      'id': id,
    };

    var formData = http.FormData.fromMap(
        {'table': 'users', 'crud_tp': 'mine', 'user_info': 'nothing', 'where_map': whereMap});
    http.Response response = await dio.post('$URL/crud/users_crud.php', data: formData);

    //삭제된 후 리스트를 컨트롤러에 전달하여 업데이트함
    var user = jsonDecode(response.data);

    return user;
  }

  //DB에 유저 등록 인자값 전달
  Future<String> addUser(String id, String name, int count, String grade) async {
    var usrMap = {
      'id': id,
      'name': name,
      'count': count,
      'grade': grade,
    };

    // var formData = http.FormData.fromMap(
    //     {'table': 'users', 'crud_tp': 'insert', 'user_info': usrMap, 'where_map': 'nothing'});

    var formData = http.FormData.fromMap(
        {'table': 'users', 'crud_tp': 'insert', 'user_info': usrMap, 'where_map': ''});

    // response = await dio.post('$URL/add.php', data: formData);
    http.Response response = await dio.post('$URL/crud/users_crud.php', data: formData);
    return response.data;
  }

  Future<void> updateUser(String id, String name, int count, String grade) async {
    var usrMap = {
      'id': id,
      'name': name,
      'count': count,
      'grade': grade,
    };
    var whereMap = {
      'id': id,
    };

    var formData = http.FormData.fromMap(
        {'table': 'users', 'crud_tp': 'update', 'user_info': usrMap, 'where_map': whereMap});

    http.Response response = await dio.post('$URL/crud/users_crud.php', data: formData);
  }

  Future<void> deleteUser(String id) async {
    var whereMap = {
      'id': id,
    };

    var formData = http.FormData.fromMap(
        {'table': 'users', 'crud_tp': 'delete', 'user_info': 'nothing', 'where_map': whereMap});
    http.Response response = await dio.post('$URL/crud/users_crud.php', data: formData);

    //삭제된 후 리스트를 컨트롤러에 전달하여 업데이트함
    List<dynamic> users = jsonDecode(response.data);
    _usersController.setUsers(users);
  }
}

//다른 소스에서 바로 한수로 접근하게 하기 위해 이렇게 선언하네
UserCrud userCrud = UserCrud();
