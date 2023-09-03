import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/item_controller.dart';
import '../../../controller/localization_controller.dart';
import '../../../controller/wishlist_controller.dart';
import '../../../data/model/response/config_model.dart';
import '../../../data/model/response/item_model.dart';
import '../../../data/model/response/module_model.dart';
import '../../../data/model/response/store_model.dart';
import '../../../helper/date_converter.dart';
import '../../../helper/price_converter.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_constants.dart';
import '../../base/custom_image.dart';
import '../../base/custom_snackbar.dart';
import '../../base/discount_tag.dart';
import '../../base/item_shimmer.dart';
import '../../base/item_widget.dart';
import '../../base/not_available_widget.dart';
import '../../base/rating_bar.dart';
import '../../base/veg_filter_widget.dart';
import '../../base/web_menu_bar.dart';
import '../home/theme1/store_widget.dart';
import '../store/store_screen.dart';

bool isIndexChanged = false;

class ServiceCategoryScreen extends StatefulWidget {
  @override
  State<ServiceCategoryScreen> createState() => _ServiceCategoryScreenState();
}

class _ServiceCategoryScreenState extends State<ServiceCategoryScreen> {
  var _moduleName;
  void getModuleName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _moduleName = ModuleModel.fromJson(
            jsonDecode(sharedPreferences.getString(AppConstants.MODULE_ID)))
        .moduleName;
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    log('category screen build called');

    Get.find<CategoryController>().getCategoryList(false);
    getModuleName();

    log('module name is : ${_moduleName}');
    return Scaffold(
      appBar: CustomAppBar(title: 'categories'.tr),
      endDrawer: MenuDrawer(),
      body: SafeArea(
          child: Scrollbar(
              child: Row(
        children: [
          GetBuilder<CategoryController>(builder: (catController) {
            return Row(
              children: [
                catController.categoryList != null
                    ? catController.categoryList.length > 0
                        ? Container(
                            width: 90,
                            margin: EdgeInsets.only(top: 3),
                            decoration: BoxDecoration(
                              color: Theme.of(context).highlightColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[200],
                                    spreadRadius: 1,
                                    blurRadius: 1)
                              ],
                            ),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              itemCount: catController.categoryList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    isIndexChanged = true;
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                    // if (_moduleName == 'Pharmacy' ||
                                    //     _moduleName == 'Services') {
                                    //   Get.to(() => ServiceItemScreen1(
                                    //         categoryID: catController
                                    //             .categoryList[index].id
                                    //             .toString(),
                                    //         categoryName: catController
                                    //             .categoryList[index].name,
                                    //       ));
                                    // } else {
                                    //   Get.toNamed(
                                    //     RouteHelper.getCategoryItemRoute(
                                    //       catController.categoryList[index].id,
                                    //       catController
                                    //           .categoryList[index].name,
                                    //     ),
                                    //   );
                                    // }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedIndex == index
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //       color: Colors.grey[
                                      //           Get.isDarkMode ? 800 : 200],
                                      //       blurRadius: 5,
                                      //       spreadRadius: 1)
                                      // ],
                                    ),
                                    alignment: Alignment.center,
                                    child: ListTile(
                                      // leading: ClipRRect(
                                      //   borderRadius: BorderRadius.circular(
                                      //       Dimensions.RADIUS_SMALL),
                                      //   child: CustomImage(
                                      //     height: 50,
                                      //     width: 50,
                                      //     fit: BoxFit.cover,
                                      //     image:
                                      //         '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${catController.categoryList[index].image}',
                                      //   ),
                                      // ),
                                      title: Text(
                                        catController.categoryList[index].name,
                                        textAlign: TextAlign.center,
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // trailing: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : NoDataScreen(text: 'no_category_found'.tr)
                    : Center(child: CircularProgressIndicator()),

                Container(
                  width: Get.width - 100,
                  child: ServiceItemScreen1(
                    categoryID:
                        catController.categoryList[selectedIndex].id.toString(),
                    categoryName:
                        catController.categoryList[selectedIndex].name,
                  ),
                )

                //                Expanded(
                //   child: ServiceItemScreen1(
                //           categoryID: catController
                //                                   .categoryList[0].id
                //                                   .toString(),
                //                               categoryName: catController
                //                                   .categoryList[0].name,
                //   ),
                // ),
              ],
            );
          }),
        ],
      ))),
    );
  }
}

