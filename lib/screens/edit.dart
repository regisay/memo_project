import 'package:flutter/material.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for utf encoding

class EditPage extends StatelessWidget {

  String title = '';
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: (){},
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveDB,
          ),
        ],
      ),
      body:
      Padding(
          padding:EdgeInsets.all(20),
      child:Column(
        children:  <Widget>[
          TextField(
            onChanged: (String title){this.title = title;},
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            //obscureText: true,
            decoration: InputDecoration(
              //border: OutlineInputBorder(),
              hintText: '제목을 적어주세요',
            ),
          ),
          Padding(
            padding:EdgeInsets.all(20),
          ),

          TextField(
            onChanged: (String text){this.text = text;},
            keyboardType: TextInputType.multiline,
            maxLines: null,
            //obscureText: true,
            decoration: InputDecoration(
              //border: OutlineInputBorder(),

              hintText: '메모를 적어주세요',
            ),
          ),
        ],
      ),
      )
    );
  }

  Future<void> saveDB() async {

    DBHelper sd = DBHelper();

    var fido = Memo(
      id: Str25ha512(DateTime.now().toString()), //원래 int였음
      title: this.title,
      text: this.text,
      createTime: DateTime.now().toString(),
      editTime: DateTime.now().toString(),

    );

    await sd.insertMemo(fido);

    print(await sd.memos()); //DB값 출

  }

  String Str25ha512(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha512.convert(bytes);
      return digest.toString();

  }

}
