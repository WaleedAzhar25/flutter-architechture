class ServiceReviewModel {
  List<Reviews> data;

  ServiceReviewModel({this.data});

  ServiceReviewModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Reviews>[];
      json['data'].forEach((v) {
        data.add(new Reviews.fromJson(v));
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

class Reviews {
  int id;
  int serviceProviderId;
  int uId;
  String uName;
  String uImage;
  int reviews;
  String createdAt;
  String updatedAt;

  Reviews(
      {this.id,
      this.serviceProviderId,
      this.uId,
      this.uName,
      this.uImage,
      this.reviews,
      this.createdAt,
      this.updatedAt});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceProviderId = json['service_provider_id'];
    uId = json['u_id'];
    uName = json['u_name'];
    uImage = json['u_image'];
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
    data['reviews'] = this.reviews;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
