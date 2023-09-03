import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/data/model/response/video_model.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart/util/colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/customization/videos/video_details.dart';
import 'package:sixam_mart/view/customization/videos/videos_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../controller/theme_controller.dart';
import '../../base/title_widget.dart';

class VideoWidget extends StatefulWidget {
  final String modeulId;
  final bool isAllVideos;
  VideoWidget(this.modeulId, {Key key, this.isAllVideos = false})
      : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  List<VideoData> videosList = [];

  bool loader = false;
  void getVideos() async {
    String url = '';
    if (widget.isAllVideos) {
      url = AppConstants.BASE_URL + '/admin/video/api/get_all';
    } else {
      url = AppConstants.BASE_URL +
          '/admin/video/api/get?module_id=${widget.modeulId}';
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

      // log(_response.body);

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
    final videoHeight = 180.0;
    return loader
        ? VideoShimmer()
        : videosList.isEmpty
            ? SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                    child: TitleWidget(
                      title: 'videos'.tr,
                      onTap: () => Get.to(
                          () => VideoScreen(isAllVideos: widget.isAllVideos)),
                    ),
                  ),
                  Container(
                    height: videoHeight,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: videosList.length,
                        itemBuilder: (context, index) {
                          // var videoUrl =
                          //     '${AppConstants.BASE_URL}/${videosList[index].video}';
                          // log('video url : ${AppConstants.BASE_URL}/${videosList[index].video}');
                          // _controller = VideoPlayerController.network(
                          //     '${AppConstants.BASE_URL}/${videosList[index].video}')
                          //   ..initialize().then((_) {
                          //     log('video has been initialized');
                          //     // setState(() {});
                          //   }).catchError((e) {
                          //     log('error occurred in initializing video $e');
                          //   });

                          return videosList[index].uint8List == null
                              ? VideoShimmer()
                              : Container(
                                  margin:
                                      EdgeInsets.only(left: index == 0 ? 5 : 0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() =>
                                          VideoDetails(videosList[index]));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      height: videoHeight,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        color: ColorResources.blue1,
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[
                                                Get.find<ThemeController>()
                                                        .darkTheme
                                                    ? 800
                                                    : 300],
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                height: videoHeight,
                                                decoration: BoxDecoration(
                                                  color: ColorResources.blue1,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors
                                                          .grey[Get.find<
                                                                  ThemeController>()
                                                              .darkTheme
                                                          ? 800
                                                          : 300],
                                                      blurRadius: 5,
                                                      spreadRadius: 1,
                                                    )
                                                  ],
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: MemoryImage(
                                                      videosList[index]
                                                          .uint8List,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    ColorResources.blue1,
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 5,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  width: 150,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    videosList[index].name,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        }),
                  ),
                ],
              );
  }
}

class VideoShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            height: 150,
            width: 200,
            margin: EdgeInsets.only(
                right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)
                ]),
            child: Shimmer(
              duration: Duration(seconds: 2),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        padding:
                            EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 10,
                                  width: 100,
                                  color: Colors.grey[300]),
                              SizedBox(height: 5),
                              Container(
                                  height: 10,
                                  width: 130,
                                  color: Colors.grey[300]),
                              SizedBox(height: 5),
                            ]),
                      ),
                    ),
                  ]),
            ),
          );
        },
      ),
    );
  }
}
