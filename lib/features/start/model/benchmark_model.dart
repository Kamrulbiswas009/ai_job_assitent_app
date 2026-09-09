class BenchmarkQuestionModel {
  final String id;
  final String title;
  int? selectedIndex; // 0: Rarely, 1: Sometimes, 2: Often, 3: Usually, 4: Always

  BenchmarkQuestionModel({
    required this.id,
    required this.title,
    this.selectedIndex,
  });

  factory BenchmarkQuestionModel.fromJson(Map<String, dynamic> json) {
    return BenchmarkQuestionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      selectedIndex: json['selected_index'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'selected_index': selectedIndex,
    };
  }
}
