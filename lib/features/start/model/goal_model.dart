class GoalCategoryModel {
  final String id;
  final String number;
  final String title;

  const GoalCategoryModel({
    required this.id,
    required this.number,
    required this.title,
  });

  factory GoalCategoryModel.fromJson(Map<String, dynamic> json) {
    return GoalCategoryModel(
      id: json['id'] as String? ?? '',
      number: json['number'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
    };
  }
}
