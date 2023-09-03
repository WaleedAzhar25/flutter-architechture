import 'dart:convert';
import 'dart:developer' as d;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart/view/screens/dashboard/dashboard_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../controller/splash_controller.dart';
import '../../../controller/theme_controller.dart';
import '../../../data/model/response/video_model.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import 'video_details.dart';

class VideoScreen extends StatefulWidget {
  final bool isAllVideos;
  const VideoScreen({Key key, this.isAllVideos = false}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  List<VideoData> videosList = [];

  bool loader = false;
  void getVideos() async {
    final splashController = Get.find<SplashController>();
    final moduleId = splashController.module != null
        ? splashController.module.id.toString() ?? '1'
        : '1';
    String url = '';
    if (widget.isAllVideos) {
      url = AppConstants.BASE_URL + '/admin/video/api/get_all';
    } else {
      url = AppConstants.BASE_URL + '/admin/video/api/get?module_id=$moduleId';
    }

    try {
      setState(() {
        loader = true;
      });
      http.Response _response = await http.get(Uri.parse(url));
      VideosModel videosModel =
          VideosModel.fromJson(jsonDecode(_response.body));
      videosList = videosModel.data;
      videosList.forEach((e) async {
        int index = videosList.indexOf(e);
        var videoUrl = '${AppConstants.BASE_URL}/${e.video}';
        Uint8List unint8list =
            await VideoThumbnail.thumbnailData(video: videoUrl, quality: 75);
        videosList[index].uint8List = unint8list;
        setState(() {});
      });

      log(_response.body);

      setState(() {
        loader = false;
      });
    } catch (e) {
      setState(() {
        loader = false;
      });
    }
  }

  @override
  void initState() {
    getVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => DashboardScreen(pageIndex: 2));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          centerTitle: true,
          title: Text(
            'videos'.tr,
            style: boldTextStyle(),
          ),
          elevation: 0,
        ),
        body: loader
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF5F60B9),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 4,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  childAspectRatio: (1 / 0.9),
                ),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: videosList.length,
                itemBuilder: (context, i) {
                  return videosList[i].uint8List == null
                      ? VideosShimmer()
                      : InkWell(
                          onTap: () {
                            Get.to(() => VideoDetails(videosList[i]));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL,
                                vertical: Dimensions.PADDING_SIZE_SMALL),
                            height: 130,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[
                                      Get.find<ThemeController>().darkTheme
                                          ? 800
                                          : 300],
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      height: 90,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: MemoryImage(
                                            videosList[i].uint8List,
                                          ),
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.play_arrow),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    videosList[i].name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                }),
      ),
    );
  }
}

class VideosShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          boxShadow: [
            BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)
          ]),
      child: Shimmer(
        duration: Duration(seconds: 2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 85,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimensions.RADIUS_SMALL)),
                color: Colors.grey[300]),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 10, width: 100, color: Colors.grey[300]),
                    SizedBox(height: 5),
                    Container(height: 10, width: 130, color: Colors.grey[300]),
                    SizedBox(height: 5),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
