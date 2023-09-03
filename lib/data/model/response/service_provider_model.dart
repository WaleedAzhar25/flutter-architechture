class ServiceProviderModel {
  List<ServiceData> data;

  ServiceProviderModel({this.data});

  ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ServiceData>[];
      json['data'].forEach((v) {
        data.add(new ServiceData.fromJson(v));
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

class ServiceData {
  int serviceProviderId;
  String serviceProviderName;
  String serviceProviderContact;
  String serviceProviderImage;
  String latitude;
  String longitude;
  String description;
  String createdAt;
  String updatedAt;
  String moduleName;
  String categoryName;

  ServiceData(
      {this.serviceProviderId,
      this.serviceProviderName,
      this.serviceProviderContact,
      this.serviceProviderImage,
      this.latitude,
      this.longitude,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.moduleName,
      this.categoryName});

  ServiceData.fromJson(Map<String, dynamic> json) {
    serviceProviderId = json['service_provider_id'];
    serviceProviderName = json['service_provider_name'];
    serviceProviderContact = json['service_provider_contact'];
    serviceProviderImage = json['service_provider_image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    moduleName = json['module_name'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_provider_id'] = this.serviceProviderId;
    data['service_provider_name'] = this.serviceProviderName;
    data['service_provider_contact'] = this.serviceProviderContact;
    data['service_provider_image'] = this.serviceProviderImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['module_name'] = this.moduleName;
    data['category_name'] = this.categoryName;
    return data;
  }
}
