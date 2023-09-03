import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/blog_model.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/customization/blogs/blog_details.dart';
import 'package:sixam_mart/view/screens/dashboard/dashboard_screen.dart';

import '../../../controller/theme_controller.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/colors.dart';

class BlogScreen extends StatefulWidget {
  final bool isAllBlogs;
  const BlogScreen({Key key, this.isAllBlogs = false}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<BlogData> blogsList = [];
  bool loader = false;

  void getBlogs() async {
    final splashController = Get.find<SplashController>();
    final moduleId = splashController.module != null
        ? splashController.module.id.toString() ?? '1'
        : '1';
    log('module id is : $moduleId');
    String url = '';
    if (widget.isAllBlogs) {
      url = AppConstants.BASE_URL + '/admin/blog/api/get_all';
    } else {
      url = AppConstants.BASE_URL + '/admin/blog/api/get?module_id=$moduleId';
    }
    // AppConstants.BASE_URL + '/admin/blog/api/get?module_id=4';
    // url = AppConstants.BASE_URL + '/admin/blog/api/get_all';

    try {
      setState(() {
        loader = true;
      });
      http.Response _response = await http.get(Uri.parse(url));
      BlogModel blog = BlogModel.fromJson(jsonDecode(_response.body));
      blogsList = blog.data;
      log(_response.body);
      setState(() {
        loader = false;
      });
    } catch (e) {
      setState(() {
        loader = false;
      });
    }
  }

  @override
  void initState() {
    getBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => DashboardScreen(pageIndex: 2));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          centerTitle: true,
          title: Text('blogs'.tr, style: boldTextStyle()),
          elevation: 0,
        ),
        body: loader
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF5F60B9),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 4,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.95,
                ),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: blogsList.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      Get.to(() => BlogDetails(blogsList[i]));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                          vertical: Dimensions.PADDING_SIZE_SMALL),
                      height: 130,
                      width: 150,
                      decoration: BoxDecoration(
                        color: ColorResources.white6,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorResources.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              color: ColorResources.blue1.withOpacity(0.05),
                              spreadRadius: 0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 90,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: ColorResources.white6,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      '${AppConstants.BASE_URL}/${blogsList[i].image}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                blogsList[i].name,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
