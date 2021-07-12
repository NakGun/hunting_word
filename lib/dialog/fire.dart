import 'package:flutter/material.dart';

class FireDialog extends StatefulWidget {
  final Map list;

  const FireDialog({Key? key, required this.list}) : super(key: key);

  @override
  _FireDialogState createState() => _FireDialogState();
}

class _FireDialogState extends State<FireDialog> {
  //글자 자리수
  int count = 0;
  int nodeInedx = 0;
  //포커스 대상여부
  List<String> focusYN = [];

  //글자 모음
  List<String> word = [];
  //포커스노드 모음
  List<FocusNode> _fNodes = [];

  @override
  void initState() {
    _fNodes = new List<FocusNode>.generate(widget.list.length + 1, (_) => new FocusNode());

    //단어 디폴트 생성
    for (var value in widget.list.values) {
      word.add(value[0]);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var value in widget.list.values) _textField(value, count++),
                  // for (int index = 0; index < widget.list.length; index++)
                  //   _textField(widget.list[index], index)
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
                  String answer = '';
                  for (int i = 0; i < word.length; i++) {
                    answer = answer + word[i];
                  }
                  Navigator.pop(context, answer);
                },
                child: Text(
                  'Shot',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
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
        focusYN.add('Y');
      } else {
        focusYN.add('N');
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
            initialValue: item[1] == false ? item[0] : '',
            // controller: TextEditingController()
            //   ..text = item.values.first[1] == false ? item.values.first[0] : '',
            readOnly: false, //item.values.first == false ? true : false,
            // obscureText: item[1],
            autofocus: index == 0 ? true : false,
            onChanged: (v) {
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
            },
            // list[j].update(list[j].keys.first, (value) => false);
            textCapitalization: TextCapitalization.none,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(fontSize: widget.list.length > 7 ? 20 : 25, color: Colors.black),
            decoration: InputDecoration(
              counterText: "",
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
  }
}

///map update
// widget.list.update(
//   key,
//   // You can ignore the incoming parameter if you want to always update the value even if it is already in the map
//   (existingValue) => key,
//   ifAbsent: () => alpahbat,
// );

///list<map> value change
// widget.list[index][0] = alpahbat;
