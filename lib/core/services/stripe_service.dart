import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../utils/constants/api_constants.dart';

class StripeService {
  static final StripeService _instance = StripeService._internal();
  factory StripeService() => _instance;
  StripeService._internal();

  static Future<void> init() async {
    try {
      Stripe.publishableKey = ApiConstants.stripePublishableKey;
      Stripe.merchantIdentifier = 'merchant.com.studioequip.studioequip_mobile_app';
      await Stripe.instance.applySettings();
      debugPrint('Stripe SDK initialized successfully.');
    } catch (e) {
      debugPrint('Stripe initialization error: $e');
    }
  }

  /// Initialize and present Stripe Native Payment Sheet if clientSecret is available
  static Future<bool> presentNativePaymentSheet({
    required String clientSecret,
    String? customerEphemeralKeySecret,
    String? customerId,
    String merchantDisplayName = 'SpeechPro StudioEquip',
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      debugPrint('StripeException: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      debugPrint('Stripe PaymentSheet Error: $e');
      return false;
    }
  }
}
