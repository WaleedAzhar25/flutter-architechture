import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  const MyCustomAppBar({
    Key key,
    this.receiverId,
    this.receiverAvatar,
    this.receiverName,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> _simpleChoice = ["Create shortcut", "Clear chat"];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 25, 4, 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Theme.of(context).primaryColorDark,
              Theme.of(context).primaryColor
            ]),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(MdiIcons.chevronLeft, color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.only(left: 8),
            child: receiverAvatar.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: receiverAvatar,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF003a54),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.asset(
                      'assets/images/defaultavatar.png',
                      width: 40,
                    ),
                  ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receiverName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "Online",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 4.0),
                    child: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return _simpleChoice.map((String choice) {
                          return PopupMenuItem(
                            value: choice,
                            child: Text(choice,
                                style: Theme.of(context).textTheme.bodyText2),
                          );
                        }).toList();
                      },
                      color: Theme.of(context).dialogTheme.backgroundColor,
                      icon: Icon(
                        MdiIcons.dotsVertical,
                        color: Theme.of(context).appBarTheme.iconTheme.color,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
