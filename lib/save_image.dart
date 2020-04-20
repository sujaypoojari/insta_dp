import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

class DiplayInstaDp extends StatefulWidget {
  final String name;
  final userdata;
  DiplayInstaDp(this.userdata, this.name);
  @override
  _DiplayInstaDpState createState() => _DiplayInstaDpState();
}

class _DiplayInstaDpState extends State<DiplayInstaDp> {
  String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Save Image",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.white,
                width: 10,
              )),
              child: Image(
                height: 280,
                width: 280,
                fit: BoxFit.fill,
                image: NetworkImage(
                    widget.userdata['graphql']['user']['profile_pic_url_hd']),
              ),
            ),
            Container(
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                  padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
                  color: Colors.lightBlueAccent,
                  onPressed: _saveNetworkImage,
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 21, color: Colors.black),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  alertWindow() {
    AlertDialog alert = AlertDialog(
        backgroundColor: Colors.black,
        title: Text("Status", style: TextStyle(color: Colors.white)),
        content: Text("Image Saved", style: TextStyle(color: Colors.white)),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _saveNetworkImage() async {
    try {
      String path = widget.name;
      print(path);
      GallerySaver.saveImage(path).then((bool success) {
        alertWindow();
      });
    } catch (e) {
      print(e);
    }
  }
}
