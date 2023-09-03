import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/menu_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/confirmation_dialog.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../social_app/shared_preferences/preferencesKey.dart';

class MenuButton extends StatelessWidget {
  final MenuModel menu;
  final bool isProfile;
  final bool isLogout;
  MenuButton(
      {@required this.menu, @required this.isProfile, @required this.isLogout});

  @override
  Widget build(BuildContext context) {
    int _count = ResponsiveHelper.isDesktop(context)
        ? 8
        : ResponsiveHelper.isTab(context)
            ? 6
            : 4;
    double _size = ((context.width > Dimensions.WEB_MAX_WIDTH
                ? Dimensions.WEB_MAX_WIDTH
                : context.width) /
            _count) -
        Dimensions.PADDING_SIZE_DEFAULT;

    return InkWell(
      onTap: () async {
        if (isLogout) {
          Get.back();
          if (Get.find<AuthController>().isLoggedIn()) {
            Get.dialog(
                ConfirmationDialog(
                    icon: Images.support,
                    description: 'are_you_sure_to_logout'.tr,
                    isLogOut: true,
                    onYesPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences
                          .remove(SharedPreferencesKey.LOGGED_IN_USERRDATA);
                      Get.find<AuthController>().clearSharedData();
                      Get.find<CartController>().clearCartList();
                      Get.find<WishListController>().removeWishes();
                      Get.offAllNamed(
                          RouteHelper.getSignInRoute(RouteHelper.splash));
                    }),
                useSafeArea: false);
          } else {
            Get.find<WishListController>().removeWishes();
            Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
          }
        } else if (menu.route.startsWith('http')) {
          if (await canLaunchUrlString(menu.route)) {
            launchUrlString(menu.route, mode: LaunchMode.externalApplication);
          }
        } else {
          Get.offNamed(menu.route);
        }
      },
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
          child: Row(
            children: [
              if (!menu.isSignIn)
                if (menu.isSVG)
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SvgPicture.asset(menu.icon),
                  ),
              if (!menu.isSignIn)
                if (!menu.isSVG)
                  isProfile
                      ? ProfileImageWidget(size: _size)
                      : Image.asset(menu.icon,
                          width: _size * 0.4,
                          height: _size * 0.4,
                          color: Color(0xff6776FE)),
              if (!menu.isSignIn) SizedBox(width: 20),
              if (!menu.isSignIn)
                !isProfile
                    ? Text(menu.title,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center)
                    : SizedBox(),
              SizedBox(height: 20),
              if (menu.isSignIn)
                Container(
                  height: 50,
                  width: 100,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff6776FE),
                  ),
                  child: Center(
                    child: Text(
                      menu.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final double size;
  ProfileImageWidget({@required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: Colors.white)),
            child: ClipOval(
              child: CustomImage(
                image:
                    '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                    '/${(userController.userInfoModel != null && Get.find<AuthController>().isLoggedIn()) ? userController.userInfoModel.image ?? '' : ''}',
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (userController.userInfoModel != null &&
              Get.find<AuthController>().isLoggedIn())
            Text(
              '${(userController.userInfoModel != null && Get.find<AuthController>().isLoggedIn()) ? userController.userInfoModel.fName ?? '' + userController.userInfoModel.lName ?? '' : ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          if (userController.userInfoModel != null &&
              Get.find<AuthController>().isLoggedIn())
            Text(
              '${(userController.userInfoModel != null && Get.find<AuthController>().isLoggedIn()) ? userController.userInfoModel.email ?? '' : ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
        ],
      );
    });
  }
}
