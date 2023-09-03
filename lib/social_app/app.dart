import 'dart:io';
import 'dart:developer' as d;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import './configs/Mycolors.dart';
import './global/global.dart';
import './layouts/splashscreen.dart';
import './layouts/navigationbar/navigation_bar.dart';
import './route_generator.dart';
import './shared_preferences/preferencesKey.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Socialoo extends StatefulWidget {
  SharedPreferences prefs;
  final AdaptiveThemeMode savedThemeMode;

  Socialoo(
    this.prefs,
    this.savedThemeMode,
  );

  @override
  State<Socialoo> createState() => _SocialooState();
}

class _SocialooState extends State<Socialoo> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  pref() async {
    widget.prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    pref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setnotification();
    return AdaptiveTheme(
      light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
          primaryColor: Colors.blue,
          primaryColorDark: Mycolors.primaryColorLight,
          // primaryColorLight: Mycolors.primaryColorLight,
          canvasColor: Colors.white,
          disabledColor: Mycolors.menuBackgroundColor,
          backgroundColor: Mycolors.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Mycolors.appbarbackgroundColor,
            actionsIconTheme: IconThemeData(
              color: Mycolors.appbariconcolor,
            ),
            iconTheme: IconThemeData(
              color: Mycolors.appbariconcolor,
              size: 24,
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Mycolors.tabbarlabelColor,
            unselectedLabelColor: Mycolors.tabbarunselectedLabelColor,
          ),
          iconTheme: const IconThemeData(color: Mycolors.iconThemeColor),
          scaffoldBackgroundColor: Mycolors.scaffoldBackgroundColor,
          textTheme: TextTheme(
            headline4: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Mycolors.apptitlecolor,
            ),
          ),
          cardColor: Mycolors.cardColor,
          shadowColor: Mycolors.shadowColor,
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: Mycolors.inputfillcolor,
          ),
          secondaryHeaderColor: Mycolors.secondaryHeaderColor),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        backgroundColor: Mycolors.backgroundColordark,
        disabledColor: Mycolors.scaffoldBackgroundColordark,
        secondaryHeaderColor: Mycolors.secondaryHeaderColorDark,
        appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData(
            color: Mycolors.appbariconcolordark,
          ),
          backgroundColor: Mycolors.appbarbackgroundColordark,
          iconTheme:
              IconThemeData(color: Mycolors.appbariconcolordark, size: 24),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Mycolors.tabbarlabelColordark,
          unselectedLabelColor: Mycolors.tabbarunselectedLabelColordark,
        ),
        iconTheme: const IconThemeData(color: Mycolors.iconThemeColordark),
        scaffoldBackgroundColor: Mycolors.scaffoldBackgroundColordark,
        textTheme: TextTheme(
          headline4: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Mycolors.apptitlecolordark,
          ),
        ),
        cardColor: Mycolors.cardColordark,
        shadowColor: Mycolors.shadowColordark,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Mycolors.inputfillcolordark,
        ),
      ),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Socialoo',
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: _handleCurrentScreen(widget.prefs),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

  Widget _handleCurrentScreen(SharedPreferences prefs) {
    d.log('preferences is : $prefs');
    String data = prefs == null
        ? null
        : prefs.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    preferences = prefs;
    if (data == null) {
      return SplashScreen();
    } else {
      return NavBar();
    }
  }

  setnotification() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    if (Platform.isIOS) {
      firebaseMessaging.setForegroundNotificationPresentationOptions(
        sound: true,
        alert: true,
        badge: true,
      );
    } else {}
  }
}
