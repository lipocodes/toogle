import 'package:flutter/material.dart';

Widget customListTile({
  Icon icon,
  TextInputType textInputType,
  int maxLines,
  TextEditingController controller,
  String labelText,
}) {
  return new ListTile(
    leading: icon,
    title: SingleChildScrollView(
      child: new TextFormField(
        keyboardType: textInputType,
        maxLines: maxLines,
        controller: controller,
        decoration: new InputDecoration(
          labelText: labelText,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2.0,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget customTextField(
    {bool enabled,
    TextStyle style,
    int minLines,
    int maxLines,
    TextEditingController controller,
    TextInputType keyboardType,
    bool filled,
    Color fillColor,
    InputBorder inputBorder,
    String hintText,
    Icon prefixIcon}) {
  return new TextField(
      enabled: enabled,
      style: style,
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      keyboardType: keyboardType,
      decoration: new InputDecoration(
        filled: filled,
        fillColor: fillColor,
        border: inputBorder,
        hintText: hintText,
        prefixIcon: prefixIcon,
      ));
}