class ServiceItemScreen1 extends StatefulWidget {
  final String categoryID;
  final String categoryName;
  ServiceItemScreen1({@required this.categoryID, @required this.categoryName});

  @override
  _ServiceItemScreen1State createState() => _ServiceItemScreen1State();
}

class _ServiceItemScreen1State extends State<ServiceItemScreen1>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _tabController = TabController(length: 1, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryItemList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList[
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    storeScrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryStoreList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
            (Get.find<CategoryController>().restPageSize / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryStoreList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList[
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    isIndexChanged = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isIndexChanged == true) {
      _init();
    }
    log('service items screen build called');
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Item> _item;
      List<Store> _stores;
      if (catController.categoryItemList != null &&
          catController.searchItemList != null) {
        _item = [];
        if (catController.isSearching) {
          _item.addAll(catController.searchItemList);
        } else {
          _item.addAll(catController.categoryItemList);
        }
      }
      if (catController.categoryStoreList != null &&
          catController.searchStoreList != null) {
        _stores = [];
        if (catController.isSearching) {
          _stores.addAll(catController.searchStoreList);
        } else {
          _stores.addAll(catController.categoryStoreList);
        }
      }

      return WillPopScope(
        onWillPop: () async {
          if (catController.isSearching) {
            catController.toggleSearch();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context)
              ? WebMenuBar()
              : AppBar(
                  title: catController.isSearching
                      ? TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                          onSubmitted: (String query) =>
                              catController.searchData(
                            query,
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList[
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            catController.type,
                          ),
                        )
                      : Text(widget.categoryName,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          )),
                  centerTitle: true,
                  // leading: IconButton(
                  //   icon: Icon(Icons.arrow_back_ios),
                  //   color: Theme.of(context).textTheme.bodyText1.color,
                  //   onPressed: () {
                  //     if (catController.isSearching) {
                  //       catController.toggleSearch();
                  //     } else {
                  //       Get.back();
                  //     }
                  //   },
                  // ),
                  backgroundColor: Theme.of(context).cardColor,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () => catController.toggleSearch(),
                      icon: Icon(
                        catController.isSearching
                            ? Icons.close_sharp
                            : Icons.search,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                    //   icon: CartWidget(
                    //       color: Theme.of(context).textTheme.bodyText1.color,
                    //       size: 25),
                    // ),
                  ],
                ),
          // endDrawer: MenuDrawer(),
          body: Center(
              child: SizedBox(
            width: Dimensions.WEB_MAX_WIDTH,
            child: Column(children: [
              ///// code for all circle when searching all items in the list

              // (catController.subCategoryList != null &&
              //         !catController.isSearching)
              //     ? Center(
              //         child: Container(
              //         height: 50,
              //         width: Dimensions.WEB_MAX_WIDTH,
              //         color: Theme.of(context).cardColor,
              //         padding: EdgeInsets.symmetric(
              //             vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              //         child: ListView.builder(
              //           scrollDirection: Axis.horizontal,
              //           itemCount: catController.subCategoryList.length,
              //           padding: EdgeInsets.only(
              //               left: Dimensions.PADDING_SIZE_SMALL),
              //           physics: BouncingScrollPhysics(),
              //           itemBuilder: (context, index) {
              //             return InkWell(
              //               onTap: () => catController.setSubCategoryIndex(
              //                   index, widget.categoryID),
              //               child: Container(
              //                 padding: EdgeInsets.only(
              //                   left: index == 0
              //                       ? Dimensions.PADDING_SIZE_LARGE
              //                       : Dimensions.PADDING_SIZE_SMALL,
              //                   right: index ==
              //                           catController.subCategoryList.length - 1
              //                       ? Dimensions.PADDING_SIZE_LARGE
              //                       : Dimensions.PADDING_SIZE_SMALL,
              //                   top: Dimensions.PADDING_SIZE_SMALL,
              //                 ),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.horizontal(
              //                     left: Radius.circular(
              //                       _ltr
              //                           ? index == 0
              //                               ? Dimensions.RADIUS_EXTRA_LARGE
              //                               : 0
              //                           : index ==
              //                                   catController.subCategoryList
              //                                           .length -
              //                                       1
              //                               ? Dimensions.RADIUS_EXTRA_LARGE
              //                               : 0,
              //                     ),
              //                     right: Radius.circular(
              //                       _ltr
              //                           ? index ==
              //                                   catController.subCategoryList
              //                                           .length -
              //                                       1
              //                               ? Dimensions.RADIUS_EXTRA_LARGE
              //                               : 0
              //                           : index == 0
              //                               ? Dimensions.RADIUS_EXTRA_LARGE
              //                               : 0,
              //                     ),
              //                   ),
              //                   color: Theme.of(context)
              //                       .primaryColor
              //                       .withOpacity(0.1),
              //                 ),
              //                 child: Column(children: [
              //                   SizedBox(height: 3),
              //                   Text(
              //                     catController.subCategoryList[index].name,
              //                     style: index == catController.subCategoryIndex
              //                         ? robotoMedium.copyWith(
              //                             fontSize: Dimensions.fontSizeSmall,
              //                             color: Theme.of(context).primaryColor)
              //                         : robotoRegular.copyWith(
              //                             fontSize: Dimensions.fontSizeSmall,
              //                             color:
              //                                 Theme.of(context).disabledColor),
              //                   ),
              //                   index == catController.subCategoryIndex
              //                       ? Container(
              //                           height: 5,
              //                           width: 5,
              //                           decoration: BoxDecoration(
              //                               color:
              //                                   Theme.of(context).primaryColor,
              //                               shape: BoxShape.circle),
              //                         )
              //                       : SizedBox(height: 5, width: 5),
              //                 ]),
              //               ),
              //             );
              //           },
              //         ),
              //       ))
              //     : SizedBox(),

              //
              // Center(
              //     child: Container(
              //   width: Dimensions.WEB_MAX_WIDTH,
              //   color: Theme.of(context).cardColor,
              //   child: TabBar(
              //     controller: _tabController,
              //     indicatorColor: Theme.of(context).primaryColor,
              //     indicatorWeight: 3,
              //     labelColor: Theme.of(context).primaryColor,
              //     unselectedLabelColor: Theme.of(context).disabledColor,
              //     unselectedLabelStyle: robotoRegular.copyWith(
              //         color: Theme.of(context).disabledColor,
              //         fontSize: Dimensions.fontSizeSmall),
              //     labelStyle: robotoBold.copyWith(
              //         fontSize: Dimensions.fontSizeSmall,
              //         color: Theme.of(context).primaryColor),
              //     tabs: [
              //       Tab(text: 'item'.tr),
              //       // Tab(
              //       //     text: Get.find<SplashController>()
              //       //             .configModel
              //       //             .moduleConfig
              //       //             .module
              //       //             .showRestaurantText
              //       //         ? 'restaurants'.tr
              //       //         : 'stores'.tr),
              //     ],
              //   ),
              // )),
              VegFilterWidget(
                  type: catController.type,
                  onSelected: (String type) {
                    if (catController.isSearching) {
                      catController.searchData(
                        catController.subCategoryIndex == 0
                            ? widget.categoryID
                            : catController
                                .subCategoryList[catController.subCategoryIndex]
                                .id
                                .toString(),
                        '1',
                        type,
                      );
                    } else {
                      if (catController.isStore) {
                        catController.getCategoryStoreList(
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList[
                                      catController.subCategoryIndex]
                                  .id
                                  .toString(),
                          1,
                          type,
                          true,
                        );
                      } else {
                        catController.getCategoryItemList(
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList[
                                      catController.subCategoryIndex]
                                  .id
                                  .toString(),
                          1,
                          type,
                          true,
                        );
                      }
                    }
                  }),
              Expanded(
                  child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    if ((_tabController.index == 1 && !catController.isStore) ||
                        _tabController.index == 0 && catController.isStore) {
                      catController.setRestaurant(_tabController.index == 1);
                      if (catController.isSearching) {
                        catController.searchData(
                          catController.searchText,
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList[
                                      catController.subCategoryIndex]
                                  .id
                                  .toString(),
                          catController.type,
                        );
                      } else {
                        if (_tabController.index == 1) {
                          catController.getCategoryStoreList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList[
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            catController.type,
                            false,
                          );
                        } else {
                          catController.getCategoryItemList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList[
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            catController.type,
                            false,
                          );
                        }
                      }
                    }
                  }
                  return false;
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: ItemsView(
                        isStore: false,
                        items: _item,
                        stores: null,
                        noDataText: 'no_category_item_found'.tr,
                      ),
                    ),
                    // SingleChildScrollView(
                    //   controller: storeScrollController,
                    //   child: ItemsView(
                    //     isStore: true,
                    //     items: null,
                    //     stores: _stores,
                    //     noDataText: Get.find<SplashController>()
                    //             .configModel
                    //             .moduleConfig
                    //             .module
                    //             .showRestaurantText
                    //         ? 'no_category_restaurant_found'.tr
                    //         : 'no_category_store_found'.tr,
                    //   ),
                    // ),
                  ],
                ),
              )),
              catController.isLoading
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    ))
                  : SizedBox(),
            ]),
          )),
        ),
      );
    });
  }
}

