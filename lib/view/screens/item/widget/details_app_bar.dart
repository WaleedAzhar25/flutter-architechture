import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../util/colors.dart';
import '../../../../util/images.dart';

class DetailsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Key key;
  DetailsAppBar({this.key});

  @override
  DetailsAppBarState createState() => DetailsAppBarState();

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}

class DetailsAppBarState extends State<DetailsAppBar>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void shake() {
    controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 15.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

    return AppBar(
      backgroundColor: ColorResources.white6,
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorResources.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 13,
                  color: ColorResources.blue1.withOpacity(0.3),
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back,
                color: ColorResources.black,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'item_details'.tr,
        style: TextStyle(
          fontSize: 22,
          color: ColorResources.black2,
        ),
      ),
      actions: [
        AnimatedBuilder(
          animation: offsetAnimation,
          builder: (buildContext, child) {
            return Container(
              padding: EdgeInsets.only(
                  top: 5,
                  left: offsetAnimation.value + 15.0,
                  right: 15.0 - offsetAnimation.value),
              child: Stack(children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteHelper.getCartRoute());
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: ColorResources.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        Images.cartblank,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child:
                        GetBuilder<CartController>(builder: (cartController) {
                      return Text(
                        cartController.cartList.length.toString(),
                        style: robotoMedium.copyWith(
                            color: Colors.white, fontSize: 8),
                      );
                    }),
                  ),
                ),
              ]),
            );
          },
        ),
      ],
    );
  }
}
