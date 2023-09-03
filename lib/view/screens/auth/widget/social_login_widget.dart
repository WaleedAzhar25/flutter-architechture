import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/data/model/body/social_log_in_body.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../util/colors.dart';

class SocialLoginWidget extends StatelessWidget {
  Container container(String image) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: ColorResources.white,
        border: Border.all(
          color: ColorResources.black3.withOpacity(0.1),
        ),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () async {
          GoogleSignInAccount _googleAccount = await GoogleSignIn().signIn();
          GoogleSignInAuthentication _auth =
              await _googleAccount.authentication;
          if (_googleAccount != null) {
            Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
              email: _googleAccount.email,
              token: _auth.accessToken,
              uniqueId: _googleAccount.id,
              medium: 'google',
            ));
          }
        },
        child: container(Images.google),
        //  Container(
        //   height: 40,
        //   width: 40,
        //   padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.all(Radius.circular(5)),
        //     boxShadow: [
        //       BoxShadow(
        //           color: Colors.grey[Get.isDarkMode ? 700 : 300],
        //           spreadRadius: 1,
        //           blurRadius: 5)
        //     ],
        //   ),
        //   child: Image.asset(Images.google),
        // ),
      ),
      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
      InkWell(
        onTap: () async {
          LoginResult _result = await FacebookAuth.instance.login();
          if (_result.status == LoginStatus.success) {
            Map _userData = await FacebookAuth.instance.getUserData();
            if (_userData != null) {
              Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
                email: _userData['email'],
                token: _result.accessToken.token,
                uniqueId: _result.accessToken.userId,
                medium: 'facebook',
              ));
            }
          } else {
            showCustomSnackBar('${_result.status} ${_result.message}');
          }
        },
        child: container(Images.facebook),
        //  Container(
        //   height: 40,
        //   width: 40,
        //   padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.all(Radius.circular(5)),
        //     boxShadow: [
        //       BoxShadow(
        //           color: Colors.grey[Get.isDarkMode ? 700 : 300],
        //           spreadRadius: 1,
        //           blurRadius: 5)
        //     ],
        //   ),
        //   child: Image.asset(Images.facebook),
        // ),
      )
    ]);
  }
}
