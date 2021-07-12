import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_game/controller/user_controller.dart';
import 'package:word_game/data/local_crud.dart';
import 'package:word_game/data/my_data.dart';
import 'package:word_game/functions/make_quiz.dart';
import 'package:word_game/screen/hunt.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserController _userController = Get.put(UserController());

  MakeQuiz makeQuiz = new MakeQuiz();
  List<MyData> myCount = [];
  String rank = '';

  // Map<dynamic, dynamic> user = new Map();

  @override
  void initState() {
    getUser();
    // TODO: implement initState
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getUser() async {
    //내단어 가져오기
    myCount = await LocalCRUD().getAllWords();
    //랭크
    if (myCount.length < 20) {
      rank = 'D';
    } else if (myCount.length >= 20 && myCount.length <= 40) {
      rank = 'C';
    } else if (myCount.length >= 40 && myCount.length <= 60) {
      rank = 'B';
    } else if (myCount.length >= 60 && myCount.length <= 80) {
      rank = 'A';
    } else if (myCount.length >= 80 && myCount.length <= 100) {
      rank = 'S';
    } else if (myCount.length >= 100 && myCount.length <= 150) {
      rank = 'SS';
    } else if (myCount.length >= 150 && myCount.length <= 300) {
      rank = 'SSS';
    } else if (myCount.length > 300) {
      rank = 'Master';
    } else {
      rank = 'Grand Master';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //화면탭 인덱스
    int selectedIndex = 0;

    //문제만들기
    final Map word = makeQuiz.makeQuiz();

    //문제 문자열R
    String quiz = '';

    return Obx(() {
      if (_userController.myInfo.length > 0) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _userController.myInfo[1],
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Container(
            color: Colors.black,
            child: Column(
              children: [
                Container(
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Count : ',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Text(
                        _userController.myInfo[2].toString(),
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        'Rank : ',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          rank,
                          style: TextStyle(fontSize: 25, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          //primary: Colors.red, // background
                          onPrimary: Colors.white, // foreground
                          minimumSize: Size(200, 50)),
                      onPressed: () {
                        //선택된 문제로 문자열로 다시 생성(추후 비교를 위함)
                        word.forEach((i, value) {
                          quiz = quiz + value.first[0];
                        });

                        Get.to(
                            Hunt(
                              quiz: quiz,
                              list: word,
                              user: _userController.myInfo,
                            ),
                            arguments: word);
                      },
                      child: Text(
                        'START',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   elevation: 0,
          //   showSelectedLabels: true,
          //   showUnselectedLabels: true,
          //   selectedLabelStyle: TextStyle(fontSize: 12),
          //   unselectedItemColor: Colors.grey[900],
          //   selectedItemColor: Colors.black,
          //   type: BottomNavigationBarType.fixed,
          //   backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          //   currentIndex: selectedIndex,
          //   onTap: (index) {
          //     setState(() {
          //       selectedIndex = index;
          //       _pageController.jumpToPage(index);
          //     });
          //   },
          //   items: <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          //     // BottomNavigationBarItem(icon: Icon(Icons.games), label: 'GAME'),
          //     BottomNavigationBarItem(icon: Icon(Icons.collections), label: 'COLLECTIONS'),
          //     BottomNavigationBarItem(icon: Icon(Icons.list), label: 'RANK'),
          //   ],
          // ),
        );
      } else {
        return Center(
            child: Container(height: 100, width: 100, child: CircularProgressIndicator()));
      }
    });
  }
}
