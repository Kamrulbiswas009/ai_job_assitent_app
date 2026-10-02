import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../model/membership_plan_model.dart';
import 'payment_success_sheet.dart';

class StripeCheckoutModalSheet extends StatefulWidget {
  final String checkoutUrl;
  final MembershipPlanModel plan;

  const StripeCheckoutModalSheet({
    super.key,
    required this.checkoutUrl,
    required this.plan,
  });

  static Future<void> show(
    BuildContext context, {
    required String checkoutUrl,
    required MembershipPlanModel plan,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => StripeCheckoutModalSheet(
        checkoutUrl: checkoutUrl,
        plan: plan,
      ),
    );
  }

  @override
  State<StripeCheckoutModalSheet> createState() =>
      _StripeCheckoutModalSheetState();
}

class _StripeCheckoutModalSheetState extends State<StripeCheckoutModalSheet> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  double _progress = 0.0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    try {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent(
            'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36')
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _progress = progress / 100.0;
                  if (progress >= 95) {
                    _isLoading = false;
                  }
                });
              }
            },
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
              }
              _checkRedirect(url);
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
              _checkRedirect(url);
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('Stripe WebView Error: ${error.description}');
              if (mounted &&
                  error.errorType != WebResourceErrorType.hostLookup &&
                  error.errorCode != -2) {
                setState(() {
                  _hasError = true;
                  _isLoading = false;
                });
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              return _handleNavigationRequest(request);
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.checkoutUrl));
    } catch (e) {
      debugPrint('WebView initialization error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    final url = request.url.toLowerCase();
    debugPrint('Stripe Navigation URL: ${request.url}');

    if (url.contains('subscription/success') ||
        url.contains('session_id=') ||
        url.contains('checkout/success') ||
        url.contains('payment_success')) {
      _handlePaymentSuccess();
      return NavigationDecision.prevent;
    }

    if (url.contains('subscription/cancelled') ||
        url.contains('checkout/cancel') ||
        url.contains('cancel_url')) {
      Navigator.of(context).pop();
      Get.snackbar(
        'Checkout Cancelled',
        'Your payment process was cancelled.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _checkRedirect(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('subscription/success') ||
        lower.contains('session_id=') ||
        lower.contains('checkout/success') ||
        lower.contains('payment_success')) {
      _handlePaymentSuccess();
    }
  }

  void _handlePaymentSuccess() async {
    await StorageService.saveIsSubscribed(true);

    if (mounted) {
      Navigator.of(context).pop(); // Close bottom sheet
    }

    PaymentSuccessSheet.show(
      planArgs: widget.plan.toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.90;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        child: Column(
          children: [
            // Top Drag Handle & Title Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0D0D0),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF635BFF).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_rounded,
                          size: 16.sp,
                          color: const Color(0xFF635BFF),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stripe Secure Checkout',
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              '${widget.plan.title} • ${widget.plan.price}${widget.plan.period}',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        iconSize: 22.sp,
                        color: AppColors.black,
                        splashRadius: 20.r,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Linear Progress Bar
            if (_isLoading)
              LinearProgressIndicator(
                value: _progress > 0 ? _progress : null,
                backgroundColor: const Color(0xFFE8E8FF),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF635BFF)),
                minHeight: 2.5.h,
              ),

            // Webview / Error Screen
            Expanded(
              child: _hasError
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48.sp,
                              color: AppColors.error,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Failed to load checkout',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Please check your internet connection and try again.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: AppColors.gray,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _hasError = false;
                                  _isLoading = true;
                                });
                                _webViewController
                                    .loadRequest(Uri.parse(widget.checkoutUrl));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF635BFF),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : WebViewWidget(controller: _webViewController),
            ),
          ],
        ),
      ),
    );
  }
}
