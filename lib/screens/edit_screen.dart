import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditScreen extends StatefulWidget {
  final String text;
  final int index;

  EditScreen({
    this.text,
    this.index,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  void storeText(int index) {
    List<String> memoList = [];
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey('memoList')) {
        memoList = prefs.getStringList('memoList');
      }
      if (index != null) {
        memoList[index] = _controller.text;
      } else {
        memoList.add(_controller.text);
      }
      prefs.setStringList('memoList', memoList);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.index != null ? '編集' : '新規作成',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: BackButton(
          color: Colors.white,
        ),
        actions: [
          FlatButton(
            child: Text(
              '完了',
              style: TextStyle(
                color: _controller.text.isEmpty ? Colors.white60 : Colors.white,
                fontSize: 16.0,
              ),
            ),
            onPressed: _controller.text.isEmpty
                ? null
                : () {
                    storeText(widget.index);
                  },
          ),
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.all(
          6.0,
        ),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _controller.text = value;
            });
          },
        ),
      ),
    );
  }
}
