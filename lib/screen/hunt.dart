import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_game/data/constants.dart';
import 'package:word_game/data/local_crud.dart';
import 'package:word_game/data/my_data.dart';
import 'package:word_game/data/user_crud.dart';
import 'package:word_game/dialog/choice.dart';
import 'package:word_game/dialog/fail.dart';
import 'package:word_game/dialog/sucess.dart';
import 'package:word_game/functions/make_quiz.dart';
import 'package:word_game/screen/page_navigation.dart';

class Hunt extends StatefulWidget {
  final String quiz;
  final Map list;
  final List<dynamic> user;
  const Hunt({Key? key, this.quiz = '', required this.list, required this.user}) : super(key: key);

  @override
  _HuntState createState() => _HuntState();
}

class _HuntState extends State<Hunt> {
  MakeQuiz makeQuiz = new MakeQuiz();

  //글자 자리수
  int count = 0;
  int nodeInedx = 0;

  //포커스 대상여부 모음
  List<String> focusYN = [];
  //글자 모음
  List<String> word = [];
  //포커스노드 모음
  List<FocusNode> _fNodes = [];
  //컨트롤러 모음
  List<TextEditingController> _controller = [];

  //초이스 갯수
  int choice = 3;
  //정답 갯수
  int hunt = 3;

  //힌트
  String hint = '';
  bool _visible = false;

  @override
  void initState() {
    //글자,포커스노드 디폴트 생성
    for (var value in widget.list.values) {
      word.add(value[0]);
      focusYN.add('Y');
    }
    //노드 디폴트 생성
    _fNodes = new List<FocusNode>.generate(widget.list.length + 1, (_) => new FocusNode());
    //컨트롤러 디폴드 생성
    _controller = new List<TextEditingController>.generate(
        widget.list.length + 1, (_) => new TextEditingController());

    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < _controller.length; i++) {
      _controller[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    count = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hunting'),
      ),

      //Obx라는 함수는 contrlloer의 변수값을 실시간으로 전달받는다
      //현재 users는 controller 내 함수에서 clear후 할당받기 때문에 2번 바뀌게 되어 화면이 2번 호드됨
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              // height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //primary: Colors.red, // background
                          onPrimary: Colors.white, // foreground
                          // minimumSize: Size(200, 300)
                        ),
                        onPressed: () {
                          setState(() {
                            //힌트생성
                            hint = makeQuiz.getHint(widget.quiz);
                            _visible = true;
                            // count = 0;
                          });
                        },
                        child: Text(
                          'HINT',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
            widget.list.length > 0
                ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //아오...맵타입은 위젯안에서 루핑 이렇게 돈다....
                        for (var value in widget.list.values) _textField(value, count++),
                      ],
                    ),
                  )
                : Text('Quiz not anymoar!'),
            Visibility(
              visible: _visible,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  hint,
                  style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //primary: Colors.red, // background
                      onPrimary: Colors.white, // foreground
                      minimumSize: Size(150, 50),
                    ),
                    onPressed: () {
                      if (choice == 0) {
                        Get.snackbar(
                          "Sorry",
                          "Empty Choice",
                          backgroundColor: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          borderColor: Colors.indigo,
                          borderRadius: 0,
                          borderWidth: 2,
                          barBlur: 0,
                          isDismissible: true,
                          duration: Duration(seconds: 3),
                        );
                      } else {
                        setState(() {
                          //화면초기화시 다시 그려야하기 때문에 초기화
                          // count = 0;
                          showDialog(context: context, builder: (_) => new ChoiceDialog())
                              .then((value) {
                            // count = 0;
                            for (int i = 0; i < 3; i++) {
                              for (var original in widget.list.values) {
                                //선택한 알파벳으로 문제와 비교
                                if (original[0] == value[i]) {
                                  //알파벳 보이도록 업데이트
                                  original[1] = false;
                                }
                              }
                            }
                            //차감
                            choice--;
                            setState(() {});
                          });
                        });
                      }
                    },
                    child: Text(
                      'Choice',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white, // foreground
                        minimumSize: Size(150, 50)),
                    onPressed: () {
                      if (hunt == 0) {
                        Get.dialog(FailDialog())
                            .then((value) => Get.offAll(() => PageNavigation()));
                      } else {
                        //초기화(화면다시그려야함)
                        // count = 0;
                        String answer = '';
                        for (int i = 0; i < _controller.length; i++) {
                          answer = answer + _controller[i].text;
                        }
                        if (widget.quiz == answer) {
                          //모든상태오픈
                          for (var original in widget.list.values) {
                            //알파벳 보이도록 업데이트
                            original[1] = false;
                          }
                          hint = makeQuiz.getHint(widget.quiz);
                          //성공단어 저장
                          LocalCRUD().createData(MyData(myWord: answer, meaning: hint));
                          //유저정보 db에 저장
                          userCrud.updateUser(
                              widget.user[0], widget.user[1], widget.user[2] + 1, widget.user[3]);

                          Get.dialog(SucessDialog())
                              .then((value) => Get.offAll(() => PageNavigation()));
                        } else {
                          Get.snackbar(
                            "Fail",
                            "You can try again!!",
                            backgroundColor: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            borderColor: Colors.indigo,
                            borderRadius: 0,
                            borderWidth: 2,
                            barBlur: 0,
                            isDismissible: true,
                            duration: Duration(seconds: 3),
                          );
                        }
                        //차감
                        hunt--;
                      }
                    },
                    child: Text(
                      'Fire',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  SizedBox _textField(dynamic item, int index) {
    //다이얼로그가 닫힐때 또 여기를 두번 타게되서 노드선언 index가 넘어가 에러가 난다
    //총 문제 단어 길이를 넘어가지 않도록 해줬다 (왜 닫힐때 또 타게 되는걸까)
    if (index < widget.list.length) {
      if (item[1] == true) {
        focusYN[index] = 'Y';
      } else {
        focusYN[index] = 'N';
      }

      return SizedBox(
        width: widget.list.length > 10
            ? 20
            : widget.list.length > 7
                ? 30
                : 50,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            focusNode: _fNodes[index],
            // initialValue: item[1] == false ? item[0] : 'a',
            controller: _controller[index]..text = item[1] == false ? item[0] : '',
            readOnly: item[1] == false ? true : false,
            //obscureText: item[1],
            textCapitalization: TextCapitalization.none,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(fontSize: widget.list.length > 7 ? 20 : 25, color: Colors.white),
            onChanged: (v) {
              if (v != '') {
                _changeAlphabat(index, item[0], v);
                if (index + 1 <= focusYN.length - 1) {
                  if (focusYN[index + 1] == 'Y') {
                    FocusScope.of(context).requestFocus(_fNodes[index + 1]);
                  } else {
                    if (index + 2 <= focusYN.length - 1) {
                      FocusScope.of(context).requestFocus(_fNodes[index + 2]);
                    }
                  }
                }
              }
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.cyan,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  void _changeAlphabat(int index, String key, String alpahbat) {
    word[index] = alpahbat;
    print('list ==> ${widget.list}');
  }
}
