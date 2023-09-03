import 'package:sixam_mart/service/component/background_component.dart';
import 'package:sixam_mart/service/component/image_border_component.dart';
import 'package:sixam_mart/service/component/selected_item_widget.dart';
import 'package:sixam_mart/service/main.dart';
import 'package:sixam_mart/service/model/user_data_model.dart';
import 'package:sixam_mart/service/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class FilterProviderComponent extends StatefulWidget {
  final List<UserData> providerList;

  FilterProviderComponent({@required this.providerList});

  @override
  State<FilterProviderComponent> createState() => _FilterProviderComponentState();
}

class _FilterProviderComponentState extends State<FilterProviderComponent> {
  @override
  Widget build(BuildContext context) {
    if (widget.providerList.isEmpty)
      return BackgroundComponent(
        text: language.noProviderFound,
      );

    return AnimatedListView(
      slideConfiguration: sliderConfigurationGlobal,
      itemCount: widget.providerList.length,
      itemBuilder: (context, index) {
        UserData data = widget.providerList[index];

        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              ImageBorder(
                src: data.profileImage.validate(),
                height: 45,
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.displayName.validate(), style: boldTextStyle()),
                  4.height,
                  Text('${language.lblMemberSince} ${DateFormat(YEAR).format(DateTime.parse(data.createdAt.validate()))}', style: secondaryTextStyle(size: 12)),
                ],
              ).expand(),
              SelectedItemWidget(isSelected: data.isSelected),
            ],
          ),
        ).onTap(() {
          if (data.isSelected) {
            data.isSelected = false;
          } else {
            data.isSelected = true;
          }
          setState(() {});
        });
      },
    );
  }
}
