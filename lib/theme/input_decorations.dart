import 'package:flutter/material.dart';

const filledTextFieldDecoration = InputDecoration(
    // hoverColor: Color(0xFFFFFFFF),
    // prefixIconColor: Color(0xFF3C3C3C),
    contentPadding: EdgeInsets.only(top: 0, left: 10),
    // isDense: true,
    filled: false,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(
          width: 2,
          style: BorderStyle.solid,
        )));

const simpleInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide.none
  ),
  contentPadding: EdgeInsets.only(top: 15, bottom: 10)
);