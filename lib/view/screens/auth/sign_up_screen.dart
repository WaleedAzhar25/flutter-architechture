import 'dart:convert';
import 'dart:developer';

import 'package:country_code_picker/country_code.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/body/signup_body.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
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
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

import '../../../social_app/global/global.dart';
import '../../../social_app/shared_preferences/preferencesKey.dart';
import '../../../util/colors.dart';
import 'widget/social_login_widget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String _countryDialCode = 'EG';

  @override
  void initState() {
    super.initState();

    _countryDialCode = 'EG';
    // CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: GetBuilder<AuthController>(builder: (authController) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 50),
                    InkWell(
                      onTap: () {
                        // Get.off(OnBoardingScreen());
                      },
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
                          "signup_social".tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorResources.black3.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Column(children: [
                      CustomTextField(
                        hintText: 'first_name'.tr,
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        nextFocus: _lastNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        prefixIcon: Images.user,
                        divider: true,
                      ),
                      // CustomTextField(
                      //   hintText: 'last_name'.tr,
                      //   controller: _lastNameController,
                      //   focusNode: _lastNameFocus,
                      //   nextFocus: _emailFocus,
                      //   inputType: TextInputType.name,
                      //   capitalization: TextCapitalization.words,
                      //   prefixIcon: Images.user,
                      //   divider: true,
                      // ),
                      CustomTextField(
                        hintText: 'email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _phoneFocus,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Images.mail,
                        divider: true,
                      ),
                      Row(children: [
                        CodePickerWidget(
                          onChanged: (CountryCode countryCode) {
                            _countryDialCode = countryCode.dialCode;
                          },
                          initialSelection: _countryDialCode,
                          // CountryCode.fromCountryCode(
                          //         Get.find<SplashController>()
                          //             .configModel
                          //             .country)
                          //     .code,
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
                          dialogBackgroundColor: Theme.of(context).cardColor,
                          textStyle: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                        Expanded(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CustomTextField(
                          hintText: 'password'.tr,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          nextFocus: _confirmPasswordFocus,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Images.password,
                          isSVG: true,
                          isPassword: true,
                          divider: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CustomTextField(
                          hintText: 'confirm_password'.tr,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          nextFocus: Get.find<SplashController>()
                                      .configModel
                                      .refEarningStatus ==
                                  1
                              ? _referCodeFocus
                              : null,
                          inputAction: Get.find<SplashController>()
                                      .configModel
                                      .refEarningStatus ==
                                  1
                              ? TextInputAction.next
                              : TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Images.password,
                          isSVG: true,
                          isPassword: true,
                          onSubmit: (text) =>
                              (GetPlatform.isWeb && authController.acceptTerms)
                                  ? _register(authController, _countryDialCode)
                                  : null,
                        ),
                      ),
                      // (Get.find<SplashController>()
                      //             .configModel
                      //             .refEarningStatus ==
                      //         1)
                      //     ? CustomTextField(
                      //         hintText: 'refer_code'.tr,
                      //         controller: _referCodeController,
                      //         focusNode: _referCodeFocus,
                      //         inputAction: TextInputAction.done,
                      //         inputType: TextInputType.text,
                      //         capitalization: TextCapitalization.words,
                      //         prefixIcon: Images.refer_code,
                      //         divider: false,
                      //         prefixSize: 14,
                      //       )
                      //     : SizedBox(),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    ConditionCheckBox(authController: authController),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    // SizedBox(height: 60),
                    !authController.isLoading
                        ? MaterialButton(
                            onPressed: authController.acceptTerms
                                ? () =>
                                    _register(authController, _countryDialCode)
                                : null,
                            child: Text(
                              'sign_up'.tr,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have an Account?",
                          style: TextStyle(
                            fontSize: 13,
                            color: ColorResources.grey4,
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.toNamed(
                              RouteHelper.getSignInRoute(RouteHelper.signUp)),
                          child: Text(
                            'sign_in'.tr,
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorResources.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // SocialLoginWidget(),

                    Center(child: GuestButton()),
                  ]);
            }),
          ),
        ),
      )),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _number = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    String _referCode = _referCodeController.text.trim();

    String _numberWithCountryCode = '+20' + _number;
    // String _numberWithCountryCode = countryCode + _number;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode = '+' +
            '20'
            // phoneNumber.countryCode
            +
            phoneNumber.nationalNumber;

        _isValid = true;
      } catch (e) {}
    }
    log('phonee no is : $_numberWithCountryCode');
    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }
    // else if (_lastName.isEmpty) {
    //   showCustomSnackBar('enter_your_last_name'.tr);
    // }
    else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (_number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else if (_referCode.isNotEmpty && _referCode.length != 10) {
      showCustomSnackBar('invalid_refer_code'.tr);
    } else {
      SignUpBody signUpBody = SignUpBody(
        fName: _firstName,
        lName: '.',
        email: _email,
        phone: _numberWithCountryCode,
        password: _password,
        refCode: _referCode,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel.customerVerification) {
            List<int> _encoded = utf8.encode(_password);
            String _data = base64Encode(_encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode,
                status.message, RouteHelper.signUp, _data));
          } else {
            Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
