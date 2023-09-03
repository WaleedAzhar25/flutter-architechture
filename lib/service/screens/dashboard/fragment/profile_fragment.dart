import 'package:sixam_mart/service/component/cached_image_widget.dart';
import 'package:sixam_mart/service/component/loader_widget.dart';
import 'package:sixam_mart/service/main.dart';
import 'package:sixam_mart/service/network/rest_apis.dart';
import 'package:sixam_mart/service/screens/auth/change_password_screen.dart';
import 'package:sixam_mart/service/screens/auth/edit_profile_screen.dart';
import 'package:sixam_mart/service/screens/auth/sign_in_screen.dart';
import 'package:sixam_mart/service/screens/blog/view/blog_list_screen.dart';
import 'package:sixam_mart/service/screens/dashboard/customer_rating_screen.dart';
import 'package:sixam_mart/service/screens/dashboard/dashboard_screen.dart';
import 'package:sixam_mart/service/screens/service/favourite_service_screen.dart';
import 'package:sixam_mart/service/screens/setting_screen.dart';
import 'package:sixam_mart/service/utils/colors.dart';
import 'package:sixam_mart/service/utils/common.dart';
import 'package:sixam_mart/service/utils/configs.dart';
import 'package:sixam_mart/service/utils/constant.dart';
import 'package:sixam_mart/service/utils/images.dart';
import 'package:sixam_mart/service/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sixam_mart/service/screens/favourite_provider_screen.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<num> futureWalletBalance;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (appStore.isLoggedIn) loadBalance();

    afterBuildCreated(() {
      appStore.setLoading(false);
      setStatusBarColor(context.primaryColor);
    });
  }

  void loadBalance() {
    futureWalletBalance = getUserWalletBalance();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.profile,
        textColor: white,
        elevation: 0.0,
        color: context.primaryColor,
        showBack: false,
        actions: [
          IconButton(
            icon: ic_setting.iconImage(color: white, size: 20),
            onPressed: () async {
              SettingScreen().launch(context);
            },
          ),
        ],
      ),
      body: Observer(
        builder: (BuildContext context) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (appStore.isLoggedIn)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          24.height,
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: boxDecorationDefault(
                                  border:
                                      Border.all(color: primaryColor, width: 3),
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  decoration: boxDecorationDefault(
                                    border: Border.all(
                                        color: context.scaffoldBackgroundColor,
                                        width: 4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedImageWidget(
                                    url: appStore.userProfileImage,
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                    radius: 60,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(6),
                                  decoration: boxDecorationDefault(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                    border: Border.all(
                                        color: context.cardColor, width: 2),
                                  ),
                                  child: Icon(AntDesign.edit,
                                      color: white, size: 18),
                                ).onTap(() {
                                  EditProfileScreen().launch(context);
                                }),
                              ),
                            ],
                          ),
                          16.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(appStore.userFullName,
                                  style: boldTextStyle(
                                      color: primaryColor, size: 18)),
                              Text(appStore.userEmail,
                                  style: secondaryTextStyle()),
                            ],
                          ),
                          24.height,
                        ],
                      ).center(),
                    SettingSection(
                      title: Text(language.lblGENERAL,
                          style: boldTextStyle(color: primaryColor)),
                      headingDecoration: BoxDecoration(
                          color: context.primaryColor.withOpacity(0.1)),
                      divider: Offstage(),
                      items: [
                        if (appStore.isLoggedIn)
                          SettingItemWidget(
                            leading: ic_un_fill_wallet.iconImage(
                                size: SETTING_ICON_SIZE),
                            title: language.walletBalance,
                            trailing: SnapHelperWidget(
                              future: futureWalletBalance,
                              loadingWidget: Text(language.loading),
                              onSuccess: (balance) => Text(
                                '${isCurrencyPositionLeft ? appStore.currencySymbol : ''}${balance.toStringAsFixed(DECIMAL_POINT)}${isCurrencyPositionRight ? appStore.currencySymbol : ''}',
                                style: boldTextStyle(color: Colors.green),
                              ),
                              errorWidget: IconButton(
                                onPressed: () {
                                  loadBalance();
                                  setState(() {});
                                },
                                icon: Icon(Icons.refresh_rounded),
                              ),
                            ),
                          ),
                        16.height,
                        SettingItemWidget(
                          leading: ic_heart.iconImage(size: SETTING_ICON_SIZE),
                          title: language.lblFavorite,
                          trailing: trailing,
                          onTap: () {
                            doIfLoggedIn(context, () {
                              FavouriteServiceScreen().launch(context);
                            });
                          },
                        ),
                        SettingItemWidget(
                          leading: ic_heart.iconImage(size: SETTING_ICON_SIZE),
                          title: language.favouriteProvider,
                          trailing: trailing,
                          onTap: () {
                            doIfLoggedIn(context, () {
                              FavouriteProviderScreen().launch(context);
                            });
                          },
                        ),
                        if (isLoginTypeUser)
                          SettingItemWidget(
                            leading: ic_lock.iconImage(size: SETTING_ICON_SIZE),
                            title: language.changePassword,
                            trailing: trailing,
                            onTap: () {
                              doIfLoggedIn(context, () {
                                ChangePasswordScreen().launch(context);
                              });
                            },
                          ),
                        SettingItemWidget(
                          leading: ic_star.iconImage(size: SETTING_ICON_SIZE),
                          title: language.myReviews,
                          trailing: trailing,
                          onTap: () async {
                            doIfLoggedIn(context, () {
                              CustomerRatingScreen().launch(context);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Observer(
                  builder: (context) =>
                      LoaderWidget().visible(appStore.isLoading)),
            ],
          );
        },
      ),
    );
  }
}
