// ignore_for_file: implementation_imports, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../global/global.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/photofilters.dart';
import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as imageLib;
import '../../../layouts/post/add_post/upload_pdf.dart';
import '../../../layouts/post/add_post/addvideoPost.dart';
import '../../../layouts/post/add_post/upload_photo_screen.dart';
import '../../../layouts/post/add_post/create_post.dart';
import '../../../models/userdata_model.dart';
import 'package:video_compress/video_compress.dart';

import 'package:video_player/video_player.dart';

class PostBox extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final String userimage;
  final String userName;
  PostBox({
    Key key,
    this.parentScaffoldKey,
    this.userimage,
    this.userName,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyHomePageState extends State<PostBox> {
  AppState state;
  File imageFile;
  File pdffile;

  bool selectPhoto = false;

  bool selectVideo = false;
  bool isLoading = false;
  File _video;
  //File _cameraVideo;

  VideoPlayerController _videoPlayerController;
  // ignore: unused_field
  VideoPlayerController _cameraVideoPlayerController;

  List<File> alldata = [];

  UserDataModel modal;

  var savedimageUrls = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _getRequests();
    super.initState();
    state = AppState.free;
  }

  _getRequests() async {
    _getUser();
  }

  _getUser() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/user_data');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    modal = UserDataModel.fromJson(userData);
    print(responseData);
    if (modal.responseCode == "1") {
      userfullname = modal.user.fullname;

      userGender = modal.user.gender;
      userPhone = modal.user.phone;
      userEmail = modal.user.email;
      userName = modal.user.username;
      userImage = modal.user.profilePic;
      userCoverImage = modal.user.coverPic;
      userBio = modal.user.bio;
      intrestarray = modal.user.interestsId;
      if (userImage != '') print(userImage);
    }
    // _getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.0),
      elevation: 0.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: userImage == null || userImage.isEmpty
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
                          imageUrl: userImage,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    child: IgnorePointer(
                      child: TextField(
                          decoration: InputDecoration(
                              hintText: 'What\'s on your mind?',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 25),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1.0),
                              ),
                              filled: false)),
                    ),
                  ).onTap(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhotoScreen(
                                  userName: widget.userName,
                                  userimage: widget.userimage,
                                )));
                  }),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
            const Divider(height: 10.0, thickness: 0.5),
            SizedBox(
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => selectImageSource(),
                    icon: Image.asset(
                      "assets/images/photo_add.png",
                      width: 20,
                    ),
                    label: Text(
                      'Photo',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                  const VerticalDivider(width: 8.0),
                  TextButton.icon(
                    onPressed: () {
                      selectVideoSource();
                    },
                    icon: Image.asset(
                      "assets/images/video_add.png",
                      width: 20,
                    ),
                    label: Text(
                      'Video',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                  const VerticalDivider(width: 8.0),
                  TextButton.icon(
                    onPressed: () => selectPDFFile(),
                    icon: Image.asset(
                      "assets/images/pdf_add.png",
                      width: 20,
                    ),
                    label: Text(
                      'PDF',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future selectPDFFile() async {
    final navigator = Navigator.of(context);
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;
    final path = result.files.single.path;

    String fileName = result.files.first.name;

    setState(() async {
      pdffile = File(path);
      if (result != null) {
        pdffile = File(path);
        int size = pdffile.lengthSync();
        String pdfsize = "$size";
        double sizeInMb = size / (1024 * 1024);
        if (sizeInMb > 5) {
          socialootoast("", "File Size is larger then 5mb", context);
          return;
        }
        await navigator.push(MaterialPageRoute(
            builder: (context) => UploadPdfScreen(
                  userName: widget.userName,
                  userimage: widget.userimage,
                  file: pdffile,
                  pdfpath: path,
                  pdfname: fileName,
                  pdfsize: pdfsize,
                )));
      } else {
        // print('No image selected.');
      }
    });
  }

  Future pickImageFromGallery() async {
    // ignore: deprecated_member_use
    final imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  // ignore: unused_element
  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: appColor,
            toolbarWidgetColor: Colors.white,
            statusBarColor: appColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: '',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  // ignore: unused_element
  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  _pickVideo() async {
    var video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      indicatorDialog(context);
      await VideoCompress.setLogLevel(0);

      final compressedVideo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedVideo != null) {
        Navigator.pop(context);

        setState(() {
          _video = File(compressedVideo.path);
        });
        _videoPlayerController =
            VideoPlayerController.file(File(compressedVideo.path))
              ..initialize().then((_) {
                setState(() {
                  _videoPlayerController.play();
                });
              });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadVideoScreen(
              video: _video,
              userName: widget.userName,
              userimage: widget.userimage,
            ),
          ),
        );
      } else {
        debugPrint('error in compressing video from gallery');
      }
    }
  }

  _pickVideoFromCamera() async {
    var video = await ImagePicker().pickVideo(source: ImageSource.camera);

    if (video != null) {
      indicatorDialog(context);
      await VideoCompress.setLogLevel(0);

      final compressedVideo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedVideo != null) {
        Navigator.pop(context);
        setState(() {
          _video = File(compressedVideo.path);
        });

        _videoPlayerController =
            VideoPlayerController.file(File(compressedVideo.path))
              ..initialize().then((_) {
                setState(() {
                  _videoPlayerController.play();
                });
              });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadVideoScreen(
              video: _video,
              userName: widget.userName,
              userimage: widget.userimage,
            ),
          ),
        );
      } else {
        debugPrint('error in compressing video from camera');
      }
    }
  }

  selectVideoSource() {
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
                  height: 250,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'Pick Video',
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
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                _pickVideoFromCamera();
                              },
                              leading: Icon(
                                Icons.camera,
                                size: 20,
                              ),
                              title: new Text(
                                "Camera",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                _pickVideo();
                              },
                              leading: Icon(
                                Icons.image,
                                size: 20,
                              ),
                              title: new Text(
                                "Gallery",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
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

  selectImageSource() {
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
                  height: 250,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'Pick Image',
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
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                pickImageFromCamera();
                              },
                              leading: Icon(
                                Icons.camera,
                                size: 20,
                              ),
                              title: new Text(
                                "Camera",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                ChooseFromGallery();
                              },
                              leading: Icon(
                                Icons.image,
                                size: 20,
                              ),
                              title: new Text(
                                "Gallery",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
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

  Future pickImageFromCamera() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      indicatorDialog(context);
      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

      await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 30,
      ).then((value) async {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadPhotoScreen(
              userName: userName,
              userimage: userImage,
              image: alldata,
            ),
          ),
        );
      });
    }
  }

  Future ChooseFromGallery() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      indicatorDialog(context);
      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

      await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 40,
      ).then((value) async {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadPhotoScreen(
              userName: userName,
              userimage: userImage,
              image: alldata,
            ),
          ),
        );
        setState(() {
          imageFile = value;
          alldata.add(imageFile);
          state = AppState.picked;
        });
      });
    }
  }

  List<Filter> filters = presetFiltersList;
  String fileName;

  Future pickImage(context, image2) async {
    fileName = path.basename(image2.path);
    var image = imageLib.decodeImage(image2.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => Container(
          child: new PhotoFilterSelector(
            title: Text(
              "Photo Customization",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins-Medium",
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            image: image,
            filters: presetFiltersList,
            filename: fileName,
            loader: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.grey[400]))),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        isLoading = false;

        var finalimage = imagefile['image_filtered'];
        alldata.add(finalimage);
        alldata.remove(image2);
      });
      print(image2.path);
    }
  }
}
