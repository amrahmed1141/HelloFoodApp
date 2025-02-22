import 'package:flutter/material.dart';

class AppFont {
  static TextStyle boldTextStyle() {
    return  const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      fontFamily: 'Poppins'
    );
  }

  static TextStyle headlineTextStyle() {
    return  const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 24.0,
      fontFamily: 'Poppins'
    );
  }

  static TextStyle lightTextStyle() {
    return  const TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.w500,
      fontSize: 15.0,
      fontFamily: 'Poppins'
    );
  }

  static TextStyle semiBoldTextStyle() {
    return  const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
      fontFamily: 'Poppins'
    );
  }
}
