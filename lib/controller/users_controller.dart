import 'package:get/get.dart';

//userList에 대한 getx_controller
class UsersController extends GetxController {
  RxList<dynamic> users = [].obs;

  //DB에서 받아온 유저 목록을 컨트롤 변수에 할당하여 실시간으로 화면에 바로 반영되도록 하기 위한 함수
  void setUsers(List<dynamic> list) {
    users.clear();
    users.addAll(list.obs);
  }
}
