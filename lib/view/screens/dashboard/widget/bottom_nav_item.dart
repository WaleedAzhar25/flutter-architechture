import 'package:flutter/material.dart';
import 'package:sixam_mart/theme/light_theme.dart';

import '../../../../util/colors.dart';

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  final bool isSelected;
  BottomNavItem({@required this.iconData, this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        icon: Icon(iconData,
            color: isSelected ? ColorResources.blue1 : Colors.grey, size: 25),
        onPressed: onTap,
      ),
    );
  }
}
