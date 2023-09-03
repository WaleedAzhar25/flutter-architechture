// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:developer' as d;
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:nb_utils/src/widget_extensions.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../util/colors.dart';
import '../../global/global.dart';
import '../../layouts/user/createProfile.dart';
import '../../layouts/webview/webview.dart';
import '../../layouts/widgets/bezier_container.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File imageFile;
  bool isLoading = false;
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = false;
  bool checkedValue = false;

  @override
  void initState() {
    super.initState();
  }

  String userId;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpassController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SizedBox(
            height: height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: const BezierContainer(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .17),
                        _title(),
                        const SizedBox(height: 35),
                        _emailPasswordWidget(),
                        const SizedBox(height: 8),
                        _termsCondition(context),
                        const SizedBox(height: 8),
                        _submitButton(),
                        SizedBox(height: height * .03),
                        _loginAccount(),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 40, left: 0, child: _backButton()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _loginAccount() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xFF1e3c72),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Easy City',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1e3c72),
        ),
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left,
                  color: Theme.of(context).iconTheme.color),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username", nameController, TextInputAction.next),
        _entryField("Email id", emailController, TextInputAction.next),
        _passwordTextfield(context),
      ],
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      TextInputAction textInputAction,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              textInputAction: textInputAction,
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: ColorResources.blue1),
      child: const Text(
        'Register Now',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ).onTap(() {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern as String);
      if (passwordController.text != '' &&
          nameController.text != '' &&
          regex.hasMatch(emailController.text.trim()) &&
          emailController.text.trim() != '' &&
          passwordController.text.length > 5 &&
          checkedValue != false) {
        _apiCall();
      } else {
        if (nameController.text.isEmpty)
          simpleAlertBox(
              content: Text("Please enter username"), context: context);
        else if (passwordController.text.isEmpty) {
          simpleAlertBox(
              content: Text(
                  "Fields is empty or password length should be between 6-8 characters."),
              context: context);
        } else if (emailController.text.isEmpty) {
          simpleAlertBox(content: Text("please enter email"), context: context);
        } else if (checkedValue == false) {
          simpleAlertBox(
              content: Text("Accept term & condition to continue"),
              context: context);
        } else {
          simpleAlertBox(
              content: Text("please enter valid email"), context: context);
        }
      }
    });
  }

  Widget _passwordTextfield(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              textInputAction: TextInputAction.next,
              controller: passwordController,
              obscureText: !_obscureText,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: appColorGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  filled: true))
        ],
      ),
    );
  }

  _termsCondition(BuildContext context) {
    void _handleURLButtonPress(BuildContext context, String url) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WebViewContainer(url)));
    }

    return CheckboxListTile(
      title: Wrap(
        alignment: WrapAlignment.start,
        children: <Widget>[
          Text("By using our app you agree to our ",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.normal,
                // color: appColorBlack,
              )),
          InkWell(
            onTap: () {
              _handleURLButtonPress(
                  context, "https://docsopedia.com/term-policy.html");
            },
            child: Text("Terms and Conditions ",
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
          ),
          Text("and ",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.normal,
                // color: appColorBlack,
              )),
          InkWell(
            onTap: () {
              _handleURLButtonPress(
                  context, "https://docsopedia.com/privacy-policy.html");
            },
            child: Text("Privacy Policy",
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),

      value: checkedValue,
      onChanged: (newValue) {
        setState(() {
          checkedValue = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Future<void> _apiCall() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await client
          .post(Uri.parse('${baseUrl()}/username_email_check'), body: {
        "username": nameController.text,
        "email": emailController.text.toLowerCase().trim().toString(),
        "password": passwordController.text
      });
      d.log('user sign up response body is : ${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        Map<String, dynamic> dic = json.decode(response.body);

        if (dic['response_code'] == "1") {
          setState(() {
            isLoading = false;
          });

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateProfile(
                  id: dic['user']['id'],
                  name: nameController.text,
                  password: passwordController.text,
                  email: emailController.text)));
        } else {
          setState(() {
            isLoading = false;
          });
          socialootoast("Error", dic['message'], context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        socialootoast("Error", "Cannot communicate with server", context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      socialootoast("Error", e.toString(), context);
    }
  }
}
