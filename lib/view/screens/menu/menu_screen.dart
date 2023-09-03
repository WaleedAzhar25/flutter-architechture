import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/menu_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/service/main.dart';
import 'package:sixam_mart/service/screens/dashboard/customer_rating_screen.dart';
import 'package:sixam_mart/service/screens/dashboard/fragment/booking_fragment.dart';
import 'package:sixam_mart/service/screens/dashboard/fragment/settings_item.dart';
import 'package:sixam_mart/service/screens/favourite_provider_screen.dart';
import 'package:sixam_mart/service/screens/service/favourite_service_screen.dart';
import 'package:sixam_mart/service/utils/common.dart';
import 'package:sixam_mart/service/utils/constant.dart';
import 'package:sixam_mart/service/utils/images.dart';
import 'package:sixam_mart/service/utils/string_extensions.dart';
import 'package:sixam_mart/util/colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/view/customization/blogs/Blogs_screen.dart';
import 'package:sixam_mart/view/customization/videos/videos_screen.dart';
import 'package:sixam_mart/view/screens/auth/sign_in_screen.dart';
import 'package:sixam_mart/view/screens/menu/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Object> _menuList;
  double _ratio;

  @override
  Widget build(BuildContext context) {
    _ratio = ResponsiveHelper.isDesktop(context)
        ? 1.1
        : ResponsiveHelper.isTab(context)
            ? 1.1
            : 1.2;
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    _menuList = [
      MenuModel(
          icon: '', title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
      // MenuModel(
      //     icon: Images.Profileicon,
      //     isSVG: true,
      //     title: 'profile'.tr,
      //     route: RouteHelper.getProfileRoute()),
      MenuModel(
          icon: Images.location,
          title: 'my_address'.tr,
          route: RouteHelper.getAddressRoute()),
      MenuModel(
          icon: Images.languageicon,
          isSVG: true,
          title: 'language'.tr,
          route: RouteHelper.getLanguageRoute('menu')),
      MenuModel(
          icon: Images.coupon,
          title: 'coupon'.tr,
          route: RouteHelper.getCouponRoute()),
      MenuModel(
          icon: Images.support,
          title: 'help_support'.tr,
          route: RouteHelper.getSupportRoute()),
      // MenuModel(
      //     icon: Images.policy,
      //     title: 'privacy_policy'.tr,
      //     route: RouteHelper.getHtmlRoute('privacy-policy')),
      MenuModel(
          icon: Images.aboutusicon,
          isSVG: true,
          title: 'about_us'.tr,
          route: RouteHelper.getHtmlRoute('about-us')),
      // MenuModel(
      //     icon: Images.terms,
      //     title: 'terms_conditions'.tr,
      //     route: RouteHelper.getHtmlRoute('terms-and-condition')),
      MenuModel(
          icon: Images.chat,
          title: 'live_chat'.tr,
          route: RouteHelper.getConversationRoute()),
      SettingItem(
        leading: ic_heart.iconImage(
          size: 26,
          color: ColorResources.blue1,
        ),
        title: language.lblFavorite,
        onTap: () {
          doIfLoggedIn(context, () {
            FavouriteServiceScreen().launch(context);
          });
        },
      ),
      SettingItem(
        leading: ic_heart.iconImage(
          size: 26,
          color: ColorResources.blue1,
        ),
        title: language.favouriteProvider,
        onTap: () {
          doIfLoggedIn(context, () {
            FavouriteProviderScreen().launch(context);
          });
        },
      ),

      SettingItem(
        leading: ic_star.iconImage(
          size: 26,
          color: ColorResources.blue1,
        ),
        title: language.myReviews,
        onTap: () async {
          doIfLoggedIn(context, () {
            CustomerRatingScreen().launch(context);
          });
        },
      ),
      SettingItem(
        leading: Icon(
          Icons.video_collection_outlined,
          size: 26,
          color: ColorResources.blue1,
        ),
        title: 'videos'.tr,
        onTap: () async {
          Get.off(() => VideoScreen(isAllVideos: true));
        },
      ),
      SettingItem(
        leading: Icon(
          Icons.library_books_outlined,
          size: 26,
          color: ColorResources.blue1,
        ),
        title: 'blogs'.tr,
        onTap: () async {
          Get.off(() => BlogScreen(isAllBlogs: true));
        },
      ),
      SettingItem(
        leading: Icon(
          Icons.book_online_outlined,
          size: 26,
          color: ColorResources.blue1,
        ),
        title: 'Bookings',
        onTap: () async {
          Get.off(
            () => Observer(
                builder: (context) =>
                    appStore.isLoggedIn ? BookingFragment() : SignInScreen()),
          );
        },
      ),
    ];

    if (Get.find<SplashController>().configModel.refEarningStatus == 1) {
      _menuList.add(MenuModel(
          icon: Images.refer_code,
          title: 'refer_and_earn'.tr,
          route: RouteHelper.getReferAndEarnRoute()));
    }
    if (Get.find<SplashController>().configModel.customerWalletStatus == 1) {
      _menuList.add(MenuModel(
          icon: Images.wallet,
          title: 'wallet'.tr,
          route: RouteHelper.getWalletRoute(true)));
    }
    if (Get.find<SplashController>().configModel.loyaltyPointStatus == 1) {
      _menuList.add(MenuModel(
          icon: Images.loyal,
          title: 'loyalty_points'.tr,
          route: RouteHelper.getWalletRoute(false)));
    }
    if (Get.find<SplashController>().configModel.toggleDmRegistration &&
        !ResponsiveHelper.isDesktop(context)) {
      _menuList.add(MenuModel(
        icon: Images.delivery_man_join,
        title: 'join_as_a_delivery_man'.tr,
        route: RouteHelper.getDeliverymanRegistrationRoute(),
      ));
    }
    if (Get.find<SplashController>().configModel.toggleStoreRegistration &&
        !ResponsiveHelper.isDesktop(context)) {
      _menuList.add(MenuModel(
        icon: Images.restaurant_join,
        title: Get.find<SplashController>()
                .configModel
                .moduleConfig
                .module
                .showRestaurantText
            ? 'join_as_a_restaurant'.tr
            : 'join_as_a_store'.tr,
        route: RouteHelper.getRestaurantRegistrationRoute(),
      ));
    }

    _menuList.add(MenuModel(
        isSignIn: true,
        icon: Images.log_out,
        title: _isLoggedIn ? 'logout'.tr : 'sign_in'.tr,
        route: ''));

    return SingleChildScrollView(
      child: PointerInterceptor(
        child: Container(
          width: Dimensions.WEB_MAX_WIDTH,
          padding:
              EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Color(0xffEFF4FA),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            InkWell(
              onTap: () => Get.back(),
              child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _menuList.length,
              itemBuilder: (context, index) {
                if (index == 7) {
                  return _menuList[7];
                } else if (index == 8) {
                  return _menuList[8];
                } else if (index == 9) {
                  return _menuList[9];
                } else if (index == 10) {
                  return _menuList[10];
                } else if (index == 11) {
                  return _menuList[11];
                } else if (index == 12) {
                  return _menuList[12];
                } else {
                  return MenuButton(
                      menu: _menuList[index],
                      isProfile: index == 0,
                      isLogout: index == _menuList.length - 1);
                }
              },
            ),
            SizedBox(
                height: ResponsiveHelper.isMobile(context)
                    ? Dimensions.PADDING_SIZE_SMALL
                    : 0),
          ]),
        ),
      ),
    );
  }
}
