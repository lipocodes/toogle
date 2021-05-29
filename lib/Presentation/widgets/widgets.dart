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
