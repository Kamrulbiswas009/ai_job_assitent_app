import 'package:studioequip_mobile_app/core/utils/constants/image_path.dart';

class RoleplayOptionModel {
  final String id;
  final String characterId;
  final String name;
  final String subtitle;
  final String imageAsset;
  final String? avatarUrl;
  final bool isRecommended;

  const RoleplayOptionModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageAsset,
    this.characterId = '',
    this.avatarUrl,
    this.isRecommended = false,
  });

  factory RoleplayOptionModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    return RoleplayOptionModel(
      id: json['id'] as String? ?? '',
      characterId: _resolveCharacterId(json, name),
      name: name,
      subtitle: json['subtitle'] as String? ?? '',
      imageAsset: json['imageAsset'] as String? ?? ImagePath.spRoleplayWoman,
      avatarUrl: json['avatarUrl'] as String?,
      isRecommended: json['isRecommended'] as bool? ?? false,
    );
  }

  factory RoleplayOptionModel.fromPanelJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    return RoleplayOptionModel(
      id: json['panelId'] as String? ?? '',
      characterId: _resolveCharacterId(json, name),
      name: name,
      subtitle: json['description'] as String? ??
          json['roleTitle'] as String? ??
          '',
      imageAsset: ImagePath.spRoleplayWoman,
      avatarUrl: json['avatarUrl'] as String?,
      isRecommended: json['isRecommended'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'characterId': characterId,
        'name': name,
        'subtitle': subtitle,
        'imageAsset': imageAsset,
        'avatarUrl': avatarUrl,
        'isRecommended': isRecommended,
      };

  static String _resolveCharacterId(Map<String, dynamic> json, String name) {
    final raw = json['characterId'] ?? json['slug'] ?? json['characterSlug'];
    if (raw != null && raw.toString().trim().isNotEmpty) {
      return raw.toString().trim().replaceAll('-', '_');
    }
    return toCharacterId(name);
  }

  static String toCharacterId(String name) {
    return name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }
}

class ChallengeModeOptionModel {
  final String id;
  final String title;
  final String description;
  final bool isXpBonus;
  final String xpBonusText;
  final double xpBonusMultiplier;

  const ChallengeModeOptionModel({
    required this.id,
    required this.title,
    required this.description,
    this.isXpBonus = false,
    this.xpBonusText = '',
    this.xpBonusMultiplier = 1,
  });

  factory ChallengeModeOptionModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModeOptionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isXpBonus: json['isXpBonus'] as bool? ?? false,
      xpBonusText: json['xpBonusText'] as String? ?? '',
      xpBonusMultiplier:
          (json['xpBonusMultiplier'] as num?)?.toDouble() ?? 1,
    );
  }

  factory ChallengeModeOptionModel.fromModeJson(Map<String, dynamic> json) {
    final mode = (json['mode'] as String? ?? '').toLowerCase();
    final multiplier = (json['xpBonusMultiplier'] as num?)?.toDouble() ?? 1;
    final bonusPercent =
        multiplier > 1 ? ((multiplier - 1) * 100).round() : 0;

    return ChallengeModeOptionModel(
      id: mode.isNotEmpty ? mode : 'standard',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isXpBonus: multiplier > 1,
      xpBonusText: bonusPercent > 0 ? '+$bonusPercent% XP' : '',
      xpBonusMultiplier: multiplier,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isXpBonus': isXpBonus,
        'xpBonusText': xpBonusText,
        'xpBonusMultiplier': xpBonusMultiplier,
      };
}

class PracticeSessionReadyModel {
  final String userName;
  final String heading;
  final String description;
  final String founderInsightTag;
  final String founderInsightDuration;
  final String founderInsightTitle;
  final String? founderInsightThumbnailUrl;
  final String? founderInsightVideoUrl;
  final String missionTarget;
  final String missionTargetQuote;
  final String? sessionTarget;
  final List<RoleplayOptionModel> roleplays;
  final List<ChallengeModeOptionModel> challengeModes;

