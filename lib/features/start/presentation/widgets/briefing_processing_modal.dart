import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';

class BriefingProcessingModal extends StatefulWidget {
  final VoidCallback onComplete;
  final Duration totalDuration;

  const BriefingProcessingModal({
    super.key,
    required this.onComplete,
    this.totalDuration = const Duration(milliseconds: 3200),
  });

  @override
  State<BriefingProcessingModal> createState() => _BriefingProcessingModalState();
}

class _BriefingProcessingModalState extends State<BriefingProcessingModal> {
  int _currentStep = 0; // 0 = step 1 active, 1 = step 2 active, 2 = step 3 active, 3 = all done
  double _progress = 0.0;
  Timer? _progressTimer;
  Timer? _timerDone;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    _progress = 0.0;
    _currentStep = 0;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_progress < 0.35) {
          _progress += 0.015;
          _currentStep = 0;
        } else if (_progress < 0.70) {
          _progress += 0.012;
          _currentStep = 1;
        } else if (_progress < 1.0) {
          _progress += 0.012;
          _currentStep = 2;
        } else {
          _progress = 1.0;
          _currentStep = 3;
          timer.cancel();
          _timerDone = Timer(const Duration(milliseconds: 600), () {
            if (mounted) {
              widget.onComplete();
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _timerDone?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentInt = (_progress * 100).toInt().clamp(0, 100);

    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      alignment: Alignment.center,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 380.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              decoration: BoxDecoration(
                color: const Color(0xFF141416),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: const Color(0xFF2C2C2E),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Exact Red Circular Ring with % Completed from Client Figma Comment
                  SizedBox(
                    width: 104.r,
                    height: 104.r,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Track
                        const SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 6.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C2C2E)),
                          ),
                        ),
                        // Active Animated Red Track
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: _progress,
                            strokeWidth: 6.0,
                            strokeCap: StrokeCap.round,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        // Center Text: 100% Completed
                        Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$percentInt%',
                                  style: GoogleFonts.inter(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Completed',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF8E8E93),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Preparing your briefing...',
                    style: GoogleFonts.inter(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Almost ready',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Section Header: PREPARATION STEPS
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PREPARATION STEPS',
                      style: GoogleFonts.inter(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: const Color(0xFF636366),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Step 1
                  _buildStepCard(
                    title: 'Absorbing what you have shared',
                    subtitle: 'Transcribing what you said and how you said it',
                    isComplete: _currentStep >= 1,
                    isActive: _currentStep == 0,
                  ),
                  SizedBox(height: 10.h),
                  // Step 2
                  _buildStepCard(
                    title: 'Structuring our response',
                    subtitle: 'Synthesizing key insights and guidance',
                    isComplete: _currentStep >= 2,
                    isActive: _currentStep == 1,
                  ),
                  SizedBox(height: 10.h),
                  // Step 3
                  _buildStepCard(
                    title: 'Delivering your briefing',
                    subtitle: 'Finalizing your tailored coaching plan',
                    isComplete: _currentStep >= 3,
                    isActive: _currentStep == 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String title,
    required String subtitle,
    required bool isComplete,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isComplete
              ? const Color(0xFF34C759).withValues(alpha: 0.3)
              : (isActive
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : const Color(0xFF2C2C2E)),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Green checkmark or Active spinner or Pending dot
          Container(
            width: 24.r,
            height: 24.r,
            decoration: BoxDecoration(
              color: isComplete
                  ? const Color(0xFF1E3A2F)
                  : (isActive
                      ? const Color(0xFF2C2C2E)
                      : const Color(0xFF242426)),
              shape: BoxShape.circle,
              border: Border.all(
                color: isComplete
                    ? const Color(0xFF34C759)
                    : (isActive
                        ? AppColors.primary
                        : const Color(0xFF3A3A3C)),
                width: 1.2,
              ),
            ),
            child: isComplete
                ? Icon(
                    Icons.check,
                    size: 14.sp,
                    color: const Color(0xFF34C759),
                  )
                : (isActive
                    ? Center(
                        child: SizedBox(
                          width: 12.r,
                          height: 12.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 1.5,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      )
                    : null),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                if (isComplete) ...[
                  SizedBox(height: 3.h),
                  Text(
                    'Completed',
                    style: GoogleFonts.inter(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF34C759),
                    ),
                  ),
                ] else if (isActive) ...[
                  SizedBox(height: 3.h),
                  Text(
                    'Processing...',
                    style: GoogleFonts.inter(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
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
}
