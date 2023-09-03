import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/view/customization/services_provider/model/post_review_model.dart';
import 'package:sixam_mart/view/customization/services_provider/services_map_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../../controller/auth_controller.dart';
import '../../../data/model/response/service_provider_model.dart';
import '../../../data/repository/location_repo.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../base/my_text_field.dart';
import '../../base/not_logged_in_screen.dart';
import '../../base/rating_bar.dart';
import '../widget/back_widget.dart';
import 'model/get_review_model.dart';

class ServiceProviderDetailsScreen extends StatefulWidget {
  final ServiceData service;
  final List<ReviewData> reviewDataList;

  ServiceProviderDetailsScreen(this.service, {this.reviewDataList});

  @override
  State<ServiceProviderDetailsScreen> createState() =>
      _ServiceProviderDetailsScreenState();
}

class _ServiceProviderDetailsScreenState
    extends State<ServiceProviderDetailsScreen> {
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

  int totalReviews = 0;
  int reviews = 0;
  bool isServiceReviewed = false;

  void checkReview() {
    widget.reviewDataList.forEach((e) {
      totalReviews += int.parse(e.reviews);
      if (e.uId == userController.userInfoModel.id.toString()) {
        isServiceReviewed = true;
      }
    });
    if (totalReviews > 0.0) {
      reviews = (totalReviews / widget.reviewDataList.length).truncate();
    }
  }

  bool loader = false;
  void postReview(Map<String, String> body) async {
    String url = AppConstants.BASE_URL + '/admin/review/api';
    try {
      setState(() {
        loader = true;
      });
      http.Response _response = await http.post(
        Uri.parse(url),
        body: body,
      );
      if (_response.statusCode == 200) {
        Get.snackbar('success', 'Review inserted',
            snackPosition: SnackPosition.BOTTOM);
      }
      log('post review response : ${_response.body}');

      setState(() {
        loader = false;
      });
    } catch (e) {
      log('error is : ${e.toString()}');
      setState(() {
        loader = false;
      });
    }
  }

  int rating = 0;
  final commentController = TextEditingController();
  bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
  final userController = Get.find<UserController>();
  final locationController = Get.find<UserController>();

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    // print('lat lng is : ${latLng.toJson()}');
    Response response = await LocationRepo().getAddressFromGeocode(latLng);
    String _address = 'Unknown Location Found';
    if (response.statusCode == 200 && response.body['status'] == 'OK') {
      _address = response.body['results'][0]['formatted_address'].toString();
    } else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return _address;
  }

  String address = '';
  // @override
  // void initState() {
  //   if (widget.service.latitude != null && widget.service.longitude != null) {
  //     getAddressFromGeocode(LatLng(double.parse(widget.service.latitude),
  //             double.parse(widget.service.longitude)))
  //         .then((addrs) {
  //       setState(() {
  //         address = addrs;
  //       });
  //     });
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    bool _desktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // color: Colors.green,
                height: 380,
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
                        imageUrl:
                            '${AppConstants.BASE_URL}/${widget.service.serviceProviderImage}',
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
                        left: Get.width * 0.07,
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 10,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            // height: 200,
                            height: 170,
                            width: Get.width * 0.85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                item('${'name'.tr} :',
                                    widget.service.serviceProviderName),
                                SizedBox(height: 10),
                                item('${'contact'.tr} :',
                                    widget.service.serviceProviderContact),
                                SizedBox(height: 10),
                                // item('${'location'.tr} :', address),
                                // SizedBox(height: 10),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'review'.tr} :',
                                        style: boldTextStyle()
                                            .copyWith(color: Color(0xFF5F60B9)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      RatingBar(
                                        rating: reviews.toDouble(),
                                        size: _desktop ? 15 : 12,
                                        ratingCount:
                                            widget.reviewDataList.length,
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: InkWell(
                                        onTap: () {
                                          launchCall(widget
                                              .service.serviceProviderContact
                                              .validate());
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
                                      padding: const EdgeInsets.only(left: 15),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => ServicesMapScreen(
                                              address: AddressModel(
                                                latitude:
                                                    widget.service.latitude,
                                                longitude:
                                                    widget.service.longitude,
                                              ),
                                              fromStore: true,
                                            ),
                                          );
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
                                            Icons.location_on_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: InkWell(
                                        onTap: () {
                                          launchUrl(
                                              Uri.parse(
                                                  '${getSocialMediaLink(LinkProvider.WHATSAPP)}${widget.service.serviceProviderContact.validate()}'),
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
                    // Positioned(
                    //   top: 335,
                    //   left: Get.width * 0.1,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 15),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text('Description',
                    //             style: boldTextStyle(size: 18)
                    //                 .copyWith(color: Color(0xFF5F60B9))),
                    //         5.height,
                    //         Container(
                    //           width: Get.width,
                    //           child: ReadMoreText(
                    //             widget.service.description.validate(),
                    //             style: secondaryTextStyle(),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
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
                        widget.service.description.validate(),
                        style: secondaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                'rate_the_item'.tr,
                style: robotoMedium.copyWith(
                    color: Theme.of(context).disabledColor),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return InkWell(
                      child: Icon(
                        rating < (i + 1) ? Icons.star_border : Icons.star,
                        size: 25,
                        color: rating < (i + 1)
                            ? Theme.of(context).disabledColor
                            : Colors.yellow,
                      ),
                      onTap: () {
                        setState(() {
                          rating = i + 1;
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Text(
                'share_your_opinion'.tr,
                style: robotoMedium.copyWith(
                    color: Theme.of(context).disabledColor),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              MyTextField(
                controller: commentController,
                maxLines: 3,
                capitalization: TextCapitalization.sentences,
                isEnabled: true,
                hintText: 'write_your_review_here'.tr,
                fillColor: Theme.of(context).disabledColor.withOpacity(0.05),
                // onChanged: (text) => itemController.setReview(index, text),
              ),
              SizedBox(height: 20),

              // Submit button
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_LARGE),
                  child:
                      // !itemController.loadingList[index]
                      //     ?
                      CustomButton(
                    buttonText: 'submit'.tr,
                    onPressed: isServiceReviewed
                        ? null
                        : () {
                            if (!_isLoggedIn) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotLoggedInScreen()));
                            } else {
                              final model = userController.userInfoModel;
                              Map<String, String> data = PostReviewModel(
                                comment: commentController.text,
                                reviews: rating,
                                serviceProviderId:
                                    widget.service.serviceProviderId,
                                userId: model.id,
                                userImage: model.image,
                                userName: model.fName + model.lName,
                              ).toJson();
                              postReview(data);
                            }
                          },
                  )),
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
        Text(value ?? '')
      ],
    ),
  );
}
