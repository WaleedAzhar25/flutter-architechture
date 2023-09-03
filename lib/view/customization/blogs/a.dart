import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/view/base/custom_button.dart';

class MyDetails extends StatefulWidget {
  const MyDetails({Key key}) : super(key: key);

  @override
  State<MyDetails> createState() => _MyDetailsState();
}

class _MyDetailsState extends State<MyDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedScrollView(
              padding: EdgeInsets.only(bottom: 120),
              listAnimationType: ListAnimationType.FadeIn,
              children: [
                // ServiceDetailHeaderComponent(
                //     serviceDetail: snap.data!.serviceDetail!),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // snap.data!.serviceDetail!.providerId.toString() ==
                          //         appStore.userId.toString()
                          //     ? SizedBox()
                          //     :
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () {},
                              color: context.primaryColor,
                              child: Text(
                                'chat',
                              ),
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      8.height,
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(language.hintDescription,
                      //         style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      //     if (snap.data!.serviceDetail!.categoryName ==
                      //         'Компания')
                      //       snap.data!.serviceDetail!.providerId.toString() !=
                      //               appStore.userId.toString()
                      //           ? SizedBox()
                      //           : Container(
                      //               margin: const EdgeInsets.symmetric(
                      //                   horizontal: 10),
                      //               child: MaterialButton(
                      //                 shape: RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(5)),
                      //                 onPressed: () {
                      //                   Navigator.push(
                      //                       context,
                      //                       MaterialPageRoute(
                      //                           builder: (ctx) =>
                      //                               AddEmployeeScreen()));
                      //                 },
                      //                 color: context.primaryColor,
                      //                 child: Text(
                      //                   language.lblAddEmployeeBtn,
                      //                 ),
                      //                 textColor: Colors.white,
                      //               ),
                      //             ),
                      //   ],
                      // ),
                      // 8.height,
                      // snap.data!.serviceDetail!.description
                      //         .validate()
                      //         .isNotEmpty
                      //     ? ReadMoreText(
                      //         snap.data!.serviceDetail!.description.validate(),
                      //         style: secondaryTextStyle(),
                      //       )
                      //     : Text(language.lblNotDescription,
                      //         style: secondaryTextStyle()),
                    ],
                  ).paddingAll(16),
                ),
              ]),
          Positioned(
            bottom: 16,
            left: 16,
            right: Get.width * 0.33,
            child: CustomButton(
              onPressed: () {
                // if (appStore.isLoggedIn) {
                //   snap.data!.serviceDetail!.bookingAddressId =
                //       selectedBookingAddressId;
                //   BookServiceScreen(data: snap.data!)
                //       .launch(context)
                //       .then((value) {
                //     setStatusBarColor(transparentColor);
                //   });
                // } else {
                //   SignInScreen(isFromServiceBooking: true)
                //       .launch(context)
                //       .then((value) {
                //     snap.data!.serviceDetail!.bookingAddressId =
                //         selectedBookingAddressId;
                //     BookServiceScreen(data: snap.data!)
                //         .launch(context)
                //         .then((value) {
                //       setStatusBarColor(transparentColor);
                //     });
                //   });
                // }
              },
              // color: context.primaryColor,
              buttonText: 'Book Now',
              width: Get.width,
            ),
          ),
          Positioned(
            bottom: 16,
            left: Get.width * 0.8,
            right: 16,
            child: InkWell(
              onTap: () {
                // launchCall(snap.data!.serviceDetail!.duration
                //     .validate()
                //     .splitBefore(':'));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
