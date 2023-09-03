import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import '../../global/global.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../layouts/chat/chat.dart';
import '../../layouts/user/publicProfile.dart';
import '../../models/intrest_model.dart';
import '../../models/postFollowModal.dart';
import '../../models/unFollowModal.dart';

class FilterView extends StatefulWidget {
  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
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
  String gender;
  var gender1 = [
    'Male',
    'Female',
  ];

  double startAge = 18;
  double endAge = 99;
  RangeValues _age = RangeValues(18, 99);

  bool isLoading = false;
  var userData;
  var serchedUserData;
  FollowModal followModal;
  UnfollowModal unfollowModal;

  List userList = [];
  @override
  void initState() {
    _getTopUser();
    // _getintrest();

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
    print('???????????');
    print(userData);

    setState(() {
      isSearch = false;
    });
  }

  _getserchedUser() async {
    closeKeyboard();
    setState(() {
      isSearch = true;
    });
    var uri = Uri.parse('${baseUrl()}/users_filter');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    // request.fields['interests_id'] =
    //     _categoryValue != null ? _categoryValue.toString() : '';
    request.fields['name'] = controller.text.toLowerCase();
    request.fields['country'] = countryValue != null ? countryValue : '';
    request.fields['age'] =
        '${startAge.round().toString()},${endAge.round().toString()}';
    request.fields['gender'] = gender != null ? gender : '';
    request.fields['state'] = stateValue != null ? stateValue : '';

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    serchedUserData = json.decode(responseData);
    print(serchedUserData);
    if (userData['response_code'] == '1') {}
    print(request.fields);

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
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0.5,
            title: Text(
              "Search",
              style: Theme.of(context).textTheme.headline5.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            iconTheme: IconThemeData(
              color: Theme.of(context).appBarTheme.iconTheme.color,
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                )),
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : LayoutBuilder(
                  builder: (context, constraint) {
                    return Column(
                      children: <Widget>[
                        Container(child: filterWidget(context)),
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
                      crossAxisCount: 2,
                      // childAspectRatio: 200 / 200,
                      crossAxisSpacing: 5),
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
                          crossAxisCount: 2,
                          // childAspectRatio: 200 / 200,
                          crossAxisSpacing: 5),
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
                  lists["cover_pic"] == null || lists["cover_pic"].isEmpty
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

  Widget filterWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 5),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Age:  ${startAge.round().toString()}-${endAge.round().toString()}",
                      style: TextStyle(fontSize: 12),
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                          showValueIndicator: ShowValueIndicator.always),
                      child: RangeSlider(
                        values: _age,
                        min: 18,
                        max: 99,
                        labels: RangeLabels('${_age.start.round()}' + " yrs",
                            '${_age.end.round()}' + " yrs"),
                        inactiveColor: Colors.grey,
                        activeColor: Color(0xFF0D56F2),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _age = values;
                            startAge = _age.start;
                            endAge = _age.end;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(height: 5),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 43,
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Search by Name",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                            color: Theme.of(context).shadowColor, width: 0),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      filled: true,
                      fillColor: Color(0xFFEAF1F6),
                    ),
                  ),
                ),
              ),
              Container(width: 10),
              Expanded(
                child: Container(
                  height: 43,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.transparent,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).shadowColor,
                                        width: 0),
                                  ),
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  filled: true,
                                  fillColor: Color(0xFFEAF1F6),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: gender,
                                    isDense: true,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: Text(
                                        'Gender',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                    icon: Container(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        gender = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: gender1.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(
                                          item,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13),
                                        ),
                                        value: item,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(height: 5),
          clearData == false
              ? CSCPicker(
                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                  showCities: false,
                  showStates: true,
                  dropdownItemStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.black,
                    fontSize: 13,
                  ),
                  dropdownHeadingStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  selectedItemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFEAF1F6),
                      border: Border.all(color: Colors.grey, width: 1)),
                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFFEAF1F6)
                          : Color(0xFFEAF1F6),
                      border: Border.all(color: Colors.grey, width: 1)),
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      // cityValue = value;
                    });
                  },
                )
              : Container(
                  height: 43,
                  child: Center(child: const CupertinoActivityIndicator()),
                ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 43,
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.red.shade500, Colors.red.shade900])),
                  child: const Text(
                    'Search',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ).onTap(
                  () {
                    setState(() {
                      isSearch = true;
                      isSearchData = true;
                    });

                    _getserchedUser();
                  },
                ),
              ),
              Container(width: 10),
              Expanded(
                child: Container(
                  height: 43,
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.red.shade500, Colors.red.shade900])),
                  child: const Text(
                    'Clear Filters',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ).onTap(
                  () {
                    setState(() {
                      clearData = true;
                      isSearchData = false;
                      isSearch = true;
                      _age = RangeValues(18, 99);
                      startAge = 18;
                      endAge = 99;
                      controller.clear();
                      gender = null;
                      countryValue = null;
                      stateValue = null;
                    });
                    startTime();
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 20, top: 10, bottom: 5),
            child: Container(
              height: 1,
              color: Colors.grey[400],
            ),
          )
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
