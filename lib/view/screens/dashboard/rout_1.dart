
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:shrink_sidemenu/shrink_sidemenu.dart';

// import '../../../util/images.dart';

// class NavigationBarBottom extends StatefulWidget {
//   @override
//   _NavigationBarBottomState createState() => _NavigationBarBottomState();
// }

// int selectedIndex = 0;

// class _NavigationBarBottomState extends State<NavigationBarBottom> {
//   Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
//     0: GlobalKey(),
//     1: GlobalKey(),
//     2: GlobalKey(),
//     3: GlobalKey(),
//     4: GlobalKey(),
//   };

//   test(testPage) => Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => testPage,
//       ));

//   bool isOpened = false;

//   final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

//   final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

//   toggleMenu([bool end = false]) {
//     if (end) {
//       final _state = _endSideMenuKey.currentState!;
//       if (_state.isOpened) {
//         _state.closeSideMenu();
//       } else {
//         _state.openSideMenu();
//       }
//     } else {
//       final _state = _sideMenuKey.currentState!;
//       if (_state.isOpened) {
//         _state.closeSideMenu();
//       } else {
//         _state.openSideMenu();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => SideMenu(
//         closeIcon: Icon(
//           Icons.close,
//           color: Colors.black,
//         ),
//         key: _endSideMenuKey,
//         inverse: false,
//         // end side menu
//         background: Colors.white,
//         type: SideMenuType.shrikNRotate,
//         menu: Padding(
//           padding: const EdgeInsets.only(left: 25.0),
//           child: Container(),
//         ),
//         onChange: (_isOpened) {
//           setState(() => isOpened = _isOpened);
//         },
//         child: SideMenu(
//           closeIcon: Icon(
//             Icons.close,
//             color:  Colors.black,
//           ),
//           background:  Colors.white,
//           key: _sideMenuKey,
//           menu: Container(),
//           type: SideMenuType.shrikNRotate,
//           onChange: (_isOpened) {
//             setState(() => isOpened = _isOpened);
//           },
//           child: IgnorePointer(
//             ignoring: isOpened,
//             child: Scaffold(
//               resizeToAvoidBottomInset: false,
//               backgroundColor: Colors.white,
//               appBar: AppBar(
//                 // backgroundColor: themeController.isLightTheme.value
//                 //     ? selectedIndex == 0
//                 //         ? ColorResources.white1
//                 //         : ColorResources.white
//                 //     : ColorResources.black4,
//                 automaticallyImplyLeading: false,
//                 centerTitle: true,
//                 elevation: 0,
//                 leading:
//                     // drawerButton(),
//                     Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child:
//                       //Obx(() =>
//                       InkWell(
//                     onTap: () {
//                       toggleMenu();
//                     },
//                     child: Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: themeController.isLightTheme.value
//                             ? ColorResources.white
//                             : ColorResources.black6,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: SvgPicture.asset(
//                           Images.drawericon,
//                           color: themeController.isLightTheme.value
//                               ? ColorResources.black2
//                               : ColorResources.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   //),
//                 ),
//                 title: selectedIndex == 0
//                     ? Padding(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Delivery to ",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontFamily: TextFontFamily.SEN_REGULAR,
//                                     color: themeController.isLightTheme.value
//                                         ? ColorResources.black2
//                                         : ColorResources.white,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.keyboard_arrow_down,
//                                   size: 12,
//                                   color: themeController.isLightTheme.value
//                                       ? ColorResources.black2
//                                       : ColorResources.white,
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               "lekki phase 1, Estate",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontFamily: TextFontFamily.SEN_REGULAR,
//                                 color: ColorResources.orange,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : selectedIndex == 1
//                         ? Text(
//                             "Favorite",
//                             style: TextStyle(
//                               fontFamily: TextFontFamily.SEN_BOLD,
//                               fontSize: 22,
//                               color: themeController.isLightTheme.value
//                                   ? ColorResources.black2
//                                   : ColorResources.white,
//                             ),
//                           )
//                         : selectedIndex == 2
//                             ? Text(
//                                 "Search",
//                                 style: TextStyle(
//                                   fontFamily: TextFontFamily.SEN_BOLD,
//                                   fontSize: 22,
//                                   color: themeController.isLightTheme.value
//                                       ? ColorResources.black2
//                                       : ColorResources.white,
//                                 ),
//                               )
//                             : selectedIndex == 3
//                                 ? Text(
//                                     "Category Brand",
//                                     style: TextStyle(
//                                       fontFamily: TextFontFamily.SEN_BOLD,
//                                       fontSize: 22,
//                                       color: themeController.isLightTheme.value
//                                           ? ColorResources.black2
//                                           : ColorResources.white,
//                                     ),
//                                   )
//                                 : selectedIndex == 4
//                                     ? Text(
//                                         "Cart",
//                                         style: TextStyle(
//                                           fontFamily: TextFontFamily.SEN_BOLD,
//                                           fontSize: 22,
//                                           color:
//                                               themeController.isLightTheme.value
//                                                   ? ColorResources.black2
//                                                   : ColorResources.white,
//                                         ),
//                                       )
//                                     : Container(),
//                 actions: [
//                   selectedIndex == 0 || selectedIndex == 1 || selectedIndex == 4
//                       ? Padding(
//                           padding: const EdgeInsets.only(top: 10, right: 8),
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: themeController.isLightTheme.value
//                                   ? ColorResources.white
//                                   : ColorResources.black6,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(10),
//                               child: InkWell(
//                                 onTap: () {
//                                   Get.off(NotificationScreen());
//                                 },
//                                 child: SvgPicture.asset(
//                                   Images.notification,
//                                   color: themeController.isLightTheme.value
//                                       ? ColorResources.white3
//                                       : ColorResources.white.withOpacity(0.6),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       : selectedIndex == 2
//                           ? Container()
//                           : selectedIndex == 3
//                               ? Padding(
//                                   padding: const EdgeInsets.only(right: 25),
//                                   child: InkWell(
//                                     onTap: () {
//                                       Get.off(SubSearchScreen());
//                                     },
//                                     child: SvgPicture.asset(
//                                       Images.search,
//                                       color: themeController.isLightTheme.value
//                                           ? ColorResources.white3
//                                           : ColorResources.white
//                                               .withOpacity(0.6),
//                                     ),
//                                   ),
//                                 )
//                               : Container(),
//                 ],
//               ),
           
          
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