class ItemsView extends StatelessWidget {
  final List<Item> items;
  final List<Store> stores;
  final bool isStore;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool isCampaign;
  final bool inStorePage;
  final String type;
  final bool isFeatured;
  final bool showTheme1Store;
  final Function(String type) onVegFilterTap;
  ItemsView(
      {@required this.stores,
      @required this.items,
      @required this.isStore,
      this.isScrollable = false,
      this.shimmerLength = 20,
      this.padding = const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      this.noDataText,
      this.isCampaign = false,
      this.inStorePage = false,
      this.type,
      this.onVegFilterTap,
      this.isFeatured = false,
      this.showTheme1Store = false});

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;
    if (isStore) {
      _isNull = stores == null;
      if (!_isNull) {
        _length = stores.length;
      }
    } else {
      _isNull = items == null;
      if (!_isNull) {
        _length = items.length;
      }
    }

    return Column(children: [
      type != null
          ? VegFilterWidget(type: type, onSelected: onVegFilterTap)
          : SizedBox(),
      !_isNull
          ? _length > 0
              ? GridView.builder(
                  key: UniqueKey(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                    mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.PADDING_SIZE_LARGE
                        : 0.01,
                    childAspectRatio: ResponsiveHelper.isDesktop(context)
                        ? 4
                        : showTheme1Store
                            ? 1.9
                            : 2.8,
                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                  ),
                  physics: isScrollable
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  shrinkWrap: isScrollable ? false : true,
                  itemCount: _length,
                  padding: padding,
                  itemBuilder: (context, index) {
                    return showTheme1Store
                        ? StoreWidget(
                            store: stores[index],
                            index: index,
                            inStore: inStorePage)
                        : ItemWidget(
                            isStore: isStore,
                            item: isStore ? null : items[index],
                            isFeatured: isFeatured,
                            store: isStore ? stores[index] : null,
                            index: index,
                            length: _length,
                            isCampaign: isCampaign,
                            inStore: inStorePage,
                          );
                  },
                )
              : NoDataScreen(
                  text: noDataText != null
                      ? noDataText
                      : isStore
                          ? Get.find<SplashController>()
                                  .configModel
                                  .moduleConfig
                                  .module
                                  .showRestaurantText
                              ? 'no_restaurant_available'.tr
                              : 'no_store_available'.tr
                          : 'no_item_available'.tr,
                )
          : GridView.builder(
              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.PADDING_SIZE_LARGE
                    : 0.01,
                childAspectRatio: ResponsiveHelper.isDesktop(context)
                    ? 4
                    : showTheme1Store
                        ? 1.9
                        : 2,
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
              ),
              physics: isScrollable
                  ? BouncingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              shrinkWrap: isScrollable ? false : true,
              itemCount: shimmerLength,
              padding: padding,
              itemBuilder: (context, index) {
                return showTheme1Store
                    ? StoreShimmer(isEnable: _isNull)
                    : ItemShimmer(
                        isEnabled: _isNull,
                        isStore: isStore,
                        hasDivider: index != shimmerLength - 1);
              },
            ),
    ]);
  }
}

