import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/order_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/service/main.dart';
import 'package:sixam_mart/theme/light_theme.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/cart_widget.dart';
import 'package:sixam_mart/view/customization/blogs/Blogs_screen.dart';
import 'package:sixam_mart/view/customization/videos/videos_screen.dart';
import 'package:sixam_mart/view/screens/cart/cart_screen.dart';
import 'package:sixam_mart/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:sixam_mart/view/screens/favourite/favourite_screen.dart';
import 'package:sixam_mart/view/screens/home/home_screen.dart';
import 'package:sixam_mart/view/screens/menu/menu_screen.dart';
import 'package:sixam_mart/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../social_app/app.dart';
import '../../../util/colors.dart';
import 'widget/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  GlobalKey<ExpandableBottomSheetState> key = new GlobalKey();

  bool _isLogin;
  AdaptiveThemeMode savedThemeMode;
  SharedPreferences prefs;

  void getPrefs() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    await SharedPreferences.getInstance().then(
      (pref) {
        prefs = pref;
        log('pref is : $pref');
        // setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
    _isLogin = Get.find<AuthController>().isLoggedIn();

    if (_isLogin) {
      Get.find<OrderController>().getRunningOrders(1, fromDashBoard: true);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      // HomeScreen(),
      Socialoo(prefs, savedThemeMode),
      // Container(),
      // FavouriteScreen(),
      // BlogScreen(isAllBlogs: true),
      // CartScreen(fromNav: true),
      MyServiceApp(),
      HomeScreen(),
      // VideoScreen(isAllVideos: true),
      // OrderScreen(),
      // Container(),
      // CartScreen(fromNav: true),
    ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  final _menuKey = GlobalKey<ExpandableFabState>();
  @override
  Widget build(BuildContext context) {
    getPrefs();
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 2) {
          _setPage(2);
          return false;
        } else {
          if (!ResponsiveHelper.isDesktop(context) &&
              Get.find<SplashController>().module != null &&
              Get.find<SplashController>().configModel.module == null) {
            Get.find<SplashController>().setModule(null);
            return false;
          } else {
            if (_canExit) {
              return true;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('back_press_again_to_exit'.tr,
                    style: TextStyle(color: Colors.white)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              ));
              _canExit = true;
              Timer(Duration(seconds: 2), () {
                _canExit = false;
              });
              return false;
            }
          }
        }
      },
      child: GetBuilder<OrderController>(builder: (orderController) {
        List<OrderModel> _runningOrder =
            orderController.runningOrderModel != null
                ? orderController.runningOrderModel.orders
                : [];

        List<OrderModel> _reversOrder = List.from(_runningOrder.reversed);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: (orderController.showBottomSheet &&
                  orderController.runningOrderModel != null &&
                  orderController.runningOrderModel.orders.isNotEmpty)
              ? SizedBox()
              : ExpandableFab(
                  type: ExpandableFabType.up,
                  backgroundColor: ColorResources.blue1,
                  foregroundColor: ColorResources.white,
                  distance: 60,
                  key: _menuKey,
                  children: [
                    FloatingActionButton.small(
                      backgroundColor: ColorResources.blue1,
                      foregroundColor: ColorResources.white,
                      child: const Icon(Icons.home_repair_service),
                      onPressed: () {
                        final state = _menuKey.currentState;
                        if (state != null) {
                          debugPrint('isOpen:${state.isOpen}');
                          state.toggle();
                        }
                        _setPage(1);
                      },
                    ),
                    FloatingActionButton.small(
                      backgroundColor: ColorResources.blue1,
                      foregroundColor: ColorResources.white,
                      child: const Icon(Icons.language),
                      onPressed: () {
                        final state = _menuKey.currentState;
                        if (state != null) {
                          debugPrint('isOpen:${state.isOpen}');
                          state.toggle();
                        }
                        _setPage(0);
                      },
                    ),
                    FloatingActionButton.small(
                      backgroundColor: ColorResources.blue1,
                      foregroundColor: ColorResources.white,
                      child: const Icon(Icons.home_filled),
                      onPressed: () {
                        final state = _menuKey.currentState;
                        if (state != null) {
                          debugPrint('isOpen:${state.isOpen}');
                          state.toggle();
                        }
                        _setPage(2);
                      },
                    ),
                  ],
                ),

          // floatingActionButton: ResponsiveHelper.isDesktop(context)
          //     ? null
          //     : (orderController.showBottomSheet &&
          //             orderController.runningOrderModel != null &&
          //             orderController.runningOrderModel.orders.isNotEmpty)
          //         ? SizedBox()
          //         : FloatingActionButton(
          //             elevation: 5,
          //             backgroundColor: _pageIndex == 2
          //                 ? ColorResources.blue1
          //                 : Theme.of(context).cardColor,
          //             onPressed: () => _setPage(2),
          //             child: Icon(
          //               Icons.home_filled,
          //               color: _pageIndex == 2
          //                   ? Theme.of(context).cardColor
          //                   : Theme.of(context).disabledColor,
          //             ),
          //             // child: CartWidget(
          //             //     color: _pageIndex == 2
          //             //         ? Theme.of(context).cardColor
          //             //         : Theme.of(context).disabledColor,
          //             //     size: 30),
          //           ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          // bottomNavigationBar: ResponsiveHelper.isDesktop(context)
          //     ? SizedBox()
          //     : (orderController.showBottomSheet &&
          //             orderController.runningOrderModel != null &&
          //             orderController.runningOrderModel.orders.isNotEmpty)
          //         ? SizedBox()
          //         : BottomAppBar(
          //             elevation: 5,
          //             notchMargin: 5,
          //             clipBehavior: Clip.antiAlias,
          //             shape: CircularNotchedRectangle(),
          //             child: Padding(
          //               padding:
          //                   EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //               child: Row(children: [
          //                 BottomNavItem(
          //                     iconData: Icons.language,
          //                     isSelected: _pageIndex == 0,
          //                     onTap: () => _setPage(0)),
          //                 BottomNavItem(
          //                     iconData: Icons.library_books,
          //                     isSelected: _pageIndex == 1,
          //                     onTap: () => _setPage(1)),
          //                 Expanded(child: SizedBox()),
          //                 BottomNavItem(
          //                     iconData: Icons.video_collection_outlined,
          //                     isSelected: _pageIndex == 3,
          //                     onTap: () => _setPage(3)),
          //                 BottomNavItem(
          //                     iconData: Icons.shopping_bag_outlined,
          //                     isSelected: _pageIndex == 4,
          //                     onTap: () => _setPage(4)
          //                     // onTap: () {
          //                     //   Get.bottomSheet(MenuScreen(),
          //                     //       backgroundColor: Colors.transparent,
          //                     //       isScrollControlled: true);
          //                     // }
          //                     ),
          //               ]),
          //             ),
          //           ),
          body: ExpandableBottomSheet(
            background: PageView.builder(
              controller: _pageController,
              itemCount: _screens.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _screens[index];
              },
            ),
            persistentContentHeight: 100,
            onIsContractedCallback: () {
              if (!orderController.showOneOrder) {
                orderController.showOrders();
              }
            },
            onIsExtendedCallback: () {
              if (orderController.showOneOrder) {
                orderController.showOrders();
              }
            },
            enableToggle: true,
            expandableContent: (ResponsiveHelper.isDesktop(context) ||
                    !_isLogin ||
                    orderController.runningOrderModel == null ||
                    orderController.runningOrderModel.orders.isEmpty ||
                    !orderController.showBottomSheet)
                ? null
                : Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if (orderController.showBottomSheet) {
                        orderController.showRunningOrders();
                      }
                    },
                    child: RunningOrderViewWidget(reversOrder: _reversOrder),
                  ),
          ),
        );
      }),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Widget trackView(BuildContext context, {@required bool status}) {
    return Container(
        height: 3,
        decoration: BoxDecoration(
            color: status
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)));
  }
}
