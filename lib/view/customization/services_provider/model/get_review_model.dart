class GetReviewModel {
  List<ReviewData> data;

  GetReviewModel({this.data});

  GetReviewModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ReviewData>[];
      json['data'].forEach((v) {
        data.add(new ReviewData.fromJson(v));
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

class ReviewData {
  int id;
  String serviceProviderId;
  String uId;
  String uName;
  String uImage;
  String comment;
  String reviews;
  String createdAt;
  String updatedAt;

  ReviewData(
      {this.id,
      this.serviceProviderId,
      this.uId,
      this.uName,
      this.uImage,
      this.comment,
      this.reviews,
      this.createdAt,
      this.updatedAt});

  ReviewData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceProviderId = json['service_provider_id'];
    uId = json['u_id'];
    uName = json['u_name'];
    uImage = json['u_image'];
    comment = json['comment'];
    reviews = json['reviews'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_provider_id'] = this.serviceProviderId;
    data['u_id'] = this.uId;
    data['u_name'] = this.uName;
    data['u_image'] = this.uImage;
    data['comment'] = this.comment;
    data['reviews'] = this.reviews;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
