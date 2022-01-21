import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/screens/edit.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/database/memo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  String deleteId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메모메모"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5, top: 40, bottom: 20),
            child: Container(
              child: Text('메모메모',
                  style: TextStyle(fontSize: 36, color: Colors.blue,)),
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(child: memoBuilder(context))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => EditPage(),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        tooltip: '노트를 추가하려면 클릭하세요',
        label: Text('메모 추가'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> LoadMemo() {
    List<Widget> memoList = [];
    memoList.add(Container(
      color: Colors.blue,
      height: 100,
    ));
    return memoList;
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Future<void> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 경고'),
          content: Text("정말 삭제하시겠습니다?\n삭제된 메모는 복구되지 않습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.pop(context, "삭제");
                setState(() {
                  deleteMemo(deleteId);
                });
                deleteId = '';
              },
            ),
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                deleteId = '';
                Navigator.pop(context, "취소");
              },
            ),
          ],
        );
      },
    );
  }
  Widget memoBuilder(BuildContext parentcontext) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if ((projectSnap.data as List).length == 0) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container(
              alignment: Alignment.center,
              child: Text('지금 바로 "메모 추가" 버튼을 눌러\n새로운 메모를 추가해보세요!\n\n\n\n\n\n',
                  style: TextStyle(fontSize: 15, color: Colors.blueAccent)));
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: (projectSnap.data as List).length,
          itemBuilder: (context, index) {
            Memo memo = (projectSnap.data as List)[index];
            return InkWell(
                onTap: () {},
                onLongPress: () {
                  deleteId = memo.id;
                  showAlertDialog(parentcontext);
                  //deleteMemo(memo.id);
                },
                child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.cyanAccent, blurRadius: 3)
                      ],
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(memo.title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        Text(memo.text, style: TextStyle(fontSize: 15)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              " 최종 수정 시간 " + memo.editTime.split('.')[0],
                              style: TextStyle(fontSize: 11),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        )
                      ],
                    )));
          },
        );
      },
      future: loadMemo(),
    );
  }
}
