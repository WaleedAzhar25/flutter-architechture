import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/data/model/response/video_model.dart';
import 'package:video_player/video_player.dart';

import '../../../util/app_constants.dart';

import 'dart:developer' as dev;

class VideoDetails extends StatefulWidget {
  final VideoData video;

  VideoDetails(this.video);

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  bool isPlaying = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    String url = '${AppConstants.BASE_URL}/${widget.video.video}';

    _controller = VideoPlayerController.network(url)
      ..initialize().then((controller) {
        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: false,
          looping: true,
        );
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        centerTitle: true,
        title: Text('videos'.tr),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: _chewieController != null
                ? Chewie(controller: _chewieController)
                : Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF5F60B9),
                    ),
                  ),
          ),
          // Container(
          //     height: 150,
          //     child: Stack(
          //       children: [
          //         // VideoPlayer(_controller),

          //         Center(
          //           child: CircleAvatar(
          //             backgroundColor: Colors.grey,
          //             radius: 30,
          //             child: IconButton(
          //               onPressed: () {
          //                 if (isPlaying) {
          //                   isPlaying = false;
          //                   _controller.pause();
          //                 } else {
          //                   isPlaying = true;
          //                   _controller.play();
          //                 }
          //                 setState(() {});
          //               },
          //               icon: Icon(
          //                 isPlaying ? Icons.pause : Icons.play_arrow,
          //                 size: 30,
          //                 color: Colors.white,
          //               ),
          //               color: Colors.white,
          //             ),
          //           ),
          //         )
          //       ],
          //     )),

          SizedBox(height: 15),
          item('name'.tr, widget.video.name),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('description'.tr,
                    style: boldTextStyle(size: 18)
                        .copyWith(color: Color(0xFF5F60B9))),
                5.height,
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ReadMoreText(
                    widget.video.description,
                    style: secondaryTextStyle(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget item(String name, String value) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: boldTextStyle().copyWith(color: Color(0xFF5F60B9)),
          overflow: TextOverflow.ellipsis,
        ),
        Text(value ?? '')
      ],
    ),
  );
}