class ItemWidget extends StatelessWidget {
  final Item item;
  final Store store;
  final bool isStore;
  final int index;
  final int length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  ItemWidget(
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
        padding: ResponsiveHelper.isDesktop(context)
            ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)
            : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          color: ResponsiveHelper.isDesktop(context)
              ? Theme.of(context).cardColor
              : null,
          boxShadow: ResponsiveHelper.isDesktop(context)
              ? [
                  BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 700 : 300],
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ]
              : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Row(children: [
              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: CustomImage(
                    image:
                        '${isCampaign ? _baseUrls.campaignImageUrl : isStore ? _baseUrls.storeImageUrl : _baseUrls.itemImageUrl}'
                        '/${isStore ? store.logo : item.image}',
                    height: _desktop ? 120 : 65,
                    width: _desktop ? 120 : 80,
                    fit: BoxFit.cover,
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
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isStore ? store.name : item.name,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                        maxLines: _desktop ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                          height: isStore
                              ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                              : 0),
                      (isStore ? store.address != null : item.storeName != null)
                          ? Text(
                              isStore
                                  ? store.address ?? ''
                                  : item.storeName ?? '',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).disabledColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(),
                      SizedBox(
                          height: ((_desktop || isStore) &&
                                  (isStore
                                      ? store.address != null
                                      : item.storeName != null))
                              ? 5
                              : 0),
                      !isStore
                          ? RatingBar(
                              rating:
                                  isStore ? store.avgRating : item.avgRating,
                              size: _desktop ? 15 : 12,
                              ratingCount: isStore
                                  ? store.ratingCount
                                  : item.ratingCount,
                            )
                          : SizedBox(),
                      SizedBox(
                          height: (!isStore && _desktop)
                              ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                              : 0),
                      isStore
                          ? RatingBar(
                              rating:
                                  isStore ? store.avgRating : item.avgRating,
                              size: _desktop ? 15 : 12,
                              ratingCount: isStore
                                  ? store.ratingCount
                                  : item.ratingCount,
                            )
                          : Row(children: [
                              Text(
                                PriceConverter.convertPrice(item.price,
                                    discount: _discount,
                                    discountType: _discountType),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                              SizedBox(
                                  width: _discount > 0
                                      ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                      : 0),
                              _discount > 0
                                  ? Text(
                                      PriceConverter.convertPrice(item.price),
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context).disabledColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    )
                                  : SizedBox(),
                            ]),
                    ]),
              ),
              Column(
                  mainAxisAlignment: isStore
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    !isStore
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: _desktop
                                    ? Dimensions.PADDING_SIZE_SMALL
                                    : 0),
                            child: Icon(Icons.add, size: _desktop ? 30 : 25),
                          )
                        : SizedBox(),
                    GetBuilder<WishListController>(builder: (wishController) {
                      bool _isWished = isStore
                          ? wishController.wishStoreIdList.contains(store.id)
                          : wishController.wishItemIdList.contains(item.id);
                      return InkWell(
                        onTap: () {
                          if (Get.find<AuthController>().isLoggedIn()) {
                            _isWished
                                ? wishController.removeFromWishList(
                                    isStore ? store.id : item.id, isStore)
                                : wishController.addToWishList(
                                    item, store, isStore);
                          } else {
                            showCustomSnackBar('you_are_not_logged_in'.tr);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                          child: Icon(
                            _isWished ? Icons.favorite : Icons.favorite_border,
                            size: _desktop ? 30 : 25,
                            color: _isWished
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                      );
                    }),
                  ]),
            ]),
          )),
          _desktop
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(left: _desktop ? 130 : 90),
                  child: Divider(
                      color: index == length - 1
                          ? Colors.transparent
                          : Theme.of(context).disabledColor),
                ),
        ]),
      ),
    );
  }
}
