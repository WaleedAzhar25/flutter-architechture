import 'package:sixam_mart/service/component/price_widget.dart';
import 'package:sixam_mart/service/main.dart';
import 'package:sixam_mart/service/model/booking_data_model.dart';
import 'package:sixam_mart/service/model/package_data_model.dart';
import 'package:sixam_mart/service/model/service_data_model.dart';
import 'package:sixam_mart/service/model/service_detail_response.dart';
import 'package:sixam_mart/service/utils/colors.dart';
import 'package:sixam_mart/service/utils/common.dart';
import 'package:sixam_mart/service/utils/constant.dart';
import 'package:sixam_mart/service/utils/images.dart';
import 'package:sixam_mart/service/utils/model_keys.dart';
import 'package:sixam_mart/service/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:sixam_mart/service/screens/payment/component/payment_info_component.dart';

class PriceCommonWidget extends StatelessWidget {
  final BookingData bookingDetail;
  final ServiceData serviceDetail;
  final List<TaxData> taxes;
  final CouponData couponData;
  final BookingPackage bookingPackage;

  const PriceCommonWidget({
    Key key,
    @required this.bookingDetail,
    @required this.serviceDetail,
    @required this.taxes,
    @required this.couponData,
    @required this.bookingPackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (serviceDetail.isFreeService) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text(language.priceDetail, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        16.height,
        if (bookingPackage != null)
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(language.totalAmount,
                            style: secondaryTextStyle(size: 16))
                        .expand(),
                    PriceWidget(
                        price: bookingDetail.amount.validate(),
                        color: primaryColor,
                        size: 18),
                  ],
                ),
              ],
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(language.lblPrice, style: secondaryTextStyle(size: 16))
                        .expand(),
                    16.width,
                    PriceWidget(
                        price: bookingDetail.amount.validate(),
                        size: 18,
                        color: textPrimaryColorGlobal,
                        isBoldText: true),
                  ],
                ),
                if (!serviceDetail.isHourlyService)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 26),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language.lblSubTotal,
                                  style: secondaryTextStyle(size: 16))
                              .flexible(fit: FlexFit.loose),
                          Marquee(
                            child: Row(
                              children: [
                                PriceWidget(
                                    price: bookingDetail.amount.validate(),
                                    size: 18,
                                    isBoldText: false,
                                    color: appTextSecondaryColor),
                                Text(
                                    ' * ${bookingDetail.quantity != 0 ? bookingDetail.quantity : 1}  = '),
                                PriceWidget(
                                    price: bookingDetail.amount.validate(),
                                    size: 18,
                                    isBoldText: true,
                                    color: textPrimaryColorGlobal),
                              ],
                            ),
                          ).flexible(flex: 2),
                        ],
                      ),
                    ],
                  ),
                if (serviceDetail.taxAmount.validate() != 0)
                  Column(
                    children: [
                      Divider(height: 26),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language.lblTax,
                              style: secondaryTextStyle(size: 16)),
                          16.width,
                          PriceWidget(
                              price: serviceDetail.taxAmount,
                              size: 18,
                              color: Colors.red,
                              isBoldText: true),
                        ],
                      ),
                    ],
                  ),
                if (serviceDetail.discountPrice.validate() != 0)
                  Column(
                    children: [
                      Divider(height: 26),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: language.lblDiscount,
                                style: secondaryTextStyle(size: 16)),
                            TextSpan(
                              text:
                                  " (${serviceDetail.discount.validate()}% ${language.lblOff.toLowerCase()}) ",
                              style: boldTextStyle(color: Colors.green),
                            ),
                          ])).expand(),
                          16.width,
                          PriceWidget(
                            price: serviceDetail.discountPrice.validate(),
                            size: 18,
                            color: Colors.green,
                            isBoldText: true,
                            isDiscountedPrice: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                if (couponData != null)
                  Column(
                    children: [
                      Divider(height: 26),
                      Row(
                        children: [
                          Text(language.lblCoupon,
                              style: secondaryTextStyle(size: 16)),
                          Text(" (${couponData.code})",
                                  style: secondaryTextStyle(
                                      size: 16, color: primaryColor))
                              .expand(),
                          PriceWidget(
                              price:
                                  serviceDetail.couponDiscountAmount.validate(),
                              size: 18,
                              color: Colors.green,
                              isBoldText: true,
                              isDiscountedPrice: true),
                        ],
                      ),
                    ],
                  ),
                if (bookingDetail.extraCharges.validate().isNotEmpty)
                  Divider(height: 26),
                if (bookingDetail.extraCharges.validate().isNotEmpty)
                  if (bookingDetail.extraCharges != null)
                    Row(
                      children: [
                        Text(language.lblTotalExtraCharges,
                                style: secondaryTextStyle(size: 16))
                            .expand(),
                        PriceWidget(
                            price: bookingDetail.extraCharges
                                .sumByDouble((e) => e.total.validate()),
                            color: textPrimaryColorGlobal,
                            size: 18),
                      ],
                    ),
                Divider(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextIcon(
                      text: '${language.totalAmount}',
                      textStyle: secondaryTextStyle(size: 16),
                      edgeInsets: EdgeInsets.zero,
                      suffix: bookingDetail.extraCharges.validate().isNotEmpty
                          ? ic_info
                              .iconImage(size: 16)
                              .withTooltip(msg: language.withExtraCharge)
                          : Offstage(),
                      expandedText: true,
                      maxLine: 2,
                      onTap: () {
                        if (bookingDetail.extraCharges.validate().isNotEmpty) {
                          toast(language.withExtraCharge);
                        }
                      },
                    ).expand(flex: 2),
                    Marquee(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          16.width,
                          if (bookingDetail.isHourlyService)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('('),
                                PriceWidget(
                                    price: bookingDetail.price.validate(),
                                    color: appTextSecondaryColor,
                                    size: 14,
                                    isBoldText: false,
                                    decimalPoint: 0),
                                Text('/${language.lblHr})',
                                    style: secondaryTextStyle()),
                              ],
                            ),
                          8.width,
                          PriceWidget(
                              price: getTotalValue,
                              color: primaryColor,
                              size: 18)
                        ],
                      ),
                    ).flexible(flex: 3),
                  ],
                ),
                if (serviceDetail.isAdvancePayment) Divider(height: 26),
                if (serviceDetail.isAdvancePayment)
                  Row(
                    children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: language.advancePayment,
                            style: secondaryTextStyle(size: 16)),
                        TextSpan(
                          text:
                              " (${serviceDetail.advancePaymentPercentage.validate().toString()}%)  ",
                          style: boldTextStyle(color: Colors.green),
                        ),
                      ])).expand(),
                      PriceWidget(
                          price: getAdvancePaymentAmount,
                          color: primaryColor,
                          size: 18),
                    ],
                  ),
                if (serviceDetail.isAdvancePayment) Divider(height: 26),
                if (serviceDetail.isAdvancePayment)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextIcon(
                        text: '${language.remainingAmount}',
                        textStyle: secondaryTextStyle(size: 16),
                        edgeInsets: EdgeInsets.zero,
                        suffix: ic_info.iconImage(size: 16).withTooltip(
                            msg: language.withExtraAndAdvanceCharge),
                        expandedText: true,
                        maxLine: 3,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return PaymentInfoComponent(bookingDetail.id);
                            },
                          );
                        },
                      ).expand(),
                      8.width,
                      bookingDetail.status == BookingStatusKeys.complete &&
                              bookingDetail.paymentStatus ==
                                  SERVICE_PAYMENT_STATUS_PAID
                          ? PriceWidget(price: 0, color: primaryColor, size: 18)
                          : PriceWidget(
                              price: getRemainingAmount,
                              color: primaryColor,
                              size: 18),
                    ],
                  ),
                if (bookingDetail.isHourlyService &&
                    bookingDetail.status == BookingStatusKeys.complete)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        6.height,
                        Text(
                          "${language.lblOnBase} ${calculateTimer(bookingDetail.durationDiff.validate().toInt())} ${getMinHour(durationDiff: bookingDetail.durationDiff.validate())}",
                          style: secondaryTextStyle(),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
      ],
    );
  }

  num get getTotalValue {
    num totalAmount = calculateTotalAmount(
      serviceDiscountPercent: serviceDetail.discount.validate(),
      qty: bookingDetail.quantity.validate(value: 1).toInt(),
      detail: serviceDetail,
      servicePrice: bookingDetail.amount.validate(),
      taxes: taxes,
      couponData: couponData,
      extraCharges: bookingDetail.extraCharges.validate(),
    );

    if (bookingDetail.isHourlyService &&
        bookingDetail.status == BookingStatusKeys.complete) {
      return calculateTotalAmount(
        serviceDiscountPercent: serviceDetail.discount.validate(),
        qty: bookingDetail.quantity.validate(value: 1).toInt(),
        detail: serviceDetail,
        servicePrice: getHourlyPrice(
          price: bookingDetail.amount.validate(),
          secTime: bookingDetail.durationDiff.validate().toInt(),
          date: bookingDetail.date.validate(),
        ),
        taxes: taxes,
        couponData: couponData,
        extraCharges: bookingDetail.extraCharges.validate(),
      );
    }

    return totalAmount;
  }

  num get getAdvancePaymentAmount {
    if (bookingDetail.paidAmount.validate() != 0) {
      return bookingDetail.paidAmount;
    } else {
      return serviceDetail.totalAmount.validate() *
          serviceDetail.advancePaymentPercentage.validate() /
          100;
    }
  }

  num get getRemainingAmount {
    return serviceDetail.totalAmount - getAdvancePaymentAmount;
  }

  String getMinHour({@required String durationDiff}) {
    String totalTime = calculateTimer(durationDiff.toInt());
    List<String> totalHours = totalTime.split(":");
    if (totalHours.first == "00") {
      return language.min;
    } else {
      return language.hour;
    }
  }
}
