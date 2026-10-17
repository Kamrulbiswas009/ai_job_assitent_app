import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SpShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const SpShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  static const Color defaultBaseColor = Color(0xFFE5E5EA);
  static const Color defaultHighlightColor = Color(0xFFF8F8FA);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? defaultBaseColor,
      highlightColor: highlightColor ?? defaultHighlightColor,
      child: child,
    );
  }

  /// Convenience factory for a rectangular shimmer block
  static Widget box({
    required double width,
    required double height,
    double borderRadius = 8.0,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return SpShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor ?? defaultBaseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Convenience factory for a circular shimmer block
  static Widget circle({
    required double size,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return SpShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: baseColor ?? defaultBaseColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
