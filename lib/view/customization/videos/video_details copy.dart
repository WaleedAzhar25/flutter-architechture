import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/model/response/video_model.dart';
import 'package:video_player/video_player.dart';

import '../../../util/app_constants.dart';

class VideoDetails extends StatefulWidget {
  final VideoData video;

  VideoDetails(this.video);

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        '${AppConstants.BASE_URL}/${widget.video.video}')
      ..initialize().then((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        centerTitle: true,
        title: Text('Videos'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
              height: 150,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  Center(
                    child: IconButton(
                      onPressed: () {
                        if (isPlaying) {
                          isPlaying = false;
                          _controller.pause();
                        } else {
                          isPlaying = true;
                          _controller.play();
                        }
                        setState(() {});
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 30,
                        color: Colors.white,
                      ),
                      color: Colors.white,
                    ),
                  )
                ],
              )),
          SizedBox(height: 15),
          item('Name :', widget.video.name),
          SizedBox(height: 10),
          item('Description :', widget.video.description),
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(value)
      ],
    ),
  );
}
