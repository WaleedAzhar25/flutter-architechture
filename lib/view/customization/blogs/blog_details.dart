import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/data/model/response/blog_model.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/customization/blogs/a.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/app_constants.dart';
import '../widget/back_widget.dart';

class BlogDetails extends StatelessWidget {
  final BlogData blog;

  BlogDetails(this.blog);

  void launchCall(String url) {
    if (url.validate().isNotEmpty) {
      if (isIOS)
        commonLaunchUrl('tel://' + url,
            launchMode: LaunchMode.externalApplication);
      else
        commonLaunchUrl('tel:' + url,
            launchMode: LaunchMode.externalApplication);
    }
  }

  Future<void> commonLaunchUrl(String address,
      {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
    await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
      toast('Invalid URL: $address');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 475,
                width: Get.width,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.blue,
                      child: CachedNetworkImage(
                        placeholder: (context, url) {
                          return AnimatedContainer(
                            height: Get.height,
                            duration: Duration(seconds: 1),
                            width: Get.width,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                            ),
                            alignment: Alignment.center,
                          );
                        },
                        imageUrl: '${AppConstants.BASE_URL}/${blog.image}',
                        fit: BoxFit.fill,
                        height: 250,
                        width: Get.width,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child:
                            BackWidget(iconColor: Theme.of(context).cardColor),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFF5F60B9)),
                      ),
                    ),
                    Positioned(
                        top: 180,
                        left: Get.width * 0.1,
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 10,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            height: 140,
                            width: Get.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                item('name'.tr, blog.name),
                                SizedBox(height: 10),
                                item('contact'.tr, blog.contact),
                                Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: InkWell(
                                        onTap: () {
                                          launchCall(blog.contact.validate());
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF5F60B9),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: InkWell(
                                        onTap: () {
                                          launchUrl(
                                              Uri.parse(
                                                  '${getSocialMediaLink(LinkProvider.WHATSAPP)}${blog.contact.validate()}'),
                                              mode: LaunchMode
                                                  .externalApplication);
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF5F60B9),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.whatsapp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                    Positioned(
                      top: 335,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('description'.tr,
                                style: boldTextStyle(size: 18)
                                    .copyWith(color: Color(0xFF5F60B9))),
                            5.height,
                            Container(
                              width: Get.width,
                              child: ReadMoreText(
                                blog.description.validate(),
                                style: secondaryTextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget item(String name, String value) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: boldTextStyle().copyWith(color: Color(0xFF5F60B9)),
          overflow: TextOverflow.ellipsis,
        ),
        Text(value)
      ],
    ),
  );
}
