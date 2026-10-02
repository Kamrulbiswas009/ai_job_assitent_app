import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';

class VoiceRecorderCard extends StatefulWidget {
  final bool isRecording;
  final int durationSeconds;
  final VoidCallback onToggleRecord;
  final String label;
  final bool isCompactHorizontal; // true for Step 2, false for Step 4
  final double volumeLevel; // 0.0 to 1.0 based on real microphone volume
  final bool isVoiceDetected; // true when human voice is detected

  const VoiceRecorderCard({
    super.key,
    required this.isRecording,
    required this.durationSeconds,
    required this.onToggleRecord,
    this.label = 'Tap to speak your Answer',
    this.isCompactHorizontal = false,
    this.volumeLevel = 0.0,
    this.isVoiceDetected = false,
  });

  @override
  State<VoiceRecorderCard> createState() => _VoiceRecorderCardState();
}

class _VoiceRecorderCardState extends State<VoiceRecorderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.isRecording) {
      _waveController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant VoiceRecorderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _waveController.repeat();
      } else {
        _waveController.stop(canceled: false);
        _waveController.reset();
      }
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  String _formatTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  // Exact 24 waveform bar heights from Figma
  static const List<double> waveformHeights = [
    27.6,
    24.4,
    17.1,
    8.25,
    17.7,
    24.75,
    27.7,
    25.8,
    19.5,
    10.4,
    15.2,
    23.1,
    27.3,
    26.8,
    21.6,
    13.1,
    12.5,
    21.2,
    26.6,
    27.5,
    23.5,
    15.8,
    9.7,
    19.0,
  ];

  // Dynamic bar height modulated by user voice volume and speech frequency waves
  double _calculateBarHeight(
    double baseHeight,
    int index,
    int totalBars,
    double animValue,
    double maxHeight,
  ) {
    if (!widget.isRecording) {
      return (baseHeight * 0.85).clamp(4.0, maxHeight).h;
    }

    // Dynamic wave phase based on bar index and continuous animation cycle
    final phase = (animValue * 2 * math.pi) + (index * (2 * math.pi / 7.5));
    final wave1 = math.sin(phase);
    final wave2 = math.sin(phase * 1.7 + 0.4) * 0.35;
    final normalized = ((wave1 + wave2).clamp(-1.0, 1.0) + 1.0) / 2.0;

    // Natural speech center envelope (human vocal frequencies peak towards middle)
    final centerNormalized = 2.0 * (index / (totalBars - 1)) - 1.0;
    final envelope = 1.0 - (centerNormalized.abs() * 0.32);

    // Voice Volume Modulation:
    // When quiet / paused: subtle gentle wave (volumeBoost ~0.26)
    // When human readable voice detected: expands dynamically up to 1.6x with user voice loudness
    final volumeBoost = 0.26 + (widget.volumeLevel.clamp(0.0, 1.0) * 1.35);

    final dynamicH =
        baseHeight * (0.28 + 0.72 * normalized) * envelope * volumeBoost * 1.35;
    return dynamicH.clamp(4.5, maxHeight).h;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCompactHorizontal) {
      return _buildCompactHorizontalLayout();
    }
    return _buildCenteredCalibrationLayout();
  }

  // Step 2 exact Figma Layout with Active Recording Wave Animation responding to voice volume
  Widget _buildCompactHorizontalLayout() {
    const compactWaveform = [
      16.0,
      26.0,
      14.0,
      8.0,
      16.0,
      28.0,
      26.0,
      24.0,
      18.0,
      8.0,
      16.0,
      28.0,
      26.0,
      24.0,
      18.0,
      8.0,
      16.0,
      26.0,
      24.0,
      18.0,
      8.0,
      14.0,
    ];

    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, _) {
        final pulse = widget.isRecording
            ? (0.5 + 0.5 * math.sin(_waveController.value * 2 * math.pi))
            : 0.0;
        final voiceFactor =
            widget.isRecording ? widget.volumeLevel.clamp(0.0, 1.0) : 0.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7F7),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: widget.isRecording
                  ? AppColors.primary
                      .withValues(alpha: 0.75 + 0.25 * (pulse + voiceFactor))
                  : const Color(0xFFFCA5A5).withValues(alpha: 0.6),
              width: widget.isRecording ? 1.3 : 1.0,
            ),
            boxShadow: widget.isRecording
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: (0.06 + 0.12 * voiceFactor + 0.04 * pulse)
                            .clamp(0.0, 0.3),
                      ),
                      blurRadius: 10 + 8 * voiceFactor,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status Tag: Red pulsing dot + Recording · 0:00
              Row(
                children: [
                  Opacity(
                    opacity: widget.isRecording
                        ? (0.45 + 0.55 * pulse).clamp(0.2, 1.0)
                        : 1.0,
                    child: Container(
                      width: 7.r,
                      height: 7.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: widget.isRecording
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.4 + 0.4 * pulse,
                                  ),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Recording · ${_formatTime(widget.durationSeconds)}',
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                widget.isRecording ? 'Listening...' : widget.label,
                style: GoogleFonts.inter(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: const Color(0xFF374151),
                ),
              ),
              SizedBox(height: 12.h),
              // Horizontal Row: 44x44 Mic Button + Waveform Bars
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onToggleRecord,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 44.r,
                      height: 44.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: widget.isRecording
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: (0.25 +
                                            0.25 * pulse +
                                            0.35 * voiceFactor)
                                        .clamp(0.0, 0.7),
                                  ),
                                  blurRadius: 8 + 8 * pulse + 6 * voiceFactor,
                                  spreadRadius: 1 + 2 * pulse,
                                ),
                              ]
                            : null,
                      ),
                      child: widget.isRecording
                          ? Icon(
                              Icons.stop_rounded,
                              color: AppColors.white,
                              size: 24.sp,
                            )
                          : SvgPicture.asset(
                              IconPath.icMic,
                              width: 22.w,
                              height: 22.h,
                              colorFilter: const ColorFilter.mode(
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Animated Waveform bars reacting to user voice volume
                  Expanded(
                    child: SizedBox(
                      height: 32.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                            List.generate(compactWaveform.length, (index) {
                          final h = compactWaveform[index];
                          final barH = _calculateBarHeight(
                            h,
                            index,
                            compactWaveform.length,
                            _waveController.value,
                            32.0,
                          );
                          return Container(
                            width: 5.w,
                            height: barH,
                            decoration: BoxDecoration(
                              color: widget.isRecording
                                  ? AppColors.primary
                                  : const Color(0xFFDE6262),
                              borderRadius: BorderRadius.circular(2.5.r),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Step 4 Centered Calibration Layout with Active Recording Wave Animation responding to voice volume
  Widget _buildCenteredCalibrationLayout() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, _) {
        final pulse = widget.isRecording
            ? (0.5 + 0.5 * math.sin(_waveController.value * 2 * math.pi))
            : 0.0;
        final voiceFactor =
            widget.isRecording ? widget.volumeLevel.clamp(0.0, 1.0) : 0.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: widget.isRecording
                      ? (0.45 + 0.55 * pulse).clamp(0.2, 1.0)
                      : 1.0,
                  child: Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: widget.isRecording
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.4 + 0.4 * pulse,
                                ),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Recording · ${_formatTime(widget.durationSeconds)}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: widget.onToggleRecord,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 136.r,
                height: 136.r,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    if (widget.isRecording) ...[
                      // Radiating sound wave ring 2 (swells larger when voice is detected)
                      AnimatedBuilder(
                        animation: _waveController,
                        builder: (context, _) {
                          final t = (_waveController.value + 0.5) % 1.0;
                          final voiceExpansion = 1.0 + (voiceFactor * 0.35);
                          final size = (99.r + (30.r * t)) * voiceExpansion;
                          final opacity = (((1.0 - t) * 0.45) *
                                  (0.5 + 0.5 * voiceFactor))
                              .clamp(0.0, 0.5);
                          return Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary
                                    .withValues(alpha: opacity),
                                width: 2.0,
                              ),
                            ),
                          );
                        },
                      ),
                      // Radiating sound wave ring 1
                      AnimatedBuilder(
                        animation: _waveController,
                        builder: (context, _) {
                          final t = _waveController.value;
                          final voiceExpansion = 1.0 + (voiceFactor * 0.35);
                          final size = (99.r + (30.r * t)) * voiceExpansion;
                          final opacity = (((1.0 - t) * 0.45) *
                                  (0.5 + 0.5 * voiceFactor))
                              .clamp(0.0, 0.5);
                          return Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary
                                    .withValues(alpha: opacity),
                                width: 2.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    // Central Record / Stop Button
                    Container(
                      width: 99.r,
                      height: 99.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: widget.isRecording
                                  ? (0.35 +
                                          0.25 * pulse +
                                          0.3 * voiceFactor)
                                      .clamp(0.0, 0.75)
                                  : 0.25,
                            ),
                            blurRadius: widget.isRecording
                                ? (14 + 10 * pulse + 8 * voiceFactor)
                                : 10,
                            spreadRadius: widget.isRecording
                                ? (2 + 3 * pulse + 3 * voiceFactor)
                                : 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: widget.isRecording
                          ? Icon(
                              Icons.stop_rounded,
                              color: AppColors.white,
                              size: 44.sp,
                            )
                          : SvgPicture.asset(
                              IconPath.icMic,
                              width: 54.w,
                              height: 54.w,
                              colorFilter: const ColorFilter.mode(
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              widget.isRecording
                  ? 'Listening... Tap to finish'
                  : widget.label,
              style: GoogleFonts.inter(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 28.h),
            // Waveform bars scaling dynamically with user voice amplitude
            SizedBox(
              height: 48.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(waveformHeights.length, (index) {
                  final h = waveformHeights[index];
                  final barH = _calculateBarHeight(
                    h,
                    index,
                    waveformHeights.length,
                    _waveController.value,
                    48.0,
                  );
                  return Container(
                    width: 6.w,
                    height: barH,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: widget.isRecording
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
