import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

/// SettingItemWidget
class SettingItem extends StatelessWidget {
  final String title;
  final double width;
  final String subTitle;
  final Widget leading;
  final Widget trailing;
  final TextStyle titleTextStyle;
  final TextStyle subTitleTextStyle;
  final Function onTap;
  final EdgeInsets padding;
  final int paddingAfterLeading;
  final int paddingBeforeTrailing;
  final Color titleTextColor;
  final Color subTitleTextColor;
  final Color hoverColor;
  final Color splashColor;
  final Decoration decoration;
  final double borderRadius;
  final BorderRadius radius;

  SettingItem({
    @required this.title,
    this.onTap,
    this.width,
    this.subTitle = '',
    this.leading,
    this.trailing,
    this.titleTextStyle,
    this.subTitleTextStyle,
    this.padding,
    this.paddingAfterLeading = 16,
    this.paddingBeforeTrailing = 16,
    this.titleTextColor,
    this.subTitleTextColor,
    this.decoration,
    this.borderRadius,
    this.hoverColor,
    this.splashColor,
    this.radius,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: decoration ?? BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          leading ?? SizedBox(),
          if (leading != null) paddingAfterLeading.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.validate(),
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              4.height.visible(subTitle.validate().isNotEmpty),
              if (subTitle.validate().isNotEmpty)
                Text(
                  subTitle,
                  style: subTitleTextStyle ??
                      secondaryTextStyle(
                        color: subTitleTextColor ?? textSecondaryColorGlobal,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ).expand(),
          if (trailing != null) paddingBeforeTrailing.width,
          trailing ?? SizedBox(),
        ],
      ),
    ).onTap(
      onTap,
      borderRadius: radius ?? (BorderRadius.circular(borderRadius.validate())),
      hoverColor: hoverColor,
      splashColor: splashColor,
    );
  }
}
