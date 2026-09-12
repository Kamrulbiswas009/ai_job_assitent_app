class MembershipPlanModel {
  final String id;
  final String planId;
  final String slug;
  final String title;
  final String price;
  final String period;
  final String? badge;
  final List<String> features;
  final bool isPopular;
  final String buttonText;
  final String billingText;
  final String billingCycle;

  const MembershipPlanModel({
    required this.id,
    required this.planId,
    required this.slug,
    required this.title,
    required this.price,
    required this.period,
    this.badge,
    this.features = const [],
    this.isPopular = false,
    required this.buttonText,
    required this.billingText,
    required this.billingCycle,
  });

  static const monthly = MembershipPlanModel(
    id: 'monthly',
    planId: '6bf15901-1f27-4125-8eb3-622cd65e964d',
    slug: 'standard-monthly',
    title: 'Standard Monthly',
    price: '£49',
    period: '/month',
    buttonText: 'Start Training — £49/month',
    billingText: 'Billed monthly. Cancel anytime in your App Store settings.',
    billingCycle: 'Monthly',
  );

  static const threeMonths = MembershipPlanModel(
    id: '3months',
    planId: '25d9bf73-45f5-4dc1-9dd9-79c45f4ecc11',
    slug: 'three-month-prepay',
    title: '3-Month Prepay',
    price: '£120',
    period: '/3 months',
    buttonText: 'Start Training — 3 months → £120',
    billingText:
        'Billed every 3 months. Cancel anytime in your App Store settings.',
    billingCycle: '3 Months',
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'planId': planId,
      'slug': slug,
      'title': title,
      'price': price,
      'period': period,
      'buttonText': buttonText,
      'billingText': billingText,
      'billingCycle': billingCycle,
    };
  }

  factory MembershipPlanModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return monthly;
    final planId = map['planId']?.toString();
    if (planId == threeMonths.planId || map['id'] == '3months') {
      return threeMonths;
    }
    return monthly;
  }
}
