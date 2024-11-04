import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  const SvgLogo({
    super.key,
    this.height,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      height: height,
      width: width,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
