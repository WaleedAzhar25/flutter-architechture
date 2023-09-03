import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/theme/light_theme.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/title_widget.dart';
import 'package:sixam_mart/view/customization/services_provider/service_provider_screen.dart';
import 'package:sixam_mart/view/screens/home/widget/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../util/colors.dart';

class CategoryView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return (categoryController.categoryList != null &&
              categoryController.categoryList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TitleWidget(
                      title: 'categories'.tr,
                      onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
                ),
                categoryController.categoryList == null
                    ? SizedBox()
                    : Container(
                        height: Get.height > 805 ? 140 : 115,
                        width: Get.width,
                        color: ColorResources.white12,
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2,
                          ),
                          itemCount: categoryController.categoryList.length > 15
                              ? 15
                              : categoryController.categoryList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, right: 10, left: 10),
                              child: InkWell(
                                onTap: () => Get.toNamed(
                                    RouteHelper.getCategoryItemRoute(
                                  categoryController.categoryList[index].id,
                                  categoryController.categoryList[index].name,
                                )),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      categoryController
                                          .categoryList[index].name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                Row(
                  children: [
                    // Expanded(
                    //   child: SizedBox(
                    //     height: 150,
                    //     child: categoryController.categoryList != null
                    //         ? ListView.builder(
                    //             controller: _scrollController,
                    //             itemCount:
                    //                 categoryController.categoryList.length > 15
                    //                     ? 15
                    //                     : categoryController
                    //                         .categoryList.length,
                    //             padding: EdgeInsets.only(
                    //                 left: Dimensions.PADDING_SIZE_SMALL),
                    //             physics: BouncingScrollPhysics(),
                    //             scrollDirection: Axis.horizontal,
                    //             itemBuilder: (context, index) {
                    //               return Stack(
                    //                 children: [
                    //                   Padding(
                    //                     padding:
                    //                         const EdgeInsets.only(right: 8),
                    //                     child: InkWell(
                    //                       onTap: () => Get.toNamed(
                    //                           RouteHelper.getCategoryItemRoute(
                    //                         categoryController
                    //                             .categoryList[index].id,
                    //                         categoryController
                    //                             .categoryList[index].name,
                    //                       )),
                    //                       child: Container(
                    //                         height: 168,
                    //                         width: 122,
                    //                         decoration: BoxDecoration(
                    //                           borderRadius:
                    //                               BorderRadius.circular(12),
                    //                           image: DecorationImage(
                    //                             image: NetworkImage(
                    //                                 '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}'),
                    //                             fit: BoxFit.cover,
                    //                           ),
                    //                         ),
                    //                         child: ClipRRect(
                    //                           borderRadius:
                    //                               BorderRadius.circular(15),
                    //                           child: CustomImage(
                    //                             image:
                    //                                 '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}',
                    //                             height: 90,
                    //                             width: 100,
                    //                             fit: BoxFit.cover,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Positioned(
                    //                     bottom: 15,
                    //                     left: 0,
                    //                     right: 0,
                    //                     child: Container(
                    //                       width: 120,
                    //                       alignment: Alignment.center,
                    //                       child: Text(
                    //                         categoryController
                    //                             .categoryList[index].name,
                    //                         style: TextStyle(
                    //                           fontSize: 16,
                    //                           fontWeight: FontWeight.bold,
                    //                           color: Colors.white,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               );
                    //               return Padding(
                    //                 padding:
                    //                     EdgeInsets.symmetric(horizontal: 1),
                    //                 child: InkWell(
                    //                   onTap: () => Get.toNamed(
                    //                       RouteHelper.getCategoryItemRoute(
                    //                     categoryController
                    //                         .categoryList[index].id,
                    //                     categoryController
                    //                         .categoryList[index].name,
                    //                   )),
                    //                   child: SizedBox(
                    //                     width: 100,
                    //                     child: Container(
                    //                       height: 100,
                    //                       width: 100,
                    //                       margin: EdgeInsets.only(
                    //                         left: index == 0
                    //                             ? 0
                    //                             : Dimensions
                    //                                 .PADDING_SIZE_EXTRA_SMALL,
                    //                         right: Dimensions
                    //                             .PADDING_SIZE_EXTRA_SMALL,
                    //                       ),
                    //                       child: Stack(children: [
                    //                         ClipRRect(
                    //                           borderRadius:
                    //                               BorderRadius.circular(
                    //                                   Dimensions.RADIUS_SMALL),
                    //                           child: CustomImage(
                    //                             image:
                    //                                 '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}',
                    //                             height: 100,
                    //                             width: 100,
                    //                             fit: BoxFit.cover,
                    //                           ),
                    //                         ),
                    //                         Positioned(
                    //                             bottom: 0,
                    //                             left: 0,
                    //                             right: 0,
                    //                             child: Container(
                    //                               padding: EdgeInsets.symmetric(
                    //                                   vertical: 2),
                    //                               decoration: BoxDecoration(
                    //                                 borderRadius: BorderRadius.vertical(
                    //                                     bottom: Radius.circular(
                    //                                         Dimensions
                    //                                             .RADIUS_SMALL)),
                    //                                 color: Theme.of(context)
                    //                                     .primaryColor
                    //                                     .withOpacity(0.8),
                    //                               ),
                    //                               child: Text(
                    //                                 categoryController
                    //                                     .categoryList[index]
                    //                                     .name,
                    //                                 maxLines: 1,
                    //                                 overflow:
                    //                                     TextOverflow.ellipsis,
                    //                                 textAlign: TextAlign.center,
                    //                                 style: robotoMedium.copyWith(
                    //                                     fontSize: Dimensions
                    //                                         .fontSizeExtraSmall,
                    //                                     color: Colors.white),
                    //                               ),
                    //                             )),
                    //                       ]),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           )
                    //         : CategoryShimmer(
                    //             categoryController: categoryController),
                    //   ),
                    // ),
                    ResponsiveHelper.isMobile(context)
                        ? SizedBox()
                        : categoryController.categoryList != null
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (con) => Dialog(
                                              child: Container(
                                                  height: 550,
                                                  width: 600,
                                                  child: CategoryPopUp(
                                                    categoryController:
                                                        categoryController,
                                                  ))));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: Dimensions.PADDING_SIZE_SMALL),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Text('view_all'.tr,
                                            style: TextStyle(
                                                fontSize: Dimensions
                                                    .PADDING_SIZE_DEFAULT,
                                                color: Theme.of(context)
                                                    .cardColor)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              )
                            : CategoryAllShimmer(
                                categoryController: categoryController)
                  ],
                ),
              ],
            );
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  CategoryShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 14,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: SizedBox(
              width: 75,
              child: Container(
                height: 65,
                width: 65,
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                child: Shimmer(
                  duration: Duration(seconds: 2),
                  enabled: categoryController.categoryList == null,
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  final CategoryController categoryController;
  CategoryAllShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: categoryController.categoryList == null,
          child: Column(children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              ),
            ),
            SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}
