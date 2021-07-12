import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_game/controller/user_controller.dart';
import 'package:word_game/data/user_crud.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:word_game/screen/collection.dart';
import 'package:word_game/screen/create_user.dart';
import 'package:word_game/screen/home.dart';
import 'package:word_game/screen/user_list.dart';

class PageNavigation extends StatefulWidget {
  @override
  _PageNavigationState createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> with WidgetsBindingObserver {
  UserController _userController = Get.put(UserController());
  PageController _pageController = new PageController();
  /* 종료팝업 */
  DateTime currentBackPressTime = DateTime.now();
  int selectedIndex = 0;

  // //user info
  var user;

  static List<Widget> _widgetOptions = [
    Home(),
    Collection(),
    UserList(),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    getUser();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
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

  void getUser() async {
    //내프로필정보 가져오기
    var serialNumber = await _getId();

    user = await userCrud.getUser(serialNumber);
    print(user);
    if (user == 'Fail') {
      Get.to(CreateUser());
    } else {
      _userController.setUsers(user['id'], user['name'], user['count'], user['grade']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageView(
          controller: _pageController,
          children: _widgetOptions,
          onPageChanged: (int) {
            setState(() {
              selectedIndex = int;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 32,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedItemColor: Colors.grey[900],
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(249, 249, 249, 1),
        items: <BottomNavigationBarItem>[
          // _buildBottomNavigationBarItem(activeIconPath: 'assets/profile_selected.png',iconPath: 'assets/profile.png',index: 1),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: 'COLLECTIONS'),
          BottomNavigationBarItem(icon: Icon(Icons.list_sharp), label: 'HUNTERS'),
          // BottomNavigationBarItem(icon: Icon(Icons.games), label: 'GAME'),
          // BottomNavigationBarItem(icon: Icon(Icons.list), label: 'RANK'),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }

  // BottomNavigationBarItem _buildBottomNavigationBarItem(
  //     {String activeIconPath, String iconPath, int index}) {
  //   return BottomNavigationBarItem(
  //     label: index == 1
  //         ? 'Home'
  //         : index == 2
  //             ? 'Town'
  //             : index == 3
  //                 ? 'Quick'
  //                 : index == 4
  //                     ? 'Online'
  //                     : index == 5
  //                         ? 'Gallery'
  //                         : index == 6
  //                             ? 'History'
  //                             : 'Friends',
  //     activeIcon: activeIconPath == null
  //         ? null
  //         : Stack(
  //             children: <Widget>[
  //               ImageIcon(AssetImage(activeIconPath)),
  //               index == 6
  //                   ? Positioned(
  //                       top: 0,
  //                       right: 0,
  //                       child: totalCount == 0
  //                           ? Text('')
  //                           : Container(
  //                               height: 12,
  //                               width: 12,
  //                               decoration: BoxDecoration(
  //                                 color: Colors.orangeAccent,
  //                                 borderRadius: BorderRadius.circular(10),
  //                               ),
  //                               child: Text(
  //                                 '$totalCount',
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                     )
  //                   : Text(''),
  //             ],
  //           ),
  //     icon: Stack(
  //       children: <Widget>[
  //         ImageIcon(AssetImage(iconPath)),
  //         index == 6
  //             ? Positioned(
  //                 top: 0,
  //                 right: 0,
  //                 child: totalCount == 0
  //                     ? Text('')
  //                     : Container(
  //                         height: 12,
  //                         width: 12,
  //                         decoration: BoxDecoration(
  //                           color: Colors.orangeAccent,
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         child: Text(
  //                           '$totalCount',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //               )
  //             : Text(''),
  //       ],
  //     ),
  //     //title: Text(''),
  //   );
  // }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(msg: '종료하시겠습니까?');
      return Future.value(false);
    } else {
      // showDialog(
      //   context: context,
      //   builder: (context) => AppCloseDialog(),
      // ).then((value) {
      //   if (value == 'Review') {
      //     LaunchReview.launch(
      //       androidAppId: "onedrive.live.connecting",
      //     );
      //   }
      //   SystemNavigator.pop();
      // });
    }
    return Future.value(false);
  }
}
