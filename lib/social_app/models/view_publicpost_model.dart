// ignore_for_file: non_constant_identifier_names

class PublicPostModel {
  String responseCode;
  String message;
  Post post;
  Comment comment;
  String status;

  PublicPostModel(
      {this.responseCode, this.message, this.post, this.comment, this.status});

  PublicPostModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
    comment =
        json['comment'] != null ? new Comment.fromJson(json['comment']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    if (this.comment != null) {
      data['comment'] = this.comment.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Post {
  String postId;
  String userId;
  String text;
  String pdf;
  String pdf_name;
  String pdf_size;
  String video;
  String location;
  String createDate;
  List<String> allImage;
  String username;
  String profilePic;
  int totalLikes;
  int totalComments;
  String isLikes;
  String bookmark;
  bool dataV = false;

  Post(
      {this.postId,
      this.userId,
      this.text,
      this.pdf,
      this.pdf_name,
      this.pdf_size,
      this.video,
      this.location,
      this.createDate,
      this.allImage,
      this.username,
      this.profilePic,
      this.totalLikes,
      this.totalComments,
      this.isLikes,
      this.bookmark,
      this.dataV});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    text = json['text'];
    pdf = json['pdf'];
    video = json['video'];
    pdf_name = json['pdf_name'];
    pdf_size = json['pdf_size'];
    location = json['location'];
    createDate = json['create_date'];
    allImage = json['all_image'].cast<String>();
    username = json['username'];
    profilePic = json['profile_pic'];
    totalLikes = json['total_likes'];
    totalComments = json['total_comments'];
    isLikes = json['is_likes'];
    bookmark = json['bookmark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['text'] = this.text;
    data['pdf'] = this.pdf;
    data['pdf_name'] = this.pdf_name;
    data['pdf_size'] = this.pdf_size;
    data['video'] = this.video;
    data['location'] = this.location;
    data['create_date'] = this.createDate;
    data['all_image'] = this.allImage;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    data['total_likes'] = this.totalLikes;
    data['total_comments'] = this.totalComments;
    data['is_likes'] = this.isLikes;
    data['bookmark'] = this.bookmark;
    return data;
  }
}

class Comment {
  String commentId;
  String postId;
  String userId;
  String text;
  String date;
  String username;
  String profilePic;

  Comment(
      {this.commentId,
      this.postId,
      this.userId,
      this.text,
      this.date,
      this.username,
      this.profilePic});

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    postId = json['post_id'];
    userId = json['user_id'];
    text = json['text'];
    date = json['date'];
    username = json['username'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['text'] = this.text;
    data['date'] = this.date;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
