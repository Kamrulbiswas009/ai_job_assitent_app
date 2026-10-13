import 'package:studioequip_mobile_app/core/utils/constants/image_path.dart';

class RoleplayOptionModel {
  final String id;
  final String name;
  final String subtitle;
  final String imageAsset;

  const RoleplayOptionModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageAsset,
  });

  factory RoleplayOptionModel.fromJson(Map<String, dynamic> json) {
    return RoleplayOptionModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      imageAsset: json['imageAsset'] as String? ?? ImagePath.introWoman,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subtitle': subtitle,
        'imageAsset': imageAsset,
      };
}

class ChallengeModeOptionModel {
  final String id;
  final String title;
  final String description;
  final bool isXpBonus;
  final String xpBonusText;

  const ChallengeModeOptionModel({
    required this.id,
    required this.title,
    required this.description,
    this.isXpBonus = false,
    this.xpBonusText = '',
  });

  factory ChallengeModeOptionModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModeOptionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isXpBonus: json['isXpBonus'] as bool? ?? false,
      xpBonusText: json['xpBonusText'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isXpBonus': isXpBonus,
        'xpBonusText': xpBonusText,
      };
}

class PracticeSessionReadyModel {
  final String userName;
  final String heading;
  final String description;
  final String founderInsightDuration;
  final String founderInsightTitle;
  final String missionTarget;
  final String missionTargetQuote;
  final List<RoleplayOptionModel> roleplays;
  final List<ChallengeModeOptionModel> challengeModes;

  const PracticeSessionReadyModel({
    required this.userName,
    required this.heading,
    required this.description,
    required this.founderInsightDuration,
    required this.founderInsightTitle,
    required this.missionTarget,
    required this.missionTargetQuote,
    required this.roleplays,
    required this.challengeModes,
  });

  factory PracticeSessionReadyModel.initial() {
    return const PracticeSessionReadyModel(
      userName: 'NICK',
      heading: 'YOUR FIRST PRACTISE SESSION IS READY',
      description:
          'Choose who SpeechPro will roleplay and how challenging you want this first session to be.',
      founderInsightDuration: '08s',
      founderInsightTitle: 'The first moments of an interview',
      missionTarget: 'Job Interview',
      missionTargetQuote:
          '"I have a job interview coming up and I want to walk in with complete authority and conviction."',
      roleplays: [
        RoleplayOptionModel(
          id: 'warm_hr',
          name: 'Warm HR Partner',
          subtitle: 'Friendly, conversational, still probing for substance.',
          imageAsset: ImagePath.spRoleplayWoman,
        ),
        RoleplayOptionModel(
          id: 'skeptical_manager',
          name: 'Skeptical Hiring Manager',
          subtitle: 'Direct, unimpressed by default, wants proof.',
          imageAsset: ImagePath.spRoleplayWoman,
        ),
        RoleplayOptionModel(
          id: 'executive_panel',
          name: 'Executive Panel',
          subtitle:
              'Formal, terse, tests composure under status pressure.',
          imageAsset: ImagePath.spRoleplayWoman,
        ),
      ],
      challengeModes: [
        ChallengeModeOptionModel(
          id: 'standard',
          title: 'Standard Mode',
          description:
              'A realistic and supportive conversation to build your confidence.',
          isXpBonus: false,
        ),
        ChallengeModeOptionModel(
          id: 'challenge',
          title: 'Challenge Mode (+20% XP)',
          description:
              'A more demanding, realistic experience. SpeechPro may interrupt, challenge assumptions, and hold deliberate silences.',
          isXpBonus: true,
          xpBonusText: '+20% XP',
        ),
      ],
    );
  }
}
