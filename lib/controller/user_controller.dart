import 'package:get/get.dart';

//userList에 대한 getx_controller
class UserController extends GetxController {
  RxList<dynamic> myInfo = ['', '', 0, ''].obs;

  //DB에서 받아온 유저 목록을 컨트롤 변수에 할당하여 실시간으로 화면에 바로 반영되도록 하기 위한 함수
  void setUsers(String id, String name, int count, String grade) {
    myInfo[0] = id;
    myInfo[1] = name;
    myInfo[2] = count;
    myInfo[3] = grade;
    // users.clear();
    // users.addAll(list.obs);
  }
}
