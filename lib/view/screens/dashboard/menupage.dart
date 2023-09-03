import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../util/images.dart';

class MenuPage extends GetView {
  MenuPage({Key key}) : super(key: key);

  InkWell inkwell(String image, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SvgPicture.asset(image),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: AssetImage(Images.drawericon),
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(height: 12),
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Johndoe@gmail.com",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40),
                inkwell(Images.drawericon, "My profile", () {}),
                inkwell(Images.drawericon, "Language", () {}),
                inkwell(Images.drawericon, "All Categories", () {}),
                inkwell(Images.drawericon, "My Order", () {}),
                inkwell(Images.drawericon, "Settings", () {}),
                inkwell(Images.drawericon, "About Us", () {}),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
