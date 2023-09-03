import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BackWidget extends StatelessWidget {
  final Function() onPressed;
  final Color iconColor;

  BackWidget({this.onPressed, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            finish(context);
          },
      icon: Icon(Icons.arrow_back_ios, color: iconColor ?? Colors.white),
    );
  }
}
