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
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: 0.0,
        ),
        itemCount: _memoList.length,
        itemBuilder: (BuildContext context, int index) {
          final text = _memoList[index];
          return buildMemoItem(text, index, context);
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

  Dismissible buildMemoItem(String text, int index, BuildContext context) {
    return Dismissible(
      key: Key(text),
      background: Container(
        padding: EdgeInsets.only(
          right: 10,
        ),
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _removeMemo(index, context);
      },
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
    );
  }
}
