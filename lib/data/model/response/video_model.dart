import 'dart:typed_data';

class VideosModel {
  List<VideoData> data;

  VideosModel({this.data});

  VideosModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VideoData>[];
      json['data'].forEach((v) {
        data.add(new VideoData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoData {
  int videoId;
  String name;
  String video;
  String description;
  String status;
  String createdAt;
  String updatedAt;
  Uint8List uint8List;

  VideoData({
    this.videoId,
    this.name,
    this.video,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.uint8List,
  });

  VideoData.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    name = json['name'];
    video = json['video'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_id'] = this.videoId;
    data['name'] = this.name;
    data['video'] = this.video;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
