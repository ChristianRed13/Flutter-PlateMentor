import 'package:flutter/material.dart';

class CategoryCircleIcon extends StatelessWidget {
  const CategoryCircleIcon({
    super.key,
    required this.size,
    required this.color,
    required this.iconData,
    this.icon,
    this.margin,
  });

  final double size;
  final Color color;
  final String iconData;
  final IconData? icon;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? null,
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: icon == null
            ? ImageIcon(
                AssetImage(iconData),
                color: Colors.white,
                size: size * 0.7,
              )
            : Icon(
                icon,
                color: Colors.white,
                size: size * 0.7,
              ),
      ),
    );
  }
}
