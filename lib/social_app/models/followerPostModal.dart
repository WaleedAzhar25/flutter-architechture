// ignore_for_file: non_constant_identifier_names

class FollowerPostModal {
  String responseCode;
  String message;
  List<Post> post;
  String status;

  FollowerPostModal({this.responseCode, this.message, this.post, this.status});

  FollowerPostModal.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['post'] != null) {
      // ignore: deprecated_member_use
      post = <Post>[];
      json['post'].forEach((v) {
        post.add(new Post.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.post != null) {
      data['post'] = this.post.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Post {
  String postId;
  String userId;
  String text;
  List<String> image;
  String video;
  String pdf;
  String pdf_name;
  String pdf_size;
  String location;
  String createDate;
  String fromUser;
  String toUser;
  List<String> allImage;
  String username;
  String profilePic;
  int totalLikes;
  int totalComments;
  String isLikes;
  String bookmark;
  Comment comment;
  bool dataV;
  String postReport;
  String profileBlock;

  Post(
      {this.postId,
      this.userId,
      this.text,
      this.image,
      this.video,
      this.pdf,
      this.pdf_name,
      this.pdf_size,
      this.location,
      this.createDate,
      this.fromUser,
      this.toUser,
      this.allImage,
      this.username,
      this.profilePic,
      this.totalLikes,
      this.totalComments,
      this.isLikes,
      this.bookmark,
      this.comment,
      this.dataV,
      this.postReport,
      this.profileBlock});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    text = json['text'];
    image = json['image'].cast<String>();
    video = json['video'];
    pdf = json['pdf'];
    pdf_name = json['pdf_name'];
    pdf_size = json['pdf_size'];
    location = json['location'];
    createDate = json['create_date'];
    fromUser = json['from_user'];
    toUser = json['to_user'];
    allImage = json['all_image'].cast<String>();
    username = json['username'];
    profilePic = json['profile_pic'];
    totalLikes = json['total_likes'];
    totalComments = json['total_comments'];
    isLikes = json['is_likes'];
    bookmark = json['bookmark'];
    comment =
        json['comment'] != null ? new Comment.fromJson(json['comment']) : null;
    postReport = json['posts_report'];
    profileBlock = json['profile_block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['text'] = this.text;
    data['image'] = this.image;
    data['video'] = this.video;
    data['pdf'] = this.pdf;
    data['pdf_name'] = this.pdf_name;
    data['pdf_size'] = this.pdf_size;
    data['location'] = this.location;
    data['create_date'] = this.createDate;
    data['from_user'] = this.fromUser;
    data['to_user'] = this.toUser;
    data['all_image'] = this.allImage;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    data['total_likes'] = this.totalLikes;
    data['total_comments'] = this.totalComments;
    data['is_likes'] = this.isLikes;
    data['bookmark'] = this.bookmark;
    if (this.comment != null) {
      data['comment'] = this.comment.toJson();
    }
    data['posts_report'] = this.postReport;
    data['profile_block'] = this.profileBlock;
    return data;
  }
}

class Comment {
  String commentId;
  String postId;
  String userId;
  String text;
  String date;
  String fullname;
  String username;
  String profilePic;

  Comment(
      {this.commentId,
      this.postId,
      this.userId,
      this.text,
      this.date,
      this.fullname,
      this.username,
      this.profilePic});

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    postId = json['post_id'];
    userId = json['user_id'];
    text = json['text'];
    date = json['date'];
    fullname = json['fullname'];
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
    data['fullname'] = this.fullname;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
