import 'dart:async';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/body/notification_body.dart';
import 'package:sixam_mart/helper/notification_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/service/app_theme.dart';
import 'package:sixam_mart/service/locale/app_localizations.dart';
import 'package:sixam_mart/service/main.dart';
import 'package:sixam_mart/service/model/material_you_model.dart';
import 'package:sixam_mart/service/utils/colors.dart';
import 'package:sixam_mart/service/utils/common.dart';
import 'package:sixam_mart/service/utils/configs.dart';
import 'package:sixam_mart/service/utils/constant.dart';
import 'package:sixam_mart/theme/dark_theme.dart';
import 'package:sixam_mart/theme/light_theme.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;

void serviceProviderMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  passwordLengthGlobal = 6;
  appButtonBackgroundColorGlobal = primaryColor;
  defaultAppButtonTextColorGlobal = Colors.white;
  defaultRadius = 12;
  defaultBlurRadius = 0;
  defaultSpreadRadius = 0;
  textSecondaryColorGlobal = appTextPrimaryColor;
  textPrimaryColorGlobal = appTextSecondaryColor;
  defaultAppButtonElevation = 0;
  pageRouteTransitionDurationGlobal = Duration(milliseconds: 400);

  await initialize();
  localeLanguageList = languageList();

  Firebase.initializeApp().then((value) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    setupFirebaseRemoteConfig();
  });

  await appStore.setLanguage(
      getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE));
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == THEME_MODE_LIGHT) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == THEME_MODE_DARK) {
    appStore.setDarkMode(true);
  }

  await appStore.setUseMaterialYouTheme(getBoolAsync(USE_MATERIAL_YOU_THEME),
      isInitializing: true);

  if (appStore.isLoggedIn) {
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setFirstName(getStringAsync(FIRST_NAME),
        isInitializing: true);
    await appStore.setLastName(getStringAsync(LAST_NAME), isInitializing: true);
    await appStore.setUserEmail(getStringAsync(USER_EMAIL),
        isInitializing: true);
    await appStore.setUserName(getStringAsync(USERNAME), isInitializing: true);
    await appStore.setContactNumber(getStringAsync(CONTACT_NUMBER),
        isInitializing: true);
    await appStore.setUserProfile(getStringAsync(PROFILE_IMAGE),
        isInitializing: true);
    await appStore.setCountryId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setStateId(getIntAsync(STATE_ID), isInitializing: true);
    await appStore.setCityId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setUId(getStringAsync(UID), isInitializing: true);
    await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);
    await appStore.setAddress(getStringAsync(ADDRESS), isInitializing: true);
    await appStore.setCurrencyCode(getStringAsync(CURRENCY_COUNTRY_CODE),
        isInitializing: true);
    await appStore.setCurrencyCountryId(getStringAsync(CURRENCY_COUNTRY_ID),
        isInitializing: true);
    await appStore.setCurrencySymbol(getStringAsync(CURRENCY_COUNTRY_SYMBOL),
        isInitializing: true);
    await appStore.setPrivacyPolicy(getStringAsync(PRIVACY_POLICY),
        isInitializing: true);
    await appStore.setLoginType(getStringAsync(LOGIN_TYPE),
        isInitializing: true);
    await appStore.setTermConditions(getStringAsync(TERM_CONDITIONS),
        isInitializing: true);
    await appStore.setInquiryEmail(getStringAsync(INQUIRY_EMAIL),
        isInitializing: true);
    await appStore.setHelplineNumber(getStringAsync(HELPLINE_NUMBER),
        isInitializing: true);
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = new MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: 'AIzaSyDFN-73p8zKVZbA0i5DtO215XzAb-xuGSE',
      appId: '1:1000163153346:web:4f702a4b5adbd5c906b25b',
      messagingSenderId: 'G-L1GNL2YV61',
      projectId: 'ammart-8885e',
    ));
  }
  serviceProviderMain();
  await Firebase.initializeApp();
  Map<String, Map<String, String>> _languages = await di.init();

  NotificationBody _body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        _body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {}

  // if (ResponsiveHelper.isWeb()) {
  //   FacebookAuth.i.webInitialize(
  //     appId: "452131619626499",
  //     cookie: true,
  //     xfbml: true,
  //     version: "v9.0",
  //   );
  // }

  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  runApp(MyApp(languages: _languages, body: _body));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final NotificationBody body;
  MyApp({@required this.languages, @required this.body});

  void _route() {
    Get.find<SplashController>().getConfigData().then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
          await Get.find<WishListController>().getWishList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      if (Get.find<LocationController>().getUserAddress() != null &&
          Get.find<LocationController>().getUserAddress().zoneIds == null) {
        Get.find<AuthController>().clearSharedAddress();
      }
      Get.find<CartController>().getCartData();
      _route();
    }

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null)
              ? SizedBox()
              : Observer(
                  builder: (_) => FutureBuilder<Color>(
                    future: getMaterialYouData(),
                    builder: (_, snap) {
                      return GetMaterialApp(
                        title: AppConstants.APP_NAME,
                        debugShowCheckedModeBanner: false,
                        navigatorKey: Get.key,
                        scrollBehavior: MaterialScrollBehavior().copyWith(
                          dragDevices: {
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.touch
                          },
                        ),
                        // theme: themeController.darkTheme
                        //     ? themeController.darkColor == null
                        //         ? dark()
                        //         : dark(color: themeController.darkColor)
                        //     : themeController.lightColor == null
                        //         ? light()
                        //         : light(color: themeController.lightColor),
                        locale: localizeController.locale,
                        translations: Messages(languages: languages),
                        fallbackLocale: Locale(
                            AppConstants.languages[0].languageCode,
                            AppConstants.languages[0].countryCode),
                        initialRoute: GetPlatform.isWeb
                            ? RouteHelper.getInitialRoute()
                            : RouteHelper.getSplashRoute(body),
                        getPages: RouteHelper.routes,
                        defaultTransition: Transition.topLevel,
                        transitionDuration: Duration(milliseconds: 500),
                        //  navigatorKey: navigatorKey,
                        theme: AppTheme.lightTheme(color: snap.data),
                        darkTheme: AppTheme.darkTheme(color: snap.data),
                        themeMode: appStore.isDarkMode
                            ? ThemeMode.dark
                            : ThemeMode.light,
                        supportedLocales: LanguageDataModel.languageLocales(),
                        localizationsDelegates: [
                          AppLocalizations(),
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        localeResolutionCallback: (locale, supportedLocales) =>
                            locale,
                        // locale: Locale(appStore.selectedLanguageCode),
                      );
                    },
                  ),
                );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
