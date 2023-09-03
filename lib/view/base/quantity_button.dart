import 'package:sixam_mart/util/colors.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final Function onTap;
  QuantityButton({@required this.isIncrement, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 47,
        width: 47,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              width: 1,
              color: isIncrement
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor),
          color: isIncrement
              ? ColorResources.blue1
              : ColorResources.blue1.withOpacity(0.5),
        ),
        alignment: Alignment.center,
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          size: 15,
          color: ColorResources.white,
        ),
      ),
    );
  }
}
