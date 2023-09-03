import 'dart:convert';
import '../Helper/sizeConfig.dart';
import '../global/global.dart';
import '../models/changpassModal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChnagePassScreen extends StatefulWidget {
  @override
  _ChnagePassState createState() => _ChnagePassState();
}

class _ChnagePassState extends State<ChnagePassScreen> {
  final TextEditingController _oldpassController = TextEditingController();
  final TextEditingController _newpassController = TextEditingController();
  final TextEditingController _cpassController = TextEditingController();

  bool isLoading = false;
  ChangePassModal modal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              const Color(0xFFfdfbfb),
              const Color(0xFFebedee),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Change Password",
            style: TextStyle(
                fontSize: 16,
                color: appColorBlack,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _loginForm(context),
            isLoading
                ? Center(
                    child: loader(context),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(height: SizeConfig.blockSizeVertical * 5),
                Container(
                  // color: Colors.red,
                  child: Column(
                    children: <Widget>[
                      _emailTextfield(context),
                      Container(height: SizeConfig.blockSizeVertical * 2),
                      _newTextfield(context),
                      Container(height: SizeConfig.blockSizeVertical * 2),
                      _cpassTextfield(context),
                      Container(height: SizeConfig.blockSizeVertical * 20),

                      _loginButton(context),

                      // _facebookButton(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return TextField(
      controller: _oldpassController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: 'Enter  old password'),
    );
  }

  Widget _newTextfield(BuildContext context) {
    return TextField(
      controller: _newpassController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: 'Enter new password'),
    );
  }

  Widget _cpassTextfield(BuildContext context) {
    return TextField(
      controller: _cpassController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: 'Enter Confirm password'),
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      height: 70,
      width: MediaQuery.of(context).size.width - 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Container(
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.screenWidth,
          child: ElevatedButton(
            child: Text("Next".toUpperCase()),
            style: ElevatedButton.styleFrom(
              primary: appColor,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () async {
              _changePassAPICall();
            },
          ),
        ),
      ),
    );
  }

  _changePassAPICall() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/change_password');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID;
    request.fields['password'] = _oldpassController.text;
    request.fields['npassword'] = _newpassController.text;
    request.fields['cpassword'] = _cpassController.text;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    modal = ChangePassModal.fromJson(userData);
    if (modal.responseCode == "1") {
      errorDialog(context, modal.message.toString());
    } else {
      errorDialog(context, modal.message.toString());
    }

    setState(() {
      isLoading = false;
    });
  }
}
