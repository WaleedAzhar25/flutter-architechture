class PostReviewModel {
  int serviceProviderId;
  int userId;
  String userName;
  String userImage;
  int reviews;
  String comment;

  PostReviewModel(
      {this.serviceProviderId,
      this.userId,
      this.userName,
      this.userImage,
      this.reviews,
      this.comment});

  PostReviewModel.fromJson(Map<String, dynamic> json) {
    serviceProviderId = json['service_provider_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    reviews = json['reviews'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_provider_id'] = this.serviceProviderId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['reviews'] = this.reviews;
    data['comment'] = this.comment;
    return data;
  }
}
