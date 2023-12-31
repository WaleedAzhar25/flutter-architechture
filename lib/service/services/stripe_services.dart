// import 'package:flutter/material.dart';

// import 'package:sixam_mart/service/main.dart';
// import 'package:sixam_mart/service/model/booking_detail_model.dart';
// import 'package:sixam_mart/service/model/stripe_pay_model.dart';
// import 'package:sixam_mart/service/network/network_utils.dart';
// import 'package:sixam_mart/service/services/razor_pay_services.dart';
// import 'package:sixam_mart/service/utils/colors.dart';
// import 'package:sixam_mart/service/utils/common.dart';
// import 'package:sixam_mart/service/utils/configs.dart';
// import 'package:sixam_mart/service/utils/constant.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:nb_utils/nb_utils.dart';

// class StripeServices {
//   static BookingDetailResponse bookDetailData;
//   num totalAmount = 0;
//   String stripeURL = "";
//   String stripePaymentKey = "";
//   bool isTest = false;

//   init({
//     @required String stripePaymentPublishKey,
//     @required BookingDetailResponse data,
//     @required num totalAmount,
//     @required String stripeURL,
//     @required String stripePaymentKey,
//     @required bool isTest,
//   }) async {
//     Stripe.publishableKey = stripePaymentPublishKey;
//     Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';

//     await Stripe.instance.applySettings().catchError((e) {
//       toast(e.toString(), print: true);

//       throw e.toString();
//     });

//     bookDetailData = data;
//     this.totalAmount = totalAmount;
//     this.stripeURL = stripeURL;
//     this.stripePaymentKey = stripePaymentKey;
//     this.isTest = isTest;
//   }

//   //StripPayment
//   void stripePay() async {
//     Request request = http.Request(HttpMethod.POST.name, Uri.parse(stripeURL));

//     request.bodyFields = {
//       'amount': '${(totalAmount.toInt() * 100)}',
//       'currency':
//           isIqonicProduct ? STRIPE_CURRENCY_CODE : '${appStore.currencyCode}',
//       'description':
//           'Name: ${appStore.userFullName} - Email: ${appStore.userEmail}',
//     };

//     request.headers.addAll(buildHeaderTokens(
//         isStripePayment: true, stripeKeyPayment: stripePaymentKey));

//     appStore.setLoading(true);

//     await request.send().then((value) {
//       appStore.setLoading(false);

//       http.Response.fromStream(value).then((response) async {
//         if (response.statusCode.isSuccessful()) {
//           StripePayModel res =
//               StripePayModel.fromJson(await handleResponse(response));

//           SetupPaymentSheetParameters setupPaymentSheetParameters =
//               SetupPaymentSheetParameters(
//             paymentIntentClientSecret: res.clientSecret.validate(),
//             style: appThemeMode,
//             appearance: PaymentSheetAppearance(
//                 colors: PaymentSheetAppearanceColors(primary: primaryColor)),
//             applePay: PaymentSheetApplePay(
//                 merchantCountryCode: STRIPE_MERCHANT_COUNTRY_CODE),
//             googlePay: PaymentSheetGooglePay(
//                 merchantCountryCode: STRIPE_MERCHANT_COUNTRY_CODE,
//                 testEnv: isTest),
//             merchantDisplayName: APP_NAME,
//             customerId: appStore.userId.toString(),
//             customerEphemeralKeySecret:
//                 isAndroid ? res.clientSecret.validate() : null,
//             setupIntentClientSecret: res.clientSecret.validate(),
//             billingDetails: BillingDetails(
//                 name: appStore.userFullName, email: appStore.userEmail),
//           );

//           await Stripe.instance
//               .initPaymentSheet(
//                   paymentSheetParameters: setupPaymentSheetParameters)
//               .then((value) async {
//             await Stripe.instance.presentPaymentSheet().then((value) async {
//               //await Stripe.instance.confirmPaymentSheetPayment();
//               ///
//               await savePay(
//                   paymentMethod: PAYMENT_METHOD_STRIPE,
//                   paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
//                   data: bookDetailData,
//                   totalAmount: totalAmount);
//             });
//           });
//         } else if (response.statusCode == 400) {
//           toast(errorSomethingWentWrong);
//         }
//       });
//     }).catchError((e) {
//       log(e);
//       appStore.setLoading(false);
//       toast(e.toString(), print: true);

//       throw e.toString();
//     });
//   }
// }

// StripeServices stripeServices = StripeServices();
