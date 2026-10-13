class PracticeCueItem {
  final String tag;
  final String title;
  final String description;
  final String? actionLabel;
  final String iconKey;

  const PracticeCueItem({
    required this.tag,
    required this.title,
    required this.description,
    this.actionLabel,
    required this.iconKey,
  });

  factory PracticeCueItem.fromJson(Map<String, dynamic> json) {
    return PracticeCueItem(
      tag: json['tag'] as String? ?? 'PRACTICE CUES',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      actionLabel: json['actionLabel'] as String?,
      iconKey: json['iconKey'] as String? ?? 'flash',
    );
  }

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'title': title,
        'description': description,
        'actionLabel': actionLabel,
        'iconKey': iconKey,
      };
}

class TodayDoctrineModel {
  final String tag;
  final String title;
  final String description;
  final String actionLabel;

  const TodayDoctrineModel({
    required this.tag,
    required this.title,
    required this.description,
    required this.actionLabel,
  });

  factory TodayDoctrineModel.fromJson(Map<String, dynamic> json) {
    return TodayDoctrineModel(
      tag: json['tag'] as String? ?? "TODAY'S DOCTRINE",
      title: json['title'] as String? ?? 'Focused Entry',
      description: json['description'] as String? ??
          'Be generous. Connect with every person in the room. Feed the whole room.',
      actionLabel: json['actionLabel'] as String? ?? 'What is Focused Entry?',
    );
  }

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'title': title,
        'description': description,
        'actionLabel': actionLabel,
      };
}

class PracticeCoachingBriefModel {
  final String welcomeTag;
  final String sessionTitle;
  final String sessionSubtitle;
  final String videoTitle;
  final String videoDuration;
  final String focusHeader;
  final String focusBody;
  final TodayDoctrineModel doctrine;
  final List<PracticeCueItem> cues;

  const PracticeCoachingBriefModel({
    required this.welcomeTag,
    required this.sessionTitle,
    required this.sessionSubtitle,
    required this.videoTitle,
    required this.videoDuration,
    required this.focusHeader,
    required this.focusBody,
    required this.doctrine,
    required this.cues,
  });

  factory PracticeCoachingBriefModel.initial() {
    return const PracticeCoachingBriefModel(
      welcomeTag: 'WELCOME TO SPEECHPRO',
      sessionTitle: 'Job Interview',
      sessionSubtitle: 'Warm HR Partner · Challenge Mode',
      videoTitle: 'Your Coaching Brief',
      videoDuration: '0:15 / 0:41',
      focusHeader: 'NICK, HERE IS YOUR FOCUS.',
      focusBody:
          'You are not auditioning. You are entering a conversation to discover whether this role and your strengths belong together.\n\nYour first task is to establish connection before you explain your qualifications. Arrive with warmth. Be generous with your answer. Let every person in the room feel included in what you say. Feed the whole room.\n\nIn your opening answer, make one clear point about why you belong in this role. Then give the evidence.\n\nLet us begin.\n\nSpeechPro Coach',
      doctrine: TodayDoctrineModel(
        tag: "TODAY'S DOCTRINE",
        title: 'Focused Entry',
        description:
            'Be generous. Connect with every person in the room. Feed the whole room.',
        actionLabel: 'What is Focused Entry? →',
      ),
      cues: [
        PracticeCueItem(
          tag: 'PRACTICE CUES',
          title: 'Quick Quick Slow',
          description:
              'Move through content; slow down on your strongest point.',
          actionLabel: 'See how to make your strongest words land →',
          iconKey: 'speed',
        ),
        PracticeCueItem(
          tag: 'PRACTICE CUES',
          title: 'First Impression',
          description: 'Arrive with warmth and purpose.',
          actionLabel: 'See how to make your strongest words land →',
          iconKey: 'chat',
        ),
        PracticeCueItem(
          tag: 'PRACTICE CUES',
          title: 'Founder Insight',
          description:
              "Interview outcomes are usually decided in the first ten to twenty seconds — before a single question is asked. That's energy, not answers. And it starts with genuine warmth toward each person you meet, not a performance for the panel.",
          actionLabel: 'The full founder story follows your practice.',
          iconKey: 'target',
        ),
      ],
    );
  }
}
