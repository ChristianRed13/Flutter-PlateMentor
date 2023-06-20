import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Plate Mentor',
              style: TextStyle(
                  fontSize: size * 0.8,
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.white,
                      offset: Offset(2, 2),
                    )
                  ]),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: new AssetImage('assets/plate-mentor_logo.png'),
              width: size,
              height: size,
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
            ),
          ],
        )
      ],
    );
  }
}
