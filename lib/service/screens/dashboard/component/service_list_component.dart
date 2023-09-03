import 'package:sixam_mart/service/component/view_all_label_component.dart';
import 'package:sixam_mart/service/main.dart';
import 'package:sixam_mart/service/model/service_data_model.dart';
import 'package:sixam_mart/service/screens/service/component/service_component.dart';
import 'package:sixam_mart/service/screens/service/search_list_screen.dart';
import 'package:sixam_mart/service/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListComponent extends StatelessWidget {
  final List<ServiceData> serviceList;

  ServiceListComponent({@required this.serviceList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        ViewAllLabel(
          label: language.service,
          list: serviceList,
          onTap: () {
            SearchListScreen().launch(context);
          },
        ).paddingSymmetric(horizontal: 16),
        8.height,
        serviceList.isNotEmpty
            ? Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(serviceList.length, (index) {
                  return ServiceComponent(serviceData: serviceList[index], width: context.width() / 2 - 26);
                }),
              ).paddingSymmetric(horizontal: 16, vertical: 8)
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  children: [
                    Image.asset(notDataFoundImg, height: 126),
                    32.height,
                    Text(language.lblNoServicesFound, style: boldTextStyle()),
                  ],
                ),
              ).center(),
      ],
    );
  }
}
