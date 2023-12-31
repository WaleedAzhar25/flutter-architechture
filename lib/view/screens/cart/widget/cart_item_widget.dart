import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/cart_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/quantity_button.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/colors.dart';

class CartItemWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  CartItemWidget(
      {@required this.cart,
      @required this.cartIndex,
      @required this.isAvailable,
      @required this.addOns});

  @override
  Widget build(BuildContext context) {
    String _addOnText = '';
    int _index = 0;
    List<int> _ids = [];
    List<int> _qtys = [];
    cart.addOnIds.forEach((addOn) {
      _ids.add(addOn.id);
      _qtys.add(addOn.quantity);
    });
    cart.item.addOns.forEach((addOn) {
      if (_ids.contains(addOn.id)) {
        _addOnText = _addOnText +
            '${(_index == 0) ? '' : ',  '}${addOn.name} (${_qtys[_index]})';
        _index = _index + 1;
      }
    });

    String _variationText = '';
    if (cart.variation.length > 0) {
      List<String> _variationTypes = cart.variation[0].type.split('-');
      if (_variationTypes.length == cart.item.choiceOptions.length) {
        int _index = 0;
        cart.item.choiceOptions.forEach((choice) {
          _variationText = _variationText +
              '${(_index == 0) ? '' : ',  '}${choice.title} - ${_variationTypes[_index]}';
          _index = _index + 1;
        });
      } else {
        _variationText = cart.item.variations[0].type;
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      child: InkWell(
        onTap: () {
          // ResponsiveHelper.isMobile(context)
          //     ? showModalBottomSheet(
          //         context: context,
          //         isScrollControlled: true,
          //         backgroundColor: Colors.transparent,
          //         builder: (con) => ItemBottomSheet(
          //             item: cart.item, cartIndex: cartIndex, cart: cart),
          //       )
          //     : showDialog(
          //         context: context,
          //         builder: (con) => Dialog(
          //               child: ItemBottomSheet(
          //                   item: cart.item, cartIndex: cartIndex, cart: cart),
          //             ));
        },
        child: Stack(children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Icon(Icons.delete, color: Colors.white, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) =>
                Get.find<CartController>().removeFromCart(cartIndex),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorResources.white,
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
                children: [
                  Row(children: [
                    Stack(
                      children: [
                        Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: ColorResources.white6,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Image.network(
                                '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${cart.item.image}'),
                          ),
                        ),
                        isAvailable
                            ? SizedBox()
                            : Positioned(
                                top: 0,
                                left: 0,
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      color: Colors.black.withOpacity(0.6)),
                                  child: Text('not_available_now_break'.tr,
                                      textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(
                                        color: Colors.white,
                                        fontSize: 8,
                                      )),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cart.item.name,
                              style: robotoMedium.copyWith(fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            RatingBar(
                                rating: cart.item.avgRating,
                                size: 12,
                                ratingCount: cart.item.ratingCount),
                            SizedBox(height: 5),
                            Text(
                              PriceConverter.convertPrice(
                                  cart.discountedPrice + cart.discountAmount),
                              style: robotoMedium.copyWith(
                                fontSize: 18,
                                color: ColorResources.blue1,
                              ),
                            ),
                          ]),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ((Get.find<SplashController>()
                                          .configModel
                                          .moduleConfig
                                          .module
                                          .unit &&
                                      cart.item.unitType != null) ||
                                  (Get.find<SplashController>()
                                          .configModel
                                          .moduleConfig
                                          .module
                                          .vegNonVeg &&
                                      Get.find<SplashController>()
                                          .configModel
                                          .toggleVegNonVeg))
                              ? Container(
                                  height: 50,
                                  width: 120,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                      horizontal:
                                          Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Text(
                                    Get.find<SplashController>()
                                            .configModel
                                            .moduleConfig
                                            .module
                                            .unit
                                        ? cart.item.unitType ?? ''
                                        : cart.item.veg == 0
                                            ? 'non_veg'.tr
                                            : 'veg'.tr,
                                    style: robotoRegular.copyWith(
                                        fontSize: 18,
                                        color: ColorResources.white),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                              height: Get.find<SplashController>()
                                      .configModel
                                      .toggleVegNonVeg
                                  ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                  : 10),
                          Row(children: [
                            QuantityButton(
                              onTap: () {
                                if (cart.quantity > 1) {
                                  Get.find<CartController>().setQuantity(
                                      false, cartIndex, cart.stock);
                                } else {
                                  Get.find<CartController>()
                                      .removeFromCart(cartIndex);
                                }
                              },
                              isIncrement: false,
                            ),
                            Text(cart.quantity.toString(),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge)),
                            QuantityButton(
                              onTap: () => Get.find<CartController>()
                                  .setQuantity(true, cartIndex, cart.stock),
                              isIncrement: true,
                            ),
                          ]),
                        ]),
                    !ResponsiveHelper.isMobile(context)
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                            child: IconButton(
                              onPressed: () {
                                Get.find<CartController>()
                                    .removeFromCart(cartIndex);
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          )
                        : SizedBox(),
                  ]),
                  (Get.find<SplashController>()
                              .configModel
                              .moduleConfig
                              .module
                              .addOn &&
                          _addOnText.isNotEmpty)
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Row(children: [
                            SizedBox(width: 80),
                            Text('${'addons'.tr}: ',
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall)),
                            Flexible(
                                child: Text(
                              _addOnText,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).disabledColor),
                            )),
                          ]),
                        )
                      : SizedBox(),
                  cart.item.variations.length > 0
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Row(children: [
                            SizedBox(width: 80),
                            Text('${'variations'.tr}: ',
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall)),
                            Flexible(
                                child: Text(
                              _variationText,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).disabledColor),
                            )),
                          ]),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
