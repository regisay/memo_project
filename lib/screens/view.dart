import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';

class Viewpage extends StatefulWidget {
  const Viewpage({Key? key,required this.id}) : super(key: key);

  final String id;

  @override
  _ViewpageState createState() => _ViewpageState();
}

class _ViewpageState extends State<Viewpage> {

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
              icon: const Icon(Icons.edit),
              onPressed: (){},
            ),
          ],
        ),
        body: Padding(
            padding:EdgeInsets.all(20),
            child: LoadBuilder()
        ));
  }

  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  LoadBuilder() {

    return FutureBuilder<List<Memo>>(
      future: loadMemo(''),
      builder: (BuildContext context,AsyncSnapshot<List<Memo>> snapshot) {
        if ((snapshot.data as List).length == 0) {
          return Container(
              child: Text("데이터를 불러올 수 없습니다.")
          );
        } else {
          Memo memo = snapshot.data![0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:<Widget>[
              Container(height: 100,
                child : SingleChildScrollView(
                  child: Text(memo.title,
                    style: TextStyle(fontSize: 30, fontWeight : FontWeight.w500),
                  ),
                ),
              ),
              Text("메모 만든 시간 " + memo.createTime.split('.')[0],
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.end,),
              Text("메모 수정 시간 " + memo.editTime.split('.')[0],
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.end,),
              Padding(
                  padding:EdgeInsets.all(10)),
              Expanded(
                child: SingleChildScrollView(child: Text(memo.text),),
              )
            ],
          );
        }
      },
    );
  }
}
