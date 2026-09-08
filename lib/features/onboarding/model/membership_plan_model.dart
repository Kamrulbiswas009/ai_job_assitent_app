class MembershipPlanModel {
  final String id;
  final String title;
  final String price;
  final String period;
  final String? badge;
  final List<String> features;
  final bool isPopular;

  const MembershipPlanModel({
    required this.id,
    required this.title,
    required this.price,
    required this.period,
    this.badge,
    this.features = const [],
    this.isPopular = false,
  });
}
