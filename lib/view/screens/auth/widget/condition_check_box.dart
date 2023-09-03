import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/colors.dart';

class ConditionCheckBox extends StatelessWidget {
  final AuthController authController;
  ConditionCheckBox({@required this.authController});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      InkWell(
        onTap: () {
          authController.toggleTerms();
        },
        child: CircleAvatar(
          radius: 13,
          backgroundColor: ColorResources.black3.withOpacity(0.05),
          child: authController.acceptTerms
              ? Icon(
                  Icons.check,
                  color: ColorResources.blue,
                  size: 18,
                )
              : Text(""),
        ),
      ),
      SizedBox(width: 8),
      Text('i_agree_with'.tr, style: robotoRegular),
      InkWell(
        onTap: () =>
            Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
        child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: Text('terms_conditions'.tr,
              style: robotoMedium.copyWith(color: Colors.blue)),
        ),
      ),
    ]);
  }
}
