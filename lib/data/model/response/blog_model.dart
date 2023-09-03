class BlogModel {
  List<BlogData> data;

  BlogModel({this.data});

  BlogModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BlogData>[];
      json['data'].forEach((v) {
        data.add(new BlogData.fromJson(v));
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

class BlogData {
  int blogId;
  String name;
  String image;
  String contact;
  String description;
  String status;
  String createdAt;
  String updatedAt;

  BlogData(
      {this.blogId,
      this.name,
      this.image,
      this.contact,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt});

  BlogData.fromJson(Map<String, dynamic> json) {
    blogId = json['blog_id'];
    name = json['name'];
    image = json['image'];
    contact = json['contact'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blog_id'] = this.blogId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['contact'] = this.contact;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
