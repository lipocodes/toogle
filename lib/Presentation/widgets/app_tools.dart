//import 'package:Toogle/tools/progressdialog.dart';
import 'package:Toogle/Core/progressdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
//mport 'progressdialog.dart';
import 'dart:io';

Widget appTextField(
    {Icon textIcon,
    String textHint,
    bool isPassword,
    TextEditingController controller,
    double sidePadding,
    TextInputType textType}) {
  return new Padding(
      padding: new EdgeInsets.only(
          left: sidePadding == null ? 0.0 : sidePadding,
          right: sidePadding == null ? 0.0 : sidePadding),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(
            new Radius.circular(15.0),
          ),
        ),
        child: new TextField(
          controller: controller,
          obscureText: isPassword == null ? false : isPassword,
          keyboardType: textType,
          decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: textHint == null ? "" : textHint,
            prefixIcon: textIcon == null ? new Container() : textIcon,
          ),
        ),
      ));
}

Widget appButton(
    {String btnTxt,
    double btnPadding,
    Color btnColor,
    VoidCallback onBtnclicked}) {
  return Padding(
      padding: EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: onBtnclicked,
        color: Colors.white,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.all(
          new Radius.circular(15.0),
        )),
        child: Container(
          height: 50.0,
          child: new Center(
            child: Text(
              btnTxt == null ? "AppButton" : btnTxt,
              style: new TextStyle(
                  color: btnColor == null ? Colors.black : btnColor,
                  fontSize: 18.0),
            ),
          ),
        ),
      ));
}

showSnackBar(String message, final scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(new SnackBar(
    backgroundColor: Colors.black,
    content: new Text(
      message,
      style: new TextStyle(color: Colors.white),
    ),
  ));
}

closeProgressDialog(BuildContext context) {
  Navigator.of(context).pop();
}

displayProgressDialog(BuildContext context) {
  Navigator.of(context).push(new PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return new ProgressDialog();
      }));
}

writeDataLocally({String key, String value}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  localData.setString(key, value);
}

writeBoolDataLocally({String key, bool value}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  localData.setBool(key, value);
}

getStringDataLocally({String key}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  try {
    return localData.getString(key);
  } on PlatformException catch (e) {
    return null;
  }
}

getBoolDataLocally({String key}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  try {
    return localData.getBool(key);
  } on PlatformException catch (e) {
    return null;
  }
}

clearDataLocally() async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  localData.clear();
}

Widget productTextField(
    {String textTitle,
    String textHint,
    double height,
    TextEditingController controller,
    TextInputType textType,
    int maxLines}) {
  textTitle == null ? textTitle = "Enter Title" : textTitle = textTitle;
  textHint == null ? textHint = "Enter Hint" : textHint = textHint;
  height == null ? height = 50.0 : height = height;
  textType == null ? textType = TextInputType.number : textType = textType;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Text(
          textTitle,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      new Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        child: new Container(
          height: height,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border.all(color: Colors.white),
            borderRadius: new BorderRadius.all(
              new Radius.circular(4.0),
            ),
          ),
          child: new Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: new TextField(
              controller: controller,
              keyboardType: textType,
              maxLines: maxLines == null ? null : maxLines,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: textHint,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget productsDropDown(
    {String textTitle,
    String selectedItem,
    List<DropdownMenuItem<String>> dropDownItems,
    ValueChanged<String> changedDropDownItems}) {
  textTitle == null ? textTitle = "" : textTitle = textTitle;
  selectedItem == null ? selectedItem = "" : selectedItem = selectedItem;

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Text(
        textTitle,
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border.all(color: Colors.cyan),
            borderRadius: new BorderRadius.all(
              new Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: new DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    style: new TextStyle(color: Colors.black),
                    value: selectedItem,
                    items: dropDownItems,
                    onChanged: changedDropDownItems,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

List<DropdownMenuItem<String>> buildAndGetDropDownItems(List sizes) {
  List<DropdownMenuItem<String>> items = List();
  for (String size in sizes) {
    items.add(new DropdownMenuItem(value: size, child: new Text(size)));
  }

  return items;
}

Widget multiImageList(
    {List<File> imageList, VoidCallback removeNewImage(int position)}) {
  return new Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
    child: imageList == null || imageList.length == 0
        ? new Container()
        : new SizedBox(
            height: 150.0,
            child: new ListView.builder(
                itemCount: imageList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return new Padding(
                    padding: new EdgeInsets.only(left: 3.0, right: 3.0),
                    child: new Stack(
                      children: <Widget>[
                        new Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: new BoxDecoration(
                              color: Colors.grey.withAlpha(100),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(15.0)),
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                //image: new FileImage(imageList[index])
                                image: imageList[index].path.contains("https")
                                    ? NetworkImage(imageList[index].path)
                                    : new FileImage(imageList[index]),
                              )),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new CircleAvatar(
                            backgroundColor: Colors.red[600],
                            child: new IconButton(
                                icon: new Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  removeNewImage(index);
                                }),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
  );
}

Widget listTile({BuildContext context, int index}) {
  return new Row(children: [
    new Text(index.toString()),
  ]);
}
