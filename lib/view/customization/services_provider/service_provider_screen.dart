import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/model/response/blog_model.dart';
import 'package:sixam_mart/data/model/response/service_provider_model.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/view/customization/blogs/blog_details.dart';
import 'package:sixam_mart/view/customization/services_provider/service_provider_details.dart';

import '../../../controller/location_controller.dart';
import '../../../controller/theme_controller.dart';
import '../../../helper/responsive_helper.dart';

class ServiceProviderScreen extends StatefulWidget {
  int moduleId;
  int categoryId;
  ServiceProviderScreen({Key key, this.categoryId, this.moduleId})
      : super(key: key);

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  List<ServiceData> servicesList = [];
  bool loader = false;

  void getServices() async {
    int zoneid = Get.find<LocationController>().zoneID;
    String url = AppConstants.BASE_URL +
        '/admin/service-provider/api/get?module_id=${widget.moduleId}&category_id=${widget.categoryId}&zone_id=$zoneid';
    try {
      setState(() {
        loader = true;
      });
      http.Response _response = await http.get(Uri.parse(url));

      log('service provider body in sp screen : ${_response.body}');
      ServiceProviderModel service =
          ServiceProviderModel.fromJson(jsonDecode(_response.body));
      servicesList = service.data;
      setState(() {
        loader = false;
      });
    } catch (e) {
      log('error is : $e');
      setState(() {
        loader = false;
      });
    }
  }

  @override
  void initState() {
    getServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('module id : ${widget.moduleId}');
    log('category id : ${widget.moduleId}');
    // getServices();
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        centerTitle: true,
        title: Text('Services'),
        elevation: 0,
      ),
      body: loader
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : ListView.builder(
              itemCount: servicesList.length,
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_LARGE),
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.to(
                          () => ServiceProviderDetailsScreen(servicesList[i]));
                    },
                    leading: Container(
                      margin: const EdgeInsets.only(right: 40),
                      child: CircleAvatar(
                        backgroundImage: servicesList[i].serviceProviderImage !=
                                    null &&
                                servicesList[i].serviceProviderImage != ''
                            ? NetworkImage(
                                '${AppConstants.BASE_URL}/${servicesList[i].serviceProviderImage}')
                            : AssetImage(Images.placeholder),
                      ),
                    ),
                    title: Text(servicesList[i].serviceProviderName),
                    subtitle: Text(servicesList[i].serviceProviderContact),
                    trailing: Text(servicesList[i].categoryName),
                  ),
                );
              }),
    );
  }
}
