import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/module_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/base/title_widget.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../theme/light_theme.dart';
import '../../../../util/colors.dart';

class PopularStoreView extends StatelessWidget {
  final bool isPopular;
  final bool isFeatured;
  PopularStoreView({@required this.isPopular, @required this.isFeatured});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      List<Store> _storeList = isFeatured
          ? storeController.featuredStoreList
          : isPopular
              ? storeController.popularStoreList
              : storeController.latestStoreList;

      return (_storeList != null && _storeList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, isPopular ? 2 : 15, 10, 10),
                  child: TitleWidget(
                    title: isFeatured
                        ? 'featured_stores'.tr
                        : isPopular
                            ? Get.find<SplashController>()
                                    .configModel
                                    .moduleConfig
                                    .module
                                    .showRestaurantText
                                ? 'popular_restaurants'.tr
                                : 'popular_stores'.tr
                            : '${'new_on'.tr} ${AppConstants.APP_NAME}',
                    onTap: () =>
                        Get.toNamed(RouteHelper.getAllStoreRoute(isFeatured
                            ? 'featured'
                            : isPopular
                                ? 'popular'
                                : 'latest')),
                  ),
                ),
                SizedBox(
                  height: 265,
                  child: _storeList != null
                      ? ListView.builder(
                          controller: ScrollController(),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              left: Dimensions.PADDING_SIZE_SMALL),
                          itemCount:
                              _storeList.length > 10 ? 10 : _storeList.length,
                          itemBuilder: (context, index) {
                            return Padding(
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
                                child: InkWell(
                                  onTap: () {
                                    if (isFeatured &&
                                        Get.find<SplashController>()
                                                .moduleList !=
                                            null) {
                                      for (ModuleModel module
                                          in Get.find<SplashController>()
                                              .moduleList) {
                                        if (module.id ==
                                            _storeList[index].moduleId) {
                                          Get.find<SplashController>()
                                              .setModule(module);
                                          break;
                                        }
                                      }
                                    }
                                    Get.toNamed(
                                      RouteHelper.getStoreRoute(
                                          _storeList[index].id,
                                          isFeatured ? 'module' : 'store'),
                                      arguments: StoreScreen(
                                          store: _storeList[index],
                                          fromModule: isFeatured),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 170,
                                        height: 150,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: ColorResources.white6,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              Dimensions
                                                                  .RADIUS_SMALL)),
                                                  child: CustomImage(
                                                    image:
                                                        '${Get.find<SplashController>().configModel.baseUrls.storeCoverPhotoUrl}'
                                                        '/${_storeList[index].coverPhoto}',
                                                    height: 90,
                                                    width: 200,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                DiscountTag(
                                                  discount: storeController
                                                      .getDiscount(
                                                          _storeList[index]),
                                                  discountType: storeController
                                                      .getDiscountType(
                                                          _storeList[index]),
                                                  freeDelivery:
                                                      _storeList[index]
                                                          .freeDelivery,
                                                ),
                                                storeController.isOpenNow(
                                                        _storeList[index])
                                                    ? SizedBox()
                                                    : NotAvailableWidget(
                                                        isStore: true),
                                              ]),
                                            ]),
                                      ),
                                      Container(
                                        width: 170,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 10),
                                                Text(
                                                  _storeList[index].name ?? '',
                                                  style: robotoMedium.copyWith(
                                                      fontSize: 15),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 130,
                                                      child: Text(
                                                        _storeList[index]
                                                                .address ??
                                                            '',
                                                        style: robotoMedium
                                                            .copyWith(
                                                                fontSize: 15,
                                                                color:
                                                                    ColorResources
                                                                        .blue1),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    GetBuilder<
                                                            WishListController>(
                                                        builder:
                                                            (wishController) {
                                                      bool _isWished =
                                                          wishController
                                                              .wishStoreIdList
                                                              .contains(
                                                                  _storeList[
                                                                          index]
                                                                      .id);
                                                      return InkWell(
                                                        onTap: () {
                                                          if (Get.find<
                                                                  AuthController>()
                                                              .isLoggedIn()) {
                                                            _isWished
                                                                ? wishController
                                                                    .removeFromWishList(
                                                                        _storeList[index]
                                                                            .id,
                                                                        true)
                                                                : wishController
                                                                    .addToWishList(
                                                                        null,
                                                                        _storeList[
                                                                            index],
                                                                        true);
                                                          } else {
                                                            showCustomSnackBar(
                                                                'you_are_not_logged_in'
                                                                    .tr);
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .all(Dimensions
                                                                  .PADDING_SIZE_EXTRA_SMALL),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                        .RADIUS_SMALL),
                                                          ),
                                                          child: Icon(
                                                            _isWished
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_border,
                                                            size: 15,
                                                            color: _isWished
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                RatingBar(
                                                  rating: _storeList[index]
                                                      .avgRating,
                                                  ratingCount: _storeList[index]
                                                      .ratingCount,
                                                  size: 12,
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : PopularStoreShimmer(storeController: storeController),
                ),
              ],
            );
    });
  }
}

class PopularStoreShimmer extends StatelessWidget {
  final StoreController storeController;
  PopularStoreShimmer({@required this.storeController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 150,
          width: 200,
          margin:
              EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 90,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimensions.RADIUS_SMALL)),
                    color: Colors.grey[300]),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 10, width: 100, color: Colors.grey[300]),
                        SizedBox(height: 5),
                        Container(
                            height: 10, width: 130, color: Colors.grey[300]),
                        SizedBox(height: 5),
                        RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
