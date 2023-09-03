import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';

import '../../../../util/colors.dart';

class ItemTitleView extends StatelessWidget {
  final Item item;
  final bool inStorePage;
  ItemTitleView({@required this.item, this.inStorePage = false});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    double _startingPrice;
    double _endingPrice;
    if (item.variations.length != 0) {
      List<double> _priceList = [];
      item.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      _startingPrice = item.price;
    }

    return ResponsiveHelper.isDesktop(context)
        ? GetBuilder<ItemController>(builder: (itemController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  style: robotoMedium.copyWith(fontSize: 30),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                InkWell(
                  onTap: () {
                    if (inStorePage) {
                      Get.back();
                    } else {
                      Get.offNamed(
                          RouteHelper.getStoreRoute(item.storeId, 'item'));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                    child: Text(
                      item.storeName,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                RatingBar(
                    rating: item.avgRating,
                    ratingCount: item.ratingCount,
                    size: 21),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Row(children: [
                  Text(
                    '${PriceConverter.convertPrice(_startingPrice, discount: item.discount, discountType: item.discountType)}'
                    '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: item.discount, discountType: item.discountType)}' : ''}',
                    style: robotoBold.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  const SizedBox(width: 10),
                  item.discount > 0
                      ? Flexible(
                          child: Text(
                            '${PriceConverter.convertPrice(_startingPrice)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                            style: robotoRegular.copyWith(
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                        )
                      : SizedBox(),
                ]),
              ],
            );
          })
        : Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: ColorResources.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 34,
                  color: ColorResources.black.withOpacity(0.04),
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: GetBuilder<ItemController>(
              builder: (itemController) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Container(
                          margin: const EdgeInsets.only(right: 35),
                          child: Text(
                            item.name ?? '',
                            style: TextStyle(
                              fontSize: 24,
                              color: ColorResources.black2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                        // RatingBar(
                        //     rating: item.avgRating,
                        //     ratingCount: item.ratingCount),
                      ]),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Get.width * 0.6,
                            margin: const EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: () {
                                if (inStorePage) {
                                  Get.back();
                                } else {
                                  Get.offNamed(RouteHelper.getStoreRoute(
                                      item.storeId, 'item'));
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                child: Text(
                                  item.storeName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: ColorResources.blue1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 35),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: ColorResources.yellow,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    item.avgRating.toStringAsFixed(1),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: ColorResources.black2),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Text(
                          '${PriceConverter.convertPrice(_startingPrice, discount: item.discount, discountType: item.discountType)}'
                          '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: item.discount, discountType: item.discountType)}' : ''}',
                          style: TextStyle(
                            fontSize: 25,
                            color: ColorResources.blue1,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      item.discount > 0
                          ? Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Text(
                                '${PriceConverter.convertPrice(_startingPrice)}'
                                '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                                style: robotoRegular.copyWith(
                                    color: ColorResources.blue1,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: item.discount > 0 ? 5 : 0),
                      GetBuilder<WishListController>(builder: (wishController) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (_isLoggedIn) {
                                  if (wishController.wishItemIdList
                                      .contains(item.id)) {
                                    wishController.removeFromWishList(
                                        item.id, false);
                                  } else {
                                    wishController.addToWishList(
                                        item, null, false);
                                  }
                                } else
                                  showCustomSnackBar(
                                      'you_are_not_logged_in'.tr);
                              },
                              child: wishController.wishItemIdList
                                      .contains(item.id)
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      size: 25,
                                      color: wishController.wishItemIdList
                                              .contains(item.id)
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor,
                                    ),
                            ),
                          ],
                        );
                      }),
                    ]);
              },
            ),
          );
  }
}
