import 'dart:convert';
import 'save_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _username, _url;
  Map<String, dynamic> map;
  @override
  void dispose() {
    super.dispose();
    _textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instagram DP Extractor"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _textFieldController,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                validator: (name) {
                  if (name.isEmpty || name.contains('@') || name.length < 3)
                    return 'Invalid username';
                },
                onSaved: (name) => _username = name,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60)),
                padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  try {
                    if (_formKey.currentState.validate()) {
                      fetchData();
                    }
                  } catch (e) {
                    //do whatever you want
                    print("Error");
                  }
                },
                child: Text(
                  "Search",
                  style: TextStyle(fontSize: 21, color: Colors.black),
                )),
          )
        ],
      )),
    );
  }

  alertWindow() {
    AlertDialog alert = AlertDialog(
        title: Text("Search Result"),
        content: Text("User not found"),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              return Navigator.of(context).pop();
            },
          )
        ]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future fetchData() async {
    _username = _textFieldController.text;
    try {
      var response = await http.get(
          Uri.encodeFull("https://www.instagram.com/$_username/?__a=1"),
          headers: {"Accept": "application/json"});
      map = json.decode(response.body);
      _url = map["graphql"]["user"]["profile_pic_url_hd"];

      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DiplayInstaDp(map, _url);
        }));
      }
    } catch (e) {
      alertWindow();
    }
  }
}
