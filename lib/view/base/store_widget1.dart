import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/module_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/colors.dart';

class StoreWidget1 extends StatelessWidget {
  final Item item;
  final Store store;
  final bool isStore;
  final int index;
  final int length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  StoreWidget1(
      {@required this.item,
      @required this.isStore,
      @required this.store,
      @required this.index,
      @required this.length,
      this.inStore = false,
      this.isCampaign = false,
      this.isFeatured = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;
    if (isStore) {
      _discount = store.discount != null ? store.discount.discount : 0;
      _discountType =
          store.discount != null ? store.discount.discountType : 'percent';
      // bool _isClosedToday = Get.find<StoreController>().isRestaurantClosed(true, store.active, store.offDay);
      // _isAvailable = DateConverter.isAvailable(store.openingTime, store.closeingTime) && store.active && !_isClosedToday;
      _isAvailable = store.open == 1 && store.active;
    } else {
      _discount = (item.storeDiscount == 0 || isCampaign)
          ? item.discount
          : item.storeDiscount;
      _discountType = (item.storeDiscount == 0 || isCampaign)
          ? item.discountType
          : 'percent';
      _isAvailable = DateConverter.isAvailable(
          item.availableTimeStarts, item.availableTimeEnds);
    }

    return InkWell(
      onTap: () {
        if (isStore) {
          if (store != null) {
            if (isFeatured && Get.find<SplashController>().moduleList != null) {
              for (ModuleModel module
                  in Get.find<SplashController>().moduleList) {
                if (module.id == store.moduleId) {
                  Get.find<SplashController>().setModule(module);
                  break;
                }
              }
            }
            Get.toNamed(
              RouteHelper.getStoreRoute(
                  store.id, isFeatured ? 'module' : 'item'),
              arguments: StoreScreen(store: store, fromModule: isFeatured),
            );
          }
        } else {
          Get.find<ItemController>().navigateToItemPage(item, context,
              inStore: inStore, isCampaign: isCampaign);
        }
      },
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 170,
            height: 150,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorResources.white6,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image:
                            '${isCampaign ? _baseUrls.campaignImageUrl : isStore ? _baseUrls.storeImageUrl : _baseUrls.itemImageUrl}'
                            '/${isStore ? store.logo : item.image}',
                        height: 120,
                        width: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                    DiscountTag(
                      discount: _discount,
                      discountType: _discountType,
                      freeDelivery: isStore ? store.freeDelivery : false,
                    ),
                    _isAvailable
                        ? SizedBox()
                        : NotAvailableWidget(isStore: isStore),
                  ]),
                ]),
          ),
          Container(
            color: ColorResources.white,
            width: 170,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      store.name,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      store.address,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: ColorResources.blue1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    RatingBar(
                      rating: isStore ? store.avgRating : item.avgRating,
                      size: _desktop ? 15 : 12,
                      ratingCount:
                          isStore ? store.ratingCount : item.ratingCount,
                    ),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorResources.blue1),
                        child: Icon(Icons.add, size: 20, color: Colors.white),
                      ),
                    ]),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
