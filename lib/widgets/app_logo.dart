import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key? key,
    this.width,
    this.height,
    this.transparentVersion = false,
  }) : super(key: key);
  final double? width, height;
  final bool transparentVersion;

  @override
  Widget build(BuildContext context) => width != null && height != null
      ? Image.asset(
          transparentVersion
              ? 'assets/images/icon_transparent.png'
              : 'assets/images/icon.png',
          width: width,
          height: height,
        )
      : Image.asset(
          transparentVersion
              ? 'assets/images/icon_transparent.png'
              : 'assets/images/icon.png',
        );
}
