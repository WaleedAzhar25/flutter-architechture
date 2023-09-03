import 'dart:convert';
import 'dart:developer' as d;
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/data/model/body/delivery_man_body.dart';
import 'package:sixam_mart/data/model/body/store_body.dart';
import 'package:sixam_mart/data/model/body/signup_body.dart';
import 'package:sixam_mart/data/model/body/social_log_in_body.dart';
import 'package:sixam_mart/data/model/response/response_model.dart';
import 'package:sixam_mart/data/model/response/zone_model.dart';
import 'package:sixam_mart/data/model/response/zone_response_model.dart';
import 'package:sixam_mart/data/repository/auth_repo.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/service/main.dart';
import 'package:sixam_mart/service/model/login_model.dart';
import 'package:sixam_mart/service/model/user_data_model.dart';
import 'package:sixam_mart/service/network/rest_apis.dart';
import 'package:sixam_mart/service/utils/constant.dart';
import 'package:sixam_mart/social_app/util/data.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sixam_mart/social_app/global/global.dart';
import 'package:sixam_mart/social_app/shared_preferences/preferencesKey.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({@required this.authRepo}) {
    _notification = authRepo.isNotificationActive();
  }

  bool _isLoading = false;
  bool _notification = true;
  bool _acceptTerms = true;
  XFile _pickedLogo;
  XFile _pickedCover;
  List<ZoneModel> _zoneList;
  int _selectedZoneIndex = 0;
  LatLng _restaurantLocation;
  List<int> _zoneIds;
  XFile _pickedImage;
  List<XFile> _pickedIdentities = [];
  List<String> _identityTypeList = ['passport', 'driving_license', 'nid'];
  int _identityTypeIndex = 0;
  List<String> _dmTypeList = ['freelancer', 'salary_based'];
  int _dmTypeIndex = 0;
  List<String> _deliveryTimeTypeList = ['minute', 'hours', 'days'];
  int _deliveryTimeTypeIndex = 0;

  bool get isLoading => _isLoading;
  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;
  XFile get pickedLogo => _pickedLogo;
  XFile get pickedCover => _pickedCover;
  List<ZoneModel> get zoneList => _zoneList;
  int get selectedZoneIndex => _selectedZoneIndex;
  LatLng get restaurantLocation => _restaurantLocation;
  List<int> get zoneIds => _zoneIds;
  XFile get pickedImage => _pickedImage;
  List<XFile> get pickedIdentities => _pickedIdentities;
  List<String> get identityTypeList => _identityTypeList;
  int get identityTypeIndex => _identityTypeIndex;
  List<String> get dmTypeList => _dmTypeList;
  int get dmTypeIndex => _dmTypeIndex;
  List<String> get deliveryTimeTypeList => _deliveryTimeTypeList;
  int get deliveryTimeTypeIndex => _deliveryTimeTypeIndex;
  Future<void> createSocialUser(
      {String username, String email, String password}) async {
    final response = await client
        .post(Uri.parse('${baseUrl()}/username_email_check'), body: {
      "username": username,
      "email": email.toLowerCase().trim().toString(),
      "password": password
    });

    Map<String, dynamic> dic = json.decode(response.body);
    log('social user creaeteee reseponsee : ${response.body}');
    if (dic['response_code'] == "1") {
      FirebaseMessaging.instance.getToken().then((token) async {
        var res = {
          "response_code": "1",
          "message": "user register success",
          "status": "success",
          "user": {
            "username": dic['user']['username'],
            "email": dic['user']['email'],
            "password": dic['user']['password'],
            "salt": dic['user']['salt'],
            "id": dic['user']['id'],
            "fullname": dic['user']['username'],
            "phone": "",
            "login_type": "",
            "google_id": "",
            "profile_pic": null,
            "cover_pic": null,
            "age": "",
            "gender": "",
            "country": "",
            "state": "",
            "city": "",
            "bio": "",
            "interests_id": [],
            "device_token": token,
            "create_date": DateTime.now().toString(),
          },
          "user_token": token,
        };
        var aa = {
          "response_code": "1",
          "message": "user register success",
          "status": "success",
          "user": {
            "id": "86",
            "fullname": "",
            "username": "faheem1",
            "email": "faheem1@gmail.com",
            "phone": "",
            "salt": "755",
            "password": "d769f0b70f498f701c0ffc7eda87a1e9",
            "login_type": "",
            "google_id": "",
            "profile_pic": null,
            "cover_pic": null,
            "age": "30",
            "gender": "Male",
            "country": "Pakistan",
            "state": "Islamabad Capital Territory",
            "city": "Islamabad",
            "bio": "",
            "interests_id": [],
            "device_token":
                "dP3D0Mn-mhbmxG3wp9np40:APA91bFuhvxDZdI1yEf_AeFh0b-tWDMqDOvGWBBPGZkn7QT49M_DTnrSy9SYJzpqbtl8c-uyIc7UDccavsvkoLVJW1Kn03DxOTJzWqxbbp7kAmNlh5AXUkImtGz_V8AWkBrHiQC8haYU",
            "create_date": "1679239945601"
          },
          "user_token": "382f09d9221046871e5068e9b0cd88c3"
        };

        String userResponseStr = json.encode(res);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(
            SharedPreferencesKey.LOGGED_IN_USERRDATA, userResponseStr);
      });
    }
  }

  void registerServiceUser({
    String email,
    String password,
    String fname,
    String lname,
    String phone,
  }) async {
    // user create response is : {api_token: 36|9zstRf4j3vE2X8kkhINagu5p65mye95m5njdAHPL, password: 123456, contact_number: 92-3475632655, created_at: 2023-04-06T14:51:43.000000Z, display_name: User 1, email: user@gmail.com, first_name: User, id: 12, last_name: 1, updated_at: 2023-04-06T14:51:43.000000Z, user_type: user, username: user1}
    /// Create a temporary request to send
    String randomUsername = random.nextInt(6).toString();
    UserData tempRegisterData = UserData()
      ..contactNumber = phone.trim()
      ..firstName = fname.trim()
      ..lastName = lname.trim()
      ..userType = USER_TYPE_USER
      ..username = (fname + lname + randomUsername).trim()
      ..email = email.trim()
      ..password = password.trim();
    d.log('registerServiceUser is called');
    await createUser(tempRegisterData.toJson()).then((registerResponse) async {
      registerResponse.userData.password = password.trim();
      d.log('registerServiceUser then is called');
      // serviceProviderMain();

      /// After successful entry in the mysql database it will login into firebase.
      await firebaseSignup(registerResponse: registerResponse);
    }).catchError((e) {
      toast(e.toString());
      d.log('registerServiceUser error is called : ${e.toString()}');
    });
  }

  Future<void> firebaseSignup(
      {@required LoginResponse registerResponse}) async {
    await authService
        .signUpWithEmailPassword(userData: registerResponse.userData)
        .then((value) async {
      if (value) {
        /// If Registered then check for the type of  user to directly login or send to signup page.

        var request = {
          "email": registerResponse.userData.email.validate(),
          'password': registerResponse.userData.password.validate(),
          'player_id': appStore.playerId,
        };

        /// Calling Login API

        await loginUser(request).then((res) async {
          if (res.userData.userType == LOGIN_TYPE_USER) {
            /// When Login is Successfully done and will redirect to HomeScreen.
            // toast(language.loginSuccessfully, print: true);

            if (res.userData != null) await saveUserData(res.userData);
          }
        }).catchError((e) {
          // toast(language.lblLoginAgain);
        });
      }
    }).catchError((e) {
      log("Login Response Error: ${e.toString()}");
    });
  }

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (!Get.find<SplashController>().configModel.customerVerification) {
        authRepo.saveUserToken(response.body["token"]);
        await authRepo.updateToken();
        Get.find<UserController>().getUserInfo();
      }
      await createSocialUser(
        email: signUpBody.email,
        username: signUpBody.fName + signUpBody.lName,
        password: signUpBody.password,
      );
      await registerServiceUser(
        fname: signUpBody.fName,
        lname: signUpBody.lName,
        email: signUpBody.email,
        password: signUpBody.password,
        phone: signUpBody.phone,
      );

      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String phone, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(phone: phone, password: password);
    ResponseModel responseModel;
    log('reeposonse body for eecommeerce login is : ${response.body}');
    if (response.statusCode == 200) {
      if (Get.find<SplashController>().configModel.customerVerification &&
          response.body['is_phone_verified'] == 0) {
      } else {
        authRepo.saveUserToken(response.body['token']);
        await authRepo.updateToken();
        Get.find<UserController>().getUserInfo();
      }
      responseModel = ResponseModel(true,
          '${response.body['is_phone_verified']}${response.body['token']}');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> loginWithSocialMedia(SocialLogInBody socialLogInBody) async {
    _isLoading = true;
    update();
    Response response =
        await authRepo.loginWithSocialMedia(socialLogInBody.email);
    if (response.statusCode == 200) {
      String _token = response.body['token'];
      if (_token != null && _token.isNotEmpty) {
        if (Get.find<SplashController>().configModel.customerVerification &&
            response.body['is_phone_verified'] == 0) {
          Get.toNamed(RouteHelper.getVerificationRoute(
              socialLogInBody.email, _token, RouteHelper.signUp, ''));
        } else {
          authRepo.saveUserToken(response.body['token']);
          await authRepo.updateToken();
          Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
        }
      } else {
        Get.toNamed(RouteHelper.getForgotPassRoute(true, socialLogInBody));
      }
    } else {
      showCustomSnackBar(response.statusText);
    }
    _isLoading = false;
    update();
  }

  Future<void> registerWithSocialMedia(SocialLogInBody socialLogInBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registerWithSocialMedia(socialLogInBody);
    if (response.statusCode == 200) {
      String _token = response.body['token'];
      if (Get.find<SplashController>().configModel.customerVerification &&
          response.body['is_phone_verified'] == 0) {
        Get.toNamed(RouteHelper.getVerificationRoute(
            socialLogInBody.phone, _token, RouteHelper.signUp, ''));
      } else {
        authRepo.saveUserToken(response.body['token']);
        await authRepo.updateToken();
        Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
      }
    } else {
      showCustomSnackBar(response.statusText);
    }
    _isLoading = false;
    update();
  }

  Future<ResponseModel> forgetPassword(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.forgetPassword(email);

    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  Future<ResponseModel> verifyToken(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyToken(email, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String resetToken, String number,
      String password, String confirmPassword) async {
    _isLoading = true;
    update();
    Response response = await authRepo.resetPassword(
        resetToken, number, password, confirmPassword);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> checkEmail(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.checkEmail(email);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String email, String token) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyEmail(email, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      Get.find<UserController>().getUserInfo();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyPhone(String phone, String token) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyPhone(phone, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      Get.find<UserController>().getUserInfo();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> updateZone() async {
    Response response = await authRepo.updateZone();
    if (response.statusCode == 200) {
      // Nothing to do
    } else {
      ApiChecker.checkApi(response);
    }
  }

  String _verificationCode = '';

  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    Get.find<SplashController>().setModule(null);
    return authRepo.clearSharedData();
  }

  bool clearSharedAddress() {
    return authRepo.clearSharedAddress();
  }

  void saveUserNumberAndPassword(
      String number, String password, String countryCode) {
    authRepo.saveUserNumberAndPassword(number, password, countryCode);
  }

  String getUserNumber() {
    return authRepo.getUserNumber() ?? "";
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode() ?? "";
  }

  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authRepo.setNotificationActive(isActive);
    update();
    return _notification;
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if (isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    } else {
      if (isLogo) {
        _pickedLogo =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }

  Future<void> getZoneList() async {
    _pickedLogo = null;
    _pickedCover = null;
    _selectedZoneIndex = 0;
    _restaurantLocation = null;
    _zoneIds = null;
    Response response = await authRepo.getZoneList();
    if (response.statusCode == 200) {
      _zoneList = [];
      response.body.forEach((zone) => _zoneList.add(ZoneModel.fromJson(zone)));
      setLocation(LatLng(
        double.parse(
            Get.find<SplashController>().configModel.defaultLocation.lat ??
                '0'),
        double.parse(
            Get.find<SplashController>().configModel.defaultLocation.lng ??
                '0'),
      ));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setZoneIndex(int index) {
    _selectedZoneIndex = index;
    update();
  }

  void setLocation(LatLng location) async {
    ZoneResponseModel _response = await Get.find<LocationController>().getZone(
      location.latitude.toString(),
      location.longitude.toString(),
      false,
    );
    if (_response != null &&
        _response.isSuccess &&
        _response.zoneIds.length > 0) {
      _restaurantLocation = location;
      _zoneIds = _response.zoneIds;
      for (int index = 0; index < _zoneList.length; index++) {
        if (_zoneIds.contains(_zoneList[index].id)) {
          _selectedZoneIndex = index;
          break;
        }
      }
    } else {
      _restaurantLocation = null;
      _zoneIds = null;
    }
    update();
  }

  Future<void> registerStore(StoreBody storeBody) async {
    _isLoading = true;
    update();
    Response response =
        await authRepo.registerStore(storeBody, _pickedLogo, _pickedCover);
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar('store_registration_successful'.tr, isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  // bool _checkIfValidMarker(LatLng tap, List<LatLng> vertices) {
  //   int intersectCount = 0;
  //   for (int j = 0; j < vertices.length - 1; j++) {
  //     if (_rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
  //       intersectCount++;
  //     }
  //   }
  //
  //   return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  // }

  // bool _rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
  //   double aY = vertA.latitude;
  //   double bY = vertB.latitude;
  //   double aX = vertA.longitude;
  //   double bX = vertB.longitude;
  //   double pY = tap.latitude;
  //   double pX = tap.longitude;
  //
  //   if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
  //     return false; // a and b can't both be above or below pt.y, and a or
  //     // b must be east of pt.x
  //   }
  //
  //   double m = (aY - bY) / (aX - bX); // Rise over run
  //   double bee = (-aX) * m + aY; // y = mx + b
  //   double x = (pY - bee) / m; // algebra is neat!
  //
  //   return x > pX;
  // }

  void setIdentityTypeIndex(String identityType, bool notify) {
    int _index = 0;
    for (int index = 0; index < _identityTypeList.length; index++) {
      if (_identityTypeList[index] == identityType) {
        _index = index;
        break;
      }
    }
    _identityTypeIndex = _index;
    if (notify) {
      update();
    }
  }

  void setDMTypeIndex(String dmType, bool notify) {
    _dmTypeIndex = _dmTypeList.indexOf(dmType);
    if (notify) {
      update();
    }
  }

  void setDeliveryTimeTypeIndex(String type, bool notify) {
    _deliveryTimeTypeIndex = _deliveryTimeTypeList.indexOf(type);
    if (notify) {
      update();
    }
  }

  void pickDmImage(bool isLogo, bool isRemove) async {
    if (isRemove) {
      _pickedImage = null;
      _pickedIdentities = [];
    } else {
      if (isLogo) {
        _pickedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        XFile _xFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (_xFile != null) {
          _pickedIdentities.add(_xFile);
        }
      }
      update();
    }
  }

  void removeIdentityImage(int index) {
    _pickedIdentities.removeAt(index);
    update();
  }

  Future<void> registerDeliveryMan(DeliveryManBody deliveryManBody) async {
    _isLoading = true;
    update();
    List<MultipartBody> _multiParts = [];
    _multiParts.add(MultipartBody('image', _pickedImage));
    for (XFile file in _pickedIdentities) {
      _multiParts.add(MultipartBody('identity_image[]', file));
    }
    Response response =
        await authRepo.registerDeliveryMan(deliveryManBody, _multiParts);
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar('delivery_man_registration_successful'.tr,
          isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }
}
