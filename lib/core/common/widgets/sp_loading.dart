import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../utils/constants/image_path.dart';

class SpLoading extends StatelessWidget {
  final double size;

  const SpLoading({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      ImagePath.loadingLottie,
      width: size,
      height: size,
      fit: BoxFit.contain,
      repeat: true,
      animate: true,
    );
  }
}
