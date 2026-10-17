import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_loading.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';

class BriefingProcessingModal extends StatefulWidget {
  final VoidCallback onComplete;
  final Duration totalDuration;
  final bool? isCompleted;
  final Future<dynamic>? asyncOperation;

  const BriefingProcessingModal({
    super.key,
    required this.onComplete,
    this.totalDuration = const Duration(milliseconds: 3200),
    this.isCompleted,
    this.asyncOperation,
  });

  @override
  State<BriefingProcessingModal> createState() =>
      _BriefingProcessingModalState();
}

class _PrepStep {
  const _PrepStep({
    required this.title,
    required this.subtitle,
    required this.thoughts,
  });

  final String title;
  final String subtitle;
  final List<String> thoughts;
}

class _BriefingProcessingModalState extends State<BriefingProcessingModal>
    with TickerProviderStateMixin {
  static const _tick = Duration(milliseconds: 40);
  static const _steps = [
    _PrepStep(
      title: 'Absorbing what you have shared',
      subtitle: 'Transcribing what you said and how you said it',
      thoughts: [
        'Reading your answers carefully…',
        'Listening for tone and emphasis…',
        'Capturing the details that matter…',
      ],
    ),
    _PrepStep(
      title: 'Structuring our response',
      subtitle: 'Synthesizing key insights and guidance',
      thoughts: [
        'Finding the patterns in your story…',
        'Connecting this to your goals…',
        'Shaping the coaching angle…',
      ],
    ),
    _PrepStep(
      title: 'Delivering your briefing',
      subtitle: 'Finalizing your tailored coaching plan',
      thoughts: [
        'Your coach is thinking this through…',
        'Drafting a briefing just for you…',
        'Checking the guidance against your goals…',
        'Putting the finishing touches together…',
        'Still working — richer answers take a moment…',
      ],
    ),
  ];

  int _currentStep = 0;
  double _progress = 0.0;
  bool _hasApiResponded = false;
  bool _didFinish = false;
  int _thoughtIndex = 0;
  int _elapsedMs = 0;
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

    if (widget.isCompleted != null) {
      _hasApiResponded = widget.isCompleted!;
    } else if (widget.asyncOperation != null) {
      _hasApiResponded = false;
      widget.asyncOperation!.whenComplete(_onApiCompleted);
    } else {
      _hasApiResponded = true;
    }

    _startProgress();
    _startThoughtCycle();
  }

  @override
  void didUpdateWidget(covariant BriefingProcessingModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted == true && !_hasApiResponded) {
      _onApiCompleted();
    }
  }

  void _onApiCompleted() {
    if (!mounted || _hasApiResponded) return;
    setState(() => _hasApiResponded = true);
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
    _elapsedMs = 0;

    _progressTimer = Timer.periodic(_tick, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _elapsedMs += _tick.inMilliseconds;
        _advanceProgress();
        _syncStep();
      });
    });
  }

  void _advanceProgress() {
    if (_didFinish) return;

    if (!_hasApiResponded) {
      if (_progress < 0.86) {
        _progress += 0.0062;
      } else {
        _progress += (0.93 - _progress) * 0.012;
      }
      return;
    }

    final remaining = 1.0 - _progress;
    if (remaining <= 0.002) {
      _progress = 1.0;
      _currentStep = 3;
      _completeSequence();
      return;
    }

    final finishMs =
        _progress < 0.12 ? widget.totalDuration.inMilliseconds : 700;
    final ticks = math.max(1, finishMs / _tick.inMilliseconds);
    _progress = (_progress + remaining / ticks + 0.0015).clamp(0.0, 1.0);

    if (_progress >= 1.0) {
      _progress = 1.0;
      _currentStep = 3;
      _completeSequence();
    }
  }

  void _syncStep() {
    if (_progress >= 1.0) {
      _currentStep = 3;
    } else if (_progress >= 0.66) {
      _currentStep = 2;
    } else if (_progress >= 0.33) {
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
    if (_progress >= 1.0) return 'Your briefing is ready';
    if (_hasApiResponded && _progress > 0.9) return 'Locking in your briefing';
    if (_elapsedMs > 8000 && !_hasApiResponded) {
      return 'Still thinking this through';
    }
    return 'Preparing your briefing';
  }

  String get _liveThought {
    if (_progress >= 1.0) return 'Your tailored coaching plan is ready.';
    final step = _steps[_currentStep.clamp(0, _steps.length - 1)];
    return step.thoughts[_thoughtIndex % step.thoughts.length];
  }

  double _stepFill(int step) {
    const bounds = [0.0, 0.33, 0.66, 1.0];
    final start = bounds[step];
    final end = bounds[step + 1];
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
                        'PREPARATION STEPS',
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
                IconPath.spFlash,
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
                    : 'STEP ${(_currentStep + 1).clamp(1, 3)} OF 3',
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
    required _PrepStep step,
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
                    _hasApiResponded ? 'Wrapping up…' : 'Processing…',
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
