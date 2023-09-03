import 'dart:async';
import 'dart:convert';
import 'dart:developer' as d;
import 'dart:io';

import 'package:country_code_picker/country_code.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/service/model/login_model.dart';
import 'package:sixam_mart/service/network/rest_apis.dart';
import 'package:sixam_mart/service/utils/constant.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/custom_text_field.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/auth/widget/code_picker_widget.dart';
import 'package:sixam_mart/view/screens/auth/widget/condition_check_box.dart';
import 'package:sixam_mart/view/screens/auth/widget/guest_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

import '../../../controller/user_controller.dart';
import '../../../service/main.dart';
import '../../../social_app/global/global.dart';
import '../../../social_app/shared_preferences/preferencesKey.dart';
import '../../../util/colors.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  SignInScreen({@required this.exitFromApp});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _countryDialCode = 'EG';
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    _countryDialCode = 'EG';
    // Get.find<AuthController>().getUserCountryCode().isNotEmpty
    //     ? Get.find<AuthController>().getUserCountryCode()
    //     : CountryCode.fromCountryCode(
    //             Get.find<SplashController>().configModel.country)
    //         .dialCode;
    _phoneController.text = Get.find<AuthController>().getUserNumber() ?? '';
    _passwordController.text =
        Get.find<AuthController>().getUserPassword() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
            return Future.value(false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            ));
            _canExit = true;
            Timer(Duration(seconds: 2), () {
              _canExit = false;
            });
            return Future.value(false);
          }
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorResources.white,
        endDrawer: MenuDrawer(),
        body: SafeArea(
            child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: GetBuilder<AuthController>(builder: (authController) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 50),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: ColorResources.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 13,
                                color: ColorResources.blue1.withOpacity(0.3),
                                spreadRadius: 0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: ColorResources.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "get_start".tr,
                            style: TextStyle(
                              fontSize: 28,
                              color: ColorResources.black2,
                            ),
                          ),
                          Text(
                            "login_social".tr,
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorResources.black3.withOpacity(0.6)),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),

                      Column(children: [
                        Row(children: [
                          CodePickerWidget(
                            onChanged: (CountryCode countryCode) {
                              _countryDialCode = countryCode.dialCode;
                            },
                            // enabled: false,
                            initialSelection: _countryDialCode,
                            //  _countryDialCode != null
                            //     ? CountryCode.fromCountryCode(
                            //             Get.find<SplashController>()
                            //                 .configModel
                            //                 .country)
                            //         .code

                            //  Get.find<LocalizationController>()
                            //     .locale
                            //     .countryCode,
                            favorite: [
                              CountryCode.fromCountryCode(
                                      Get.find<SplashController>()
                                          .configModel
                                          .country)
                                  .code
                            ],
                            showDropDownButton: true,
                            padding: EdgeInsets.zero,
                            showFlagMain: true,
                            flagWidth: 30,
                            dialogBackgroundColor: Theme.of(context).cardColor,
                            textStyle: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: CustomTextField(
                                hintText: 'phone'.tr,
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                nextFocus: _passwordFocus,
                                inputType: TextInputType.phone,
                                divider: false,
                              )),
                        ]),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE),
                            child: Divider(height: 1)),
                        CustomTextField(
                          hintText: 'password'.tr,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Images.password,
                          isSVG: true,
                          isPassword: true,
                          onSubmit: (text) =>
                              (GetPlatform.isWeb && authController.acceptTerms)
                                  ? _login(authController, _countryDialCode)
                                  : null,
                        ),
                      ]),
                      SizedBox(height: 10),

                      Row(children: [
                        Expanded(
                          child: ListTile(
                            onTap: () => authController.toggleRememberMe(),
                            leading: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              value: authController.isActiveRememberMe,
                              onChanged: (bool isChecked) =>
                                  authController.toggleRememberMe(),
                            ),
                            title: Text('remember_me'.tr),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            horizontalTitleGap: 0,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(
                              RouteHelper.getForgotPassRoute(false, null)),
                          child: Text(
                            '${'forgot_password'.tr}?',
                            style: robotoRegular.copyWith(
                              color: ColorResources.blue,
                            ),
                          ),
                        ),
                      ]),

                      ConditionCheckBox(authController: authController),
                      SizedBox(height: 30),
                      !authController.isLoading
                          ? MaterialButton(
                              onPressed: authController.acceptTerms
                                  ? () =>
                                      _login(authController, _countryDialCode)
                                  : null,
                              child: Text(
                                'sign_in'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ColorResources.white,
                                ),
                              ),
                              height: 50,
                              minWidth: Get.width,
                              color: ColorResources.blue1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            )
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(height: 12),
                      // MaterialButton(
                      //   onPressed: () {
                      //     Get.to(() => MyServiceApp());
                      //   },
                      //   child: Text(
                      //     'service provider',
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: ColorResources.white,
                      //     ),
                      //   ),
                      //   height: 50,
                      //   minWidth: Get.width,
                      //   color: ColorResources.blue1,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(60),
                      //   ),
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Not Have an Account?",
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorResources.grey4,
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                Get.toNamed(RouteHelper.getSignUpRoute()),
                            child: Text(
                              " Sign Up",
                              style: TextStyle(
                                fontSize: 13,
                                color: ColorResources.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      // SocialLoginWidget(),

                      Center(child: GuestButton()),
                    ]),
              );
            }),
          ),
        )),
      ),
    );
  }

  Future<void> _signInSocialUser({String email, String password}) async {
    try {
      FirebaseMessaging.instance.getToken().then((token) async {
        print(token);
        final response =
            await client.post(Uri.parse('${baseUrl()}/login'), body: {
          "email": email,
          "password": password,
          "device_token": token,
        });
        print('*****************' + token + '*****************');

        if (response.statusCode == 200) {
          Map<String, dynamic> dic = json.decode(response.body);

          d.log('social login response is : ${response.body}');
          if (dic['response_code'] == "1") {
            String userResponseStr = json.encode(dic);
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString(
                SharedPreferencesKey.LOGGED_IN_USERRDATA, userResponseStr);
          } else {
            socialootoast("Error",
                "Wrong Email / Phone Number, Please try agains", context);
          }
        } else {
          socialootoast("Error", "Cannot communicate with server", context);
        }
      });
    } catch (e) {
      socialootoast("Error", e.toString(), context);
    }
  }

  //region Methods
  void _loginServiceProviderUsers(String email, String password) async {
    void login() async {
      var request = {
        'email': email.trim(),
        'password': password.trim(),
        'player_id': getStringAsync(PLAYERID),
      };

      d.log("Login Request $request");
      await loginUser(request).then((loginResponse) async {
        // serviceProviderMain();
        setValue(USER_EMAIL, email);
        setValue(USER_PASSWORD, password);
        await setValue(IS_REMEMBERED, true);

        if (loginResponse.userData != null) {
          loginResponse.userData.password = password.trim();

          await authService
              .signInWithEmailPassword(
            email: loginResponse.userData.email.validate(),
          )
              .then((value) async {
            d.log(
                "============================= FIREBASE LOGIN SUCCESSFUL =============================");
            loginResponse.userData.uid = value.uid.validate();
            if (loginResponse.userData != null)
              await saveUserData(loginResponse.userData);

            /// Saving Player ID to Firebase
            userService
                .updatePlayerIdInFirebase(
                    email: loginResponse.userData.email.validate(),
                    playerId: getStringAsync(PLAYERID))
                .catchError((e) {
              // toast(e.toString());
              d.log('updatePlayerIdInFirebase erroor : $e');
            });
          }).catchError((e) {
            if (e.toString() == USER_NOT_FOUND) {
              d.log(
                  "============================= USER NOT FOUND - REGISTERING IN FIREBASE =============================");

              loginResponse.userData.password = password.trim();
              authService
                  .signUpWithEmailPassword(userData: loginResponse.userData)
                  .then((value) async {
                if (loginResponse.userData != null)
                  await saveUserData(loginResponse.userData);

                /// Saving Player ID to Firebase
                userService
                    .updatePlayerIdInFirebase(
                        email: loginResponse.userData.email.validate(),
                        playerId: getStringAsync(PLAYERID))
                    .catchError((e) {
                  // toast(e.toString());
                  d.log(e.toString());
                });
              }).catchError((e) {
                d.log(e.toString());
                // toast(e.toString(), print: true);
              });
            } else {
              d.log(e.toString());
              // toast(e.toString(), print: true);
            }
          });
        }
      }).catchError((e) {
        d.log('service user login error : $e');
      });
    }

    login();
  }

  void _login(AuthController authController, String countryDialCode) async {
    String _phone = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _numberWithCountryCode = '+20' + _phone;
    // String _numberWithCountryCode = countryDialCode + _phone;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(_numberWithCountryCode);
        // _numberWithCountryCode =
        //     '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _numberWithCountryCode = '+' + '20' + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }
    d.log('phoone no is : ${_numberWithCountryCode}');
    if (_phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController
          .login(_numberWithCountryCode, _password)
          .then((status) async {
        // log('infoo model toojson is : ${Get.find<UserController>().userInfoModel.toJson()}');
        var userModel = Get.find<UserController>().userInfoModel;
        if (userModel == null) {
          userModel = await Get.find<UserController>().getUserInfoModel();
          ;
        }
        try {
          d.log('service login try start');
          await _loginServiceProviderUsers(userModel.email, _password);
        } catch (e) {
          d.log('serivce provider login error is : $e');
        }
        try {
          d.log('social login try start');
          await _signInSocialUser(email: userModel.email, password: _password);
        } catch (e) {
          d.log('social app login error is : $e');
        }
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(
                _phone, _password, countryDialCode);
          } else {
            authController.clearUserNumberAndPassword();
          }
          String _token = status.message.substring(1, status.message.length);
          if (Get.find<SplashController>().configModel.customerVerification &&
              int.parse(status.message[0]) == 0) {
            List<int> _encoded = utf8.encode(_password);
            String _data = base64Encode(_encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(
                _numberWithCountryCode, _token, RouteHelper.signUp, _data));
          } else {
            Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
