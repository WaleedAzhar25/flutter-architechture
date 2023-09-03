import 'package:sixam_mart/service/main.dart';
import 'package:sixam_mart/service/utils/colors.dart';
import 'package:sixam_mart/service/utils/configs.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Future<Color> getMaterialYouData() async {
  if (appStore.useMaterialYouTheme && await isAndroid12Above()) {
    primaryColor = await getMaterialYouPrimaryColor();
  } else {
    primaryColor = defaultPrimaryColor;
  }

  return primaryColor;
}
