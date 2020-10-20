import 'package:flutter/material.dart';
import 'package:memo_app/screens/edit_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _memoList = [];

  @override
  void initState() {
    super.initState();
    _loadMemoList();
  }

  void _loadMemoList() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey('memoList')) {
        setState(() {
          _memoList = prefs.getStringList('memoList');
        });
      }
    });
  }

  void _removeMemo(int index, BuildContext context) {
    setState(() {
      _memoList.removeAt(index);
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('memoList', _memoList);
    });
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('メモを削除しました'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'リスト',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _memoList.length,
        itemBuilder: (BuildContext context, int index) {
          final text = _memoList[index];
          return Dismissible(
            key: Key(text),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) {
              _removeMemo(index, context);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]),
                ),
              ),
              child: ListTile(
                title: Text(
                  text,
                  style: TextStyle(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EditScreen(
                          text: text,
                          index: index,
                        );
                      },
                    ),
                  ).then(
                    (value) => _loadMemoList(),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return EditScreen();
              },
            ),
          ).then(
            (value) => _loadMemoList(),
          );
        },
      ),
    );
  }
}
