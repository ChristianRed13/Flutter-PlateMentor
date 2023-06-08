import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.horizontalEdge,
    this.icon,
    this.edge,
  });

  final VoidCallback onTap;
  final String text;
  final double horizontalEdge;
  final Icon? icon;
  final EdgeInsetsGeometry? edge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalEdge),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColorLight,
        child: InkWell(
          splashColor: Colors.green.shade900,
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: edge ?? EdgeInsets.all(20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (icon != null) SizedBox(width: 10),
                  if (icon != null) icon!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
