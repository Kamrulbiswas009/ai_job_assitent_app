import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants/colors.dart';
import 'sp_loading.dart';

class SpLoadingOverlay {
  SpLoadingOverlay._();

  static OverlayEntry? _entry;

  static bool get isShowing => _entry != null;

  static void show({
    String title = 'Just a moment',
    String? message,
    List<String>? thoughts,
  }) {
    hide();
    final context = Get.overlayContext ?? Get.context;
    if (context == null) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (_) => _SpLoadingOverlayCard(
        title: title,
        message: message,
        thoughts: thoughts ??
            const [
              'This usually takes a few seconds…',
              'Still working on it…',
              'Almost there…',
            ],
      ),
    );
    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _SpLoadingOverlayCard extends StatefulWidget {
  final String title;
  final String? message;
  final List<String> thoughts;

  const _SpLoadingOverlayCard({
    required this.title,
    required this.message,
    required this.thoughts,
  });

  @override
  State<_SpLoadingOverlayCard> createState() => _SpLoadingOverlayCardState();
}

class _SpLoadingOverlayCardState extends State<_SpLoadingOverlayCard>
    with TickerProviderStateMixin {
  int _thoughtIndex = 0;
  Timer? _thoughtTimer;
  late final AnimationController _waveController;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _thoughtTimer = Timer.periodic(const Duration(milliseconds: 2200), (_) {
      if (!mounted || widget.thoughts.isEmpty) return;
      setState(() {
        _thoughtIndex = (_thoughtIndex + 1) % widget.thoughts.length;
      });
    });
  }

  @override
  void dispose() {
    _thoughtTimer?.cancel();
    _waveController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  String get _thought {
    if (widget.message != null && widget.message!.trim().isNotEmpty) {
      return widget.message!;
    }
    if (widget.thoughts.isEmpty) return 'Working…';
    return widget.thoughts[_thoughtIndex % widget.thoughts.length];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      child: SafeArea(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 340),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              final clamped = value.clamp(0.0, 1.0);
              return Opacity(
                opacity: clamped,
                child: Transform.scale(
                  scale: 0.86 + (0.14 * clamped),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 340.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(22.w, 26.h, 22.w, 22.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SpLoading(size: 128),
                      SizedBox(height: 8.h),
                      _buildVoiceBars(),
                      SizedBox(height: 16.h),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pureBlack,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        child: Text(
                          _thought,
                          key: ValueKey(_thought),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: const Color(0xFF555555),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      _buildShimmerBar(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceBars() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final wave = (math.sin(
                      (_waveController.value * 2 * math.pi) + (i * 0.85),
                    ) +
                    1) /
                2;
            return Container(
              width: 4.w,
              height: (10 + wave * 16).h,
              margin: EdgeInsets.symmetric(horizontal: 2.5.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.45 + wave * 0.55),
                borderRadius: BorderRadius.circular(99.r),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildShimmerBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: SizedBox(
            height: 6.h,
            width: width,
            child: Stack(
              children: [
                Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEEEF),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, _) {
                    final slide = (width + 80.w) * _shimmerController.value;
                    return Transform.translate(
                      offset: Offset(slide - 80.w, 0),
                      child: Container(
                        width: 80.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0),
                              AppColors.primary.withValues(alpha: 0.55),
                              AppColors.primary.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
