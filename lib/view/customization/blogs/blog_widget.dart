import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/data/model/response/blog_model.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/customization/blogs/Blogs_screen.dart';
import 'package:sixam_mart/view/customization/blogs/blog_details.dart';

import '../../../util/colors.dart';
import '../../base/custom_image.dart';
import '../../base/title_widget.dart';

class BlogWidget extends StatefulWidget {
  String moduleId;
  final bool isAllBlogs;

  BlogWidget(this.moduleId, {Key key, this.isAllBlogs = false})
      : super(key: key);

  @override
  State<BlogWidget> createState() => _BlogWidgetState();
}

class _BlogWidgetState extends State<BlogWidget> {
  List<BlogData> blogsList = [];
  bool loader = false;
  void getBlogs() async {
    log('module id is : ${widget.moduleId}');

    String url = '';
    if (widget.isAllBlogs) {
      url = AppConstants.BASE_URL + '/admin/blog/api/get_all';
    } else {
      url = AppConstants.BASE_URL +
          '/admin/blog/api/get?module_id=${widget.moduleId}';
    }
    try {
      setState(() {
        loader = true;
      });
      http.Response _response = await http.get(Uri.parse(url));
      // log('response body blogs : ${_response.body}');
      BlogModel blog = BlogModel.fromJson(jsonDecode(_response.body));
      blogsList = blog.data;
      // log(_response.body);
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
    // getBlogs();
    return loader
        ? BlogsShimmer()
        : blogsList.isEmpty
            ? SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                    child: TitleWidget(
                      title: 'Blogs',
                      onTap: () => Get.to(() => BlogScreen()),
                    ),
                  ),
                  Container(
                    height: 200,
                    margin:
                        EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: blogsList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => BlogDetails(blogsList[index]));
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: index == 0 ? 10 : 0),
                              padding: EdgeInsets.only(
                                  right: Dimensions.PADDING_SIZE_SMALL,
                                  bottom: 5),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColorResources.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 20,
                                      color: ColorResources.blue1
                                          .withOpacity(0.05),
                                      spreadRadius: 0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 160,
                                      height: 140,
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: ColorResources.white6,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        child: CustomImage(
                                          image:
                                              '${AppConstants.BASE_URL}/${blogsList[index].image}',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        blogsList[index].name,
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
                ],
              );
  }
}

class BlogsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            height: 150,
            width: 200,
            margin: EdgeInsets.only(
                right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)
                ]),
            child: Shimmer(
              duration: Duration(seconds: 2),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 85,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Dimensions.RADIUS_SMALL)),
                          color: Colors.grey[300]),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 10,
                                  width: 100,
                                  color: Colors.grey[300]),
                              SizedBox(height: 5),
                              Container(
                                  height: 10,
                                  width: 130,
                                  color: Colors.grey[300]),
                              SizedBox(height: 5),
                            ]),
                      ),
                    ),
                  ]),
            ),
          );
        },
      ),
    );
  }
}
