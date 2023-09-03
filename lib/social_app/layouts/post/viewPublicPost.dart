import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import '../../Helper/sizeConfig.dart';
import '../../global/global.dart';
import '../../layouts/post/comments.dart';
import '../../layouts/user/profile.dart';
import '../../layouts/user/publicProfile.dart';
import '../../layouts/videoview/videoViewFix.dart';
import '../../layouts/widgets/pdf_widget.dart';

import '../../models/likeModal.dart';
import '../../models/unlikeModal.dart';
import '../../models/view_publicpost_model.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:timeago/timeago.dart';

// ignore: must_be_immutable
class ViewPublicPost extends StatefulWidget {
  String id;
  ViewPublicPost({this.id});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ViewPublicPost> {
  bool isLoading = false;

  bool tap = true;

  bool isInView = false;
  @override
  void initState() {
    print(widget.id);
    _getPost();
    super.initState();
  }

  PublicPostModel publicPost;
  UnlikeModal unlikeModal;

  LikeModal likeModal;

  _getPost() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/get_post_details');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID;
    request.fields['post_id'] = widget.id;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    publicPost = PublicPostModel.fromJson(userData);
    print(responseData);

    setState(() {
      isLoading = false;
    });
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {});
  }

  reportSheet(BuildContext context, postId, bookmark, postUserId) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                  height: postUserId != userID ? 250 : 150,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                openBottmSheet(context, 'report', postId);
                              },
                              title: new Text(
                                "Report",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");

                                _reportPost(postId, 'hide', '');
                              },
                              title: new Text(
                                "Hide",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ),
                            postUserId != userID
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("Discard");
                                      _blockUser(postUserId);
                                    },
                                    title: new Text(
                                      "Block User",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0),
                                    ),
                                  )
                                : Container(),
                            postUserId != userID
                                ? bookmark == "true"
                                    ? ListTile(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop("Discard");
                                          setState(() {
                                            bookmark = "false";
                                            _removeBookmark(postId);
                                          });
                                        },
                                        title: new Text(
                                          "Remove Post",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0),
                                        ),
                                      )
                                    : ListTile(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop("Discard");
                                          setState(() {
                                            bookmark = "true";
                                            _addBookmark(postId);
                                          });
                                        },
                                        title: new Text(
                                          "Save Post",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0),
                                        ),
                                      )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
      },
    );
  }

  TextEditingController _textFieldController = TextEditingController();
  bool stackLoader = false;
  var reportPostData;

  _reportPost(postId, status, reportTxt) async {
    print(status);
    setState(() {
      stackLoader = true;
    });

    var uri = Uri.parse('${baseUrl()}/posts_report');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['blockedByUserId'] = userID;
    request.fields['blockedPostsId'] = postId;
    request.fields['status'] = status;
    request.fields['report_text'] = reportTxt;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    reportPostData = json.decode(responseData);
    if (reportPostData['response_code'] == '1') {
      setState(() {
        stackLoader = false;
        _textFieldController.clear();
      });
      // Navigator.pop(context, true);
    } else {
      setState(() {
        stackLoader = false;
      });

      print('REPORT RESPONSE FAIL');
      debugPrint('${reportPostData['response_code']}');
    }
    openHideSheet(context, status);
    print(responseData);

    setState(() {
      stackLoader = false;
    });
  }

  openBottmSheet(BuildContext context, String reportType, String postId) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                  height: 700,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'Report',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Why are you reporting this post?',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Nudity or sexual activity');
                              },
                              title: new Text(
                                "Nudity or sexual activity",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'I just don\'t like it');
                              },
                              title: new Text(
                                "I just don\'t like it",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Hate speech or symbol');
                              },
                              title: new Text(
                                "Hate speech or symbol",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Bullying or harassment');
                              },
                              title: new Text(
                                "Bullying or harassment",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Violence or dangerous organisation');
                              },
                              title: new Text(
                                "Violence or dangerous organisation",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _displayTextInputDialog(
                                    context, postId, reportType);
                              },
                              title: new Text(
                                "Something else",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
      },
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context, id, type) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('Something else'),
            content: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    onChanged: (value) {},
                    maxLines: 5,
                    controller: _textFieldController,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter your text here")),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop("Discard");
                    print('Pressed');
                  }),
              TextButton(
                  child: Text('Submit'),
                  onPressed: () {
                    print('Pressed');
                    if (_textFieldController.text.isNotEmpty) {
                      Navigator.of(context, rootNavigator: true).pop("Discard");
                      _reportPost(id, type, _textFieldController.text);
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please enter text to continue..');
                    }
                  })
            ],
          );
        });
  }

  _blockUser(blockedUserId) async {
    print('*******');
    print(blockedUserId);
    print('*******');
    setState(() {
      stackLoader = true;
    });

    var uri = Uri.parse('${baseUrl()}/profile_block');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['blockedByUserId'] = userID;
    request.fields['blockedUserId'] = blockedUserId;

    var response = await request.send();
    print(response.statusCode);
    print(">>>>>>>>>>>>>>>>>>>>>>>>>");
    String responseData = await response.stream.transform(utf8.decoder).join();
    var reportPostData = json.decode(responseData);
    if (reportPostData['response_code'] == '1') {
      setState(() {
        stackLoader = false;
      });

      Fluttertoast.showToast(
          msg: 'User Blocked', toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(msg: 'Fail to block');
    }

    // deleteStoryModal = DeleteStoryModal.fromJson(userData);
    print(responseData);

    setState(() {
      stackLoader = false;
    });
  }

  openHideSheet(BuildContext context, String reportType) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                  height: 700,
                  child: Container(
                      child: reportPostData != null &&
                              reportPostData['response_code'] == '1'
                          ? Container(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/Done-pana.png',
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  reportType == 'hide'
                                      ? Column(
                                          children: [
                                            Text(
                                              'Post Hidden successfully',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  reportType == 'report'
                                      ? Column(
                                          children: [
                                            Text(
                                              'Thanks for letting us know',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                'Your feedback is important in helping us keep the community safe.',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(fontSize: 15)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      // background color
                                      primary: appColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      textStyle: const TextStyle(fontSize: 15),
                                    ),
                                    child: const Text('Continue'),
                                    onPressed: () {
                                      debugPrint('Button clicked!');
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("Discard");
                                      Navigator.of(context)
                                          .pushReplacementNamed('/Pages',
                                              arguments: 0);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : reportPostData != null &&
                                  reportPostData['response_code'] == '0'
                              ? Container(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/Done-pana.png',
                                        height: 300,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      reportPostData['status'] != 'fail'
                                          ? Text(
                                              'This post is already reorted',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )
                                          : Text(
                                              'Fail to submit',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Fail to submit your report please try again',
                                        textAlign: TextAlign.center,
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          // background color
                                          primary: appColor,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 10),
                                          textStyle:
                                              const TextStyle(fontSize: 15),
                                        ),
                                        child: const Text('Continue'),
                                        onPressed: () {
                                          debugPrint('Button clicked!');
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop("Discard");
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : Container())),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              iconTheme: IconThemeData(
                color: Theme.of(context).appBarTheme.iconTheme.color,
              ),
              elevation: 0.5,
              title: isLoading
                  ? Container()
                  : Text(
                      publicPost.post.username != ''
                          ? publicPost.post.username
                          : '',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                  )),
            ),
            body: isLoading
                ? Center(
                    child: loader(context),
                  )
                : SingleChildScrollView(child: postDetails(publicPost.post))),
      ),
    );
  }

  Widget postDetails(Post post) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      InkWell(
        onTap: () {
          if (userID == post.userId) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile(back: true)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PublicProfile(
                        peerId: post.userId,
                        peerUrl: post.profilePic,
                        peerName: post.username,
                      )),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: post.profilePic == null || post.profilePic.isEmpty
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
                        : CachedNetworkImage(
                            imageUrl: post.profilePic,
                            height: 50.0,
                            width: 50.0,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 2,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.username == ""
                                ? "No name"
                                : post.username.capitalize(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(post.createDate)),
                                locale: 'en_short'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 12.0,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 05),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        reportPostData = null;
                        reportSheet(
                          context,
                          post.postId,
                          post.bookmark,
                          post.userId,
                        );
                      },
                      icon: Icon(Icons.more_horiz),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      post.text != ""
          ? Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text('${post.text}'))
          : Container(),
      SizedBox(
        height: 10,
      ),
      postContentWidget(post),
      SizedBox(
        height: 10,
      ),
      footerWidget(post),
    ]);
  }

  postContentWidget(Post post) {
    bool isimage = post.allImage.length > 0;
    bool isvideo = post.video != "";
    bool ispdf = post.pdf != "";
    bool istext =
        post.pdf == "" && post.video == "" && post.allImage.length == 0;
    if (isimage) {
      return InkWell(
        onDoubleTap: () {
          if (post.isLikes == "false") {
            setState(() {
              post.dataV = true;
              post.isLikes = "true";
              post.totalLikes = post.totalLikes + 1;
              _likePost(post.postId);
            });
            var _duration = new Duration(milliseconds: 500);
            Timer(_duration, () {
              post.dataV = false;
            });
            print('dataV : ${post.dataV}');
          }
        },
        child: Stack(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 40,
              width: SizeConfig.screenWidth,
              // child: Carousel(
              //   images: post.allImage.map((it) {
              //     return ClipRRect(
              //       child: ZoomOverlay(
              //         twoTouchOnly: true,
              //         child: CachedNetworkImage(
              //           imageUrl: it,
              //           imageBuilder: (context, imageProvider) => Container(
              //             decoration: BoxDecoration(
              //               image: DecorationImage(
              //                 image: imageProvider,
              //                 // fit: BoxFit.cover,
              //               ),
              //             ),
              //           ),
              //           placeholder: (context, url) => Center(
              //             child: Container(
              //                 // height: 40,
              //                 // width: 40,
              //                 child: CircularProgressIndicator()),
              //           ),
              //           errorWidget: (context, url, error) => Icon(Icons.error),
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     );
              //   }).toList(),
              //   showIndicator: post.allImage.length > 1 ? true : false,
              //   dotBgColor: Colors.transparent,
              //   borderRadius: false,
              //   autoplay: false,
              //   dotSize: 5.0,
              //   dotSpacing: 15.0,
              // ),
            ),
            post.dataV == true
                ? Positioned.fill(
                    child: AnimatedOpacity(
                        opacity: post.dataV ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 700),
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red,
                          size: 100,
                        )))
                : Container(),
          ],
        ),
      );
    } else if (isvideo) {
      return VideoViewFix(
          url: post.video, play: true, id: post.postId, mute: false);
    } else if (ispdf) {
      return PdfWidget(
        pdf: post.pdf,
        pdfName: post.pdf_name,
        pdfSize: post.pdf_size,
      );
    } else if (istext) {
      return Container();
    }
    return Container(
        height: 230,
        width: double.infinity,
        color: Colors.grey[200],
        child: Icon(
          Icons.image,
          size: 200,
          color: Colors.grey[600],
        ));
  }

  footerWidget(Post post) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${post.totalLikes.toString()} Likes',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CommentsScreen(postID: post.postId)),
                            );
                          },
                          child: Text(
                            post.totalComments.toString() + " Comments",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5.0),
                ],
              ),
            ],
          ),
          const Divider(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  post.isLikes == "true"
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              post.isLikes = "false";
                              post.totalLikes = post.totalLikes - 1;
                              _unlikePost(post.postId);
                            });
                            print("Unlike Post");
                          },
                          child: Icon(
                            CupertinoIcons.heart_fill,
                            size: 20,
                            color: Colors.red,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            print("Like Post");
                            setState(() {
                              post.totalLikes = post.totalLikes + 1;
                              post.isLikes = "true";
                              _likePost(post.postId);
                            });
                          },
                          child: Icon(
                            CupertinoIcons.heart,
                            color: Theme.of(context).iconTheme.color,
                            size: 20,
                          ),
                        ),
                  SizedBox(
                    width: 5,
                  ),
                  CustomTextStyle1(
                    title: ' Like',
                    weight: FontWeight.w500,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  SizedBox(width: 5.0),
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CommentsScreen(postID: post.postId)),
                          ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/comment.svg",
                            height: 20,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: 5.0),
                          Text('Comment',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).iconTheme.color,
                              )),
                        ],
                      )),
                  const SizedBox(width: 5.0),
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _onShare(context, post.video, post.allImage,
                        post.text, post.pdf),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/share.svg",
                          height: 20,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(width: 5.0),
                        Text('Share',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).iconTheme.color,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5.0),
                ],
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10.0))
        ],
      ),
    );
  }

  _onShare(BuildContext context, video, image, text, pdf) async {
    bool isPhoto = image?.isNotEmpty == true;
    bool isvideo = video?.isNotEmpty == true;
    bool ispdf = pdf?.isNotEmpty == true;
    final RenderBox box = context.findRenderObject() as RenderBox;

    if (isPhoto) {
      await Share.share(image[0],
          subject: text,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else if (isvideo) {
      await Share.share(video,
          subject: text,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else if (ispdf) {
      await Share.share(pdf,
          subject: text,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  _unlikePost(String postid) async {
    var uri = Uri.parse('${baseUrl()}/unlike_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    unlikeModal = UnlikeModal.fromJson(userData);
    print(responseData);

    if (unlikeModal.responseCode == "1") {
      likedPost = [];
      setState(() {
        likedPost.add(postid);
      });
    }
  }

  _likePost(String postid) async {
    var uri = Uri.parse('${baseUrl()}/like_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    likeModal = LikeModal.fromJson(userData);
    print(responseData);

    if (likeModal.responseCode == "1") {
      likedPost = [];
      setState(() {
        likedPost.add(postid);
      });
    }
  }

  _removeBookmark(String postid) async {
    var uri = Uri.parse('${baseUrl()}/delete_bookmark_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    print(responseData);

    if (userData['response_code'] == "1") {
      addedBookmarks = [];
      setState(() {
        addedBookmarks.remove(postid);
      });
    }
  }

  _addBookmark(String postid) async {
    var uri = Uri.parse('${baseUrl()}/bookmark_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    print(responseData);

    if (userData['response_code'] == "1") {
      addedBookmarks = [];
      setState(() {
        addedBookmarks.add(postid);
      });
    }
  }
}
