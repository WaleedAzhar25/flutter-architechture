import 'package:flutter/material.dart';

class MenuModel {
  String icon;
  String title;
  String route;
  bool isSVG;
  bool isSignIn;

  MenuModel({
    @required this.icon,
    @required this.title,
    @required this.route,
    this.isSVG = false,
    this.isSignIn = false,
  });
}
