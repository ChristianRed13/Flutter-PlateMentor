import 'package:flutter/material.dart';

import 'category_circle_item.dart';

class CategoryCard extends StatelessWidget {
  static const double size = 50;
  final VoidCallback onTap;
  final double height;
  final double width;
  final String name;
  final String iconData;
  final Color color;
  final int number;
  const CategoryCard(
      {required this.name,
      required this.iconData,
      required this.color,
      required this.number,
      required this.height,
      required this.width,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              CategoryCircleIcon(
                  margin:
                      EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  size: size,
                  color: color,
                  iconData: iconData),
              // Use Expanded widget to allow text to take up remaining space

              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  textAlign: TextAlign.center,
                  number.toString(),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
