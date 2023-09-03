// ignore_for_file: implementation_imports, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../util/colors.dart';
import '../../global/global.dart';
import '../../layouts/chat/chat.dart';
import '../../layouts/user/publicProfile.dart';
import '../../models/intrest_model.dart';
import '../../models/postFollowModal.dart';
import '../../models/unFollowModal.dart';
import '../../models/userdata_model.dart';

class RecentUsers extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  bool back;

  RecentUsers({Key key, this.parentScaffoldKey, this.back}) : super(key: key);
  @override
  _RecentUsersState createState() => _RecentUsersState();
}

class _RecentUsersState extends State<RecentUsers> {
  TextEditingController controller = new TextEditingController();

  // ignore: unused_field
  String _categoryValue;
  String categoryName;
  IntrestModel intrestModel;
  bool isSearch = false;
  bool isSearchData = false;
  bool clearData = false;
  String countryValue;
  String stateValue;

  double startAge = 18;
  double endAge = 99;

  bool isLoading = false;
  var userData;
  var serchedUserData;
  UserDataModel modal;
  FollowModal followModal;
  UnfollowModal unfollowModal;

  List userList = [];
  @override
  void initState() {
    _getTopUser();

    super.initState();
  }

  _getTopUser() async {
    setState(() {
      isSearch = true;
    });
    var uri = Uri.parse('${baseUrl()}/get_all_users');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    userData = json.decode(responseData);

    setState(() {
      isSearch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(color: ColorResources.blue1),
            ),
            elevation: 1,
            title: Text(
              "Recent Users",
              style: Theme.of(context).textTheme.headline5.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            centerTitle: true,
            leading: widget.back != null
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                    ))
                : Container(),
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : LayoutBuilder(
                  builder: (context, constraint) {
                    return Column(
                      children: <Widget>[
                        Expanded(
                            child: isSearch == true
                                ? CupertinoActivityIndicator()
                                : _serachuser()),
                      ],
                    );
                  },
                )),
    );
  }

  Widget _serachuser() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: isSearchData == true
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 5),
                  itemCount: serchedUserData['users'].length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    return allUserWidget(serchedUserData['users'][index]);
                  },
                )
              : isSearchData == false
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 5),
                      itemCount: userData['users'].length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return allUserWidget(userData['users'][index]);
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text("No search found"),
                      ),
                    )),
    );
  }

  Widget allUserWidget(lists) {
    return lists['id'] == userID
        ? Container()
        : InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PublicProfile(
                        peerId: lists["id"],
                        peerUrl: lists["profile_pic"],
                        peerName: lists["username"])),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(children: <Widget>[
                  lists["cover_pic"] == null ||
                          lists["cover_pic"].toString().isEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: Image.asset(
                            'assets/images/defaultcover.png',
                            alignment: Alignment.center,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            height: 60,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: lists["cover_pic"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Container(
                        alignment: const Alignment(0.0, 5.5),
                        child: lists["profile_pic"] == null ||
                                lists["profile_pic"].isEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF003a54),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Image.asset(
                                  'assets/images/defaultavatar.png',
                                  width: 50,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: CachedNetworkImage(
                                  imageUrl: lists["profile_pic"],
                                  height: 50.0,
                                  width: 50.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 30),
                Text(
                  lists["username"].toString().capitalize(),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                lists["country"].isNotEmpty
                    ? Text(
                        lists["country"].toString().capitalize(),
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(''),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    globleFollowing.contains(lists["id"])
                        ? Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            height: 30,
                            width: (context.width() - (3 * 16)) * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.redAccent[700],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Unfollow',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ).onTap(() {
                            unfollowApiCall(lists);
                          })
                        : Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            height: 30,
                            width: (context.width() - (3 * 16)) * 0.2,
                            decoration: BoxDecoration(
                              color: Color(0xFF0D56F2),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Follow',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  // fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ).onTap(() {
                            followApiCall(lists);
                          }),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      height: 30,
                      width: (context.width() - (3 * 16)) * 0.2,
                      decoration: const BoxDecoration(
                        color: Color(0xffE5E6EB),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Message',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ).onTap(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(
                            peerID: lists["id"],
                            peerUrl: lists["profile_pic"],
                            peerName: lists["username"],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          );
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    setState(() {
      isSearch = false;
      clearData = false;
    });
  }

  followApiCall(lists) async {
    var uri = Uri.parse('${baseUrl()}/follow_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['from_user'] = userID;
    request.fields['to_user'] = lists["id"];
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    followModal = FollowModal.fromJson(userData);
    if (followModal.responseCode == "1") {
      setState(() {
        globleFollowing.add(lists["id"]);
      });
    }
  }

  unfollowApiCall(lists) async {
    var uri = Uri.parse('${baseUrl()}/unfollow_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['from_user'] = userID;
    request.fields['to_user'] = lists["id"];
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    unfollowModal = UnfollowModal.fromJson(userData);
    if (unfollowModal.responseCode == "1") {
      setState(() {
        globleFollowing.remove(lists["id"]);
      });
    }
  }
}
