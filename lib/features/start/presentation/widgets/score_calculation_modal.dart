import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_loading.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';

class ScoreCalculationModal extends StatefulWidget {
  final VoidCallback onComplete;
  final Duration totalDuration;

  const ScoreCalculationModal({
    super.key,
    required this.onComplete,
    this.totalDuration = const Duration(milliseconds: 3200),
  });

  @override
  State<ScoreCalculationModal> createState() => _ScoreCalculationModalState();
}

class _CalcStep {
  const _CalcStep({
    required this.title,
    required this.subtitle,
    required this.thoughts,
  });

  final String title;
  final String subtitle;
  final List<String> thoughts;
}

class _ScoreCalculationModalState extends State<ScoreCalculationModal>
    with TickerProviderStateMixin {
  static const _tick = Duration(milliseconds: 40);
  static const _stepBounds = [0.0, 0.25, 0.50, 0.75, 1.0];
  static const _steps = [
    _CalcStep(
      title: 'Analyzing your voice',
      subtitle: 'Transcribing what you said and how you said it',
      thoughts: [
        'Listening to your recording…',
        'Transcribing what you said…',
        'Picking up tone and emphasis…',
      ],
    ),
    _CalcStep(
      title: 'Measuring your delivery',
      subtitle: 'Pace, filler words, and pauses',
      thoughts: [
        'Checking pace and pauses…',
        'Noticing filler words…',
        'Measuring how clearly it landed…',
      ],
    ),
    _CalcStep(
      title: 'Comparing with your self assessment',
      subtitle: 'Blending what we heard with what you rated yourself',
      thoughts: [
        'Matching this to your self-rating…',
        'Looking for gaps worth coaching…',
        'Blending what we heard with how you scored yourself…',
      ],
    ),
    _CalcStep(
      title: 'Calculating your Influence Score',
      subtitle: 'Final result ready',
      thoughts: [
        'Putting the score together…',
        'Weighting voice, delivery, and self-view…',
        'Almost ready — locking in your result…',
      ],
    ),
  ];

  int _currentStep = 0;
  double _progress = 0.0;
  bool _didFinish = false;
  int _thoughtIndex = 0;
  Timer? _progressTimer;
  Timer? _thoughtTimer;
  Timer? _timerDone;

  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _startProgress();
    _startThoughtCycle();
  }

  void _startThoughtCycle() {
    _thoughtTimer = Timer.periodic(const Duration(milliseconds: 2200), (_) {
      if (!mounted || _didFinish) return;
      final thoughts = _steps[_currentStep.clamp(0, _steps.length - 1)].thoughts;
      setState(() {
        _thoughtIndex = (_thoughtIndex + 1) % thoughts.length;
      });
    });
  }

  void _startProgress() {
    _progress = 0.0;
    _currentStep = 0;

    final totalTicks =
        (widget.totalDuration.inMilliseconds / _tick.inMilliseconds)
            .clamp(20, 300)
            .toDouble();
    final increment = 1.0 / totalTicks;

    _progressTimer = Timer.periodic(_tick, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _progress = (_progress + increment).clamp(0.0, 1.0);
        _syncStep();
        if (_progress >= 1.0) {
          _completeSequence();
        }
      });
    });
  }

  void _syncStep() {
    if (_progress >= 1.0) {
      _currentStep = 4;
    } else if (_progress >= 0.75) {
      _currentStep = 3;
    } else if (_progress >= 0.50) {
      _currentStep = 2;
    } else if (_progress >= 0.25) {
      _currentStep = 1;
    } else {
      _currentStep = 0;
    }
  }

  void _completeSequence() {
    if (_didFinish) return;
    _didFinish = true;
    _progressTimer?.cancel();
    _thoughtTimer?.cancel();
    _currentStep = 4;
    _timerDone = Timer(const Duration(milliseconds: 700), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _thoughtTimer?.cancel();
    _timerDone?.cancel();
    _pulseController.dispose();
    _shimmerController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  String get _headline {
    if (_progress >= 1.0) return 'Your score is ready';
    if (_currentStep >= 3) return 'Locking in your Influence Score';
    return 'Calculating your score';
  }

  String get _liveThought {
    if (_progress >= 1.0) {
      return 'Your Influence Score is ready to review.';
    }
    final step = _steps[_currentStep.clamp(0, _steps.length - 1)];
    return step.thoughts[_thoughtIndex % step.thoughts.length];
  }

  double _stepFill(int step) {
    final start = _stepBounds[step];
    final end = _stepBounds[step + 1];
    if (_progress >= end) return 1;
    if (_progress <= start) return 0;
    return ((_progress - start) / (end - start)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final percentInt = (_progress * 100).toInt().clamp(0, 100);

    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: SafeArea(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            final clamped = value.clamp(0.0, 1.0);
            return Opacity(
              opacity: clamped,
              child: Transform.scale(
                scale: 0.88 + (0.12 * clamped),
                child: child,
              ),
            );
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 380.w),
                padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 20.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBadge(),
                    SizedBox(height: 14.h),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: Text(
                        _headline,
                        key: ValueKey(_headline),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18.5.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pureBlack,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      child: Text(
                        _liveThought,
                        key: ValueKey(_liveThought),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF555555),
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    if (_progress < 1.0) ...[
                      _buildVoiceBars(),
                      SizedBox(height: 16.h),
                    ],
                    _buildProgressBlock(percentInt),
                    SizedBox(height: 18.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CALCULATION STEPS',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    for (var i = 0; i < _steps.length; i++) ...[
                      _buildStepCard(
                        step: _steps[i],
                        fill: _stepFill(i),
                        isComplete: _currentStep > i || _progress >= 1.0,
                        isActive: _currentStep == i && _progress < 1.0,
                      ),
                      if (i < _steps.length - 1) SizedBox(height: 8.h),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    final done = _progress >= 1.0;
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = done ? 1.0 : 1.0 + (_pulseController.value * 0.06);
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 64.r,
        height: 64.r,
        decoration: BoxDecoration(
          color: done ? AppColors.lightContainer : AppColors.primarySoft,
          shape: BoxShape.circle,
          border: Border.all(
            color: done ? const Color(0xFFC8E6C9) : AppColors.primaryTint,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: done
            ? Icon(
                Icons.check_rounded,
                size: 30.r,
                color: const Color(0xFF1F9D4A),
              )
            : SvgPicture.asset(
                IconPath.spMicSvg,
                width: 26.r,
                height: 26.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
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

  Widget _buildProgressBlock(int percentInt) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEBEBEF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                _progress >= 1.0
                    ? 'ALL STEPS COMPLETE'
                    : 'STEP ${(_currentStep + 1).clamp(1, 4)} OF 4',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFF8E8E93),
                ),
              ),
              const Spacer(),
              Text(
                '$percentInt%',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: _progress >= 1.0
                      ? const Color(0xFF1F9D4A)
                      : AppColors.pureBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final fill = width * _progress.clamp(0.0, 1.0);
              return ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: SizedBox(
                  height: 8.h,
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
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        curve: Curves.easeOut,
                        width: fill,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                      if (_progress < 1.0)
                        AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, _) {
                            final slide =
                                (width + 72.w) * _shimmerController.value;
                            return Transform.translate(
                              offset: Offset(slide - 72.w, 0),
                              child: Container(
                                width: 72.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withValues(alpha: 0),
                                      Colors.white.withValues(alpha: 0.55),
                                      Colors.white.withValues(alpha: 0),
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
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required _CalcStep step,
    required double fill,
    required bool isComplete,
    required bool isActive,
  }) {
    final Color bg;
    final Color border;
    if (isComplete) {
      bg = AppColors.lightContainer;
      border = const Color(0xFFC8E6C9);
    } else if (isActive) {
      bg = AppColors.primarySoft;
      border = AppColors.primaryTint;
    } else {
      bg = const Color(0xFFF9F9FB);
      border = const Color(0xFFEBEBEF);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepBadge(isComplete: isComplete, isActive: isActive),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pureBlack,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  isActive ? _liveThought : step.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                    color: const Color(0xFF666666),
                  ),
                ),
                if (isComplete) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'Completed',
                    style: GoogleFonts.inter(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F9D4A),
                    ),
                  ),
                ] else if (isActive) ...[
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999.r),
                    child: LinearProgressIndicator(
                      value: fill.clamp(0.08, 1.0),
                      minHeight: 4.h,
                      backgroundColor: AppColors.primaryTint,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Calculating...',
                    style: GoogleFonts.inter(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepBadge({
    required bool isComplete,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 26.r,
      height: 26.r,
      decoration: BoxDecoration(
        color: isComplete
            ? const Color(0xFFD8F3E0)
            : (isActive ? AppColors.primaryTint : const Color(0xFFEFEFF4)),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: isComplete
          ? Icon(
              Icons.check_rounded,
              size: 15.r,
              color: const Color(0xFF1F9D4A),
            )
          : isActive
              ? const SpLoading(size: 18)
              : Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC7C7CC),
                    shape: BoxShape.circle,
                  ),
                ),
    );
  }
}