  const PracticeSessionReadyModel({
    required this.userName,
    required this.heading,
    required this.description,
    required this.founderInsightTag,
    required this.founderInsightDuration,
    required this.founderInsightTitle,
    this.founderInsightThumbnailUrl,
    this.founderInsightVideoUrl,
    required this.missionTarget,
    required this.missionTargetQuote,
    this.sessionTarget,
    required this.roleplays,
    required this.challengeModes,
  });

  factory PracticeSessionReadyModel.fromPrepareApi(
    Map<String, dynamic> json, {
    required String userName,
  }) {
    final scenario =
        (json['scenario'] as Map?)?.cast<String, dynamic>() ?? {};
    final founderVideo =
        (scenario['founderVideo'] as Map?)?.cast<String, dynamic>();
    final panels = json['panels'] as List? ?? [];
    final modes = json['availableModes'] as List? ?? [];

    final durationSeconds = founderVideo?['durationSeconds'] as int?;

    return PracticeSessionReadyModel(
      userName: userName,
      heading: 'YOUR FIRST\nPRACTISE SESSION IS READY',
      description:
          'Choose who SpeechPro will roleplay and how challenging you want this first session to be.',
      founderInsightTag: founderVideo?['tag'] as String? ??
          'FOUNDER INSIGHT - ${_formatDurationLabel(durationSeconds)}',
      founderInsightDuration: _formatDurationLabel(durationSeconds),
      founderInsightTitle: founderVideo?['title'] as String? ?? '',
      founderInsightThumbnailUrl: founderVideo?['thumbnailUrl'] as String?,
      founderInsightVideoUrl: founderVideo?['videoUrl'] as String?,
      missionTarget: scenario['name'] as String? ?? '',
      missionTargetQuote: scenario['missionTarget'] as String? ?? '',
      sessionTarget: scenario['sessionTarget'] as String?,
      roleplays: panels
          .whereType<Map>()
          .map((panel) => RoleplayOptionModel.fromPanelJson(
                Map<String, dynamic>.from(panel),
              ))
          .toList(),
      challengeModes: modes
          .whereType<Map>()
          .map((mode) => ChallengeModeOptionModel.fromModeJson(
                Map<String, dynamic>.from(mode),
              ))
          .toList(),
    );
  }

  factory PracticeSessionReadyModel.initial() {
    return const PracticeSessionReadyModel(
      userName: 'NICK',
      heading: 'YOUR FIRST\nPRACTISE SESSION IS READY',
      description:
          'Choose who SpeechPro will roleplay and how challenging you want this first session to be.',
      founderInsightTag: 'FOUNDER INSIGHT - 08s',
      founderInsightDuration: '08s',
      founderInsightTitle: 'The first moments of an interview',
      missionTarget: 'Job Interview',
      missionTargetQuote:
          '"I have a job interview coming up and I want to walk in with complete authority and conviction."',
      roleplays: [
        RoleplayOptionModel(
          id: 'warm_hr',
          characterId: 'warm_hr_partner',
          name: 'Warm HR Partner',
          subtitle: 'Friendly, conversational, still probing for substance.',
          imageAsset: ImagePath.spRoleplayWoman,
          isRecommended: true,
        ),
        RoleplayOptionModel(
          id: 'skeptical_manager',
          characterId: 'skeptical_hiring_manager',
          name: 'Skeptical Hiring Manager',
          subtitle: 'Direct, unimpressed by default, wants proof.',
          imageAsset: ImagePath.spRoleplayWoman,
        ),
        RoleplayOptionModel(
          id: 'executive_panel',
          characterId: 'executive_panel',
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
          xpBonusMultiplier: 1.2,
        ),
      ],
    );
  }

  static String _formatDurationLabel(int? seconds) {
    if (seconds == null || seconds <= 0) return '60s';
    return '${seconds}s';
  }
}
