import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? widgets;

  const CustomAppbar({required this.title, this.widgets});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
          //statusBarColor: Theme.of(context).primaryColorLight,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
      backgroundColor: Theme.of(context).primaryColorLight,
      foregroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(),
      ),
      actions: widgets ?? [],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
