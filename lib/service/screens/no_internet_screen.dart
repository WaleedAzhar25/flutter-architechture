import 'package:sixam_mart/service/component/cached_image_widget.dart';
import 'package:sixam_mart/service/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:sixam_mart/service/main.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({Key key}) : super(key: key);

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            alignment: Alignment.center,
            color: context.cardColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedImageWidget(url: notDataFoundImg.validate(), height: 200),
                8.height,
                Text(language.internetNotAvailable, style: primaryTextStyle()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
