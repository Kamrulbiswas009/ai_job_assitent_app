class GoalCategoryModel {
  final String id;
  final String number;
  final String title;

  GoalCategoryModel({
    required this.id,
    required this.number,
    required this.title,
  });
}

class BenchmarkQuestionModel {
  final String id;
  final String title;
  int? selectedIndex; // 0: Rarely, 1: Sometimes, 2: Often, 3: Usually, 4: Always

  BenchmarkQuestionModel({
    required this.id,
    required this.title,
    this.selectedIndex,
  });
}

class TrainingPathInfo {
  final String pillar;
  final String focus1;
  final String focus2;

  const TrainingPathInfo({
    required this.pillar,
    required this.focus1,
    required this.focus2,
  });
}
