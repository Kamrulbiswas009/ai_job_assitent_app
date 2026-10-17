class PracticeSessionCompleteModel {
  final int sessionNumber;
  final String scenarioName;
  final String panelName;
  final String encouragementTitle;
  final String encouragementBody;

  const PracticeSessionCompleteModel({
    required this.sessionNumber,
    required this.scenarioName,
    required this.panelName,
    this.encouragementTitle = "You're doing brilliantly.",
    this.encouragementBody =
        "In a short space of time, you've already begun to turn instinct into technique. Every time you practise with intention, your voice becomes clearer, calmer and more authoritative.",
  });

  String get sessionTitle {
    final padded = sessionNumber.toString().padLeft(2, '0');
    return 'Session $padded Complete';
  }

  String get contextLine {
    final parts = [
      if (scenarioName.trim().isNotEmpty) scenarioName.trim(),
      if (panelName.trim().isNotEmpty) panelName.trim(),
    ];
    return parts.isEmpty ? 'Job Interview · Warm HR Partner' : parts.join(' · ');
  }

  factory PracticeSessionCompleteModel.initial() {
    return const PracticeSessionCompleteModel(
      sessionNumber: 1,
      scenarioName: 'Job Interview',
      panelName: 'Warm HR Partner',
    );
  }
}

class PracticeProgressionItem {
  final String eyebrow;
  final String title;
  final String body;
  final String badge;
  final String actionLabel;
  final String tone;

  const PracticeProgressionItem({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.badge,
    required this.actionLabel,
    required this.tone,
  });
}

class PracticeChapterAction {
  final String label;
  final String subtitle;
  final IconStyle icon;

  const PracticeChapterAction({
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}

enum IconStyle { book, summary, headphones }

class PracticeSessionProgressionModel {
  final PracticeProgressionItem doctrine;
  final PracticeProgressionItem curriculum;
  final String chapterEyebrow;
  final String chapterTitle;
  final String chapterBody;
  final String chapterHint;
  final List<PracticeChapterAction> chapterActions;
  final PracticeProgressionItem nextSession;

  const PracticeSessionProgressionModel({
    required this.doctrine,
    required this.curriculum,
    required this.chapterEyebrow,
    required this.chapterTitle,
    required this.chapterBody,
    required this.chapterHint,
    required this.chapterActions,
    required this.nextSession,
  });

  factory PracticeSessionProgressionModel.initial({
    int nextSessionNumber = 2,
  }) {
    return PracticeSessionProgressionModel(
      doctrine: const PracticeProgressionItem(
        eyebrow: 'Doctrine',
        title: 'Focused Entry',
        body:
            'Speak to the person in front of you, not to an imagined panel.',
        badge: 'PRACTISED',
        actionLabel: 'Recap doctrine',
        tone: 'rose',
      ),
      curriculum: const PracticeProgressionItem(
        eyebrow: 'Curriculum',
        title: 'The Importance of Pace',
        body: 'Move through context. Slow down on your strongest point.',
        badge: 'EXPLORED',
        actionLabel: 'Recap module',
        tone: 'blue',
      ),
      chapterEyebrow: 'Founder Insight Chapter',
      chapterTitle: 'Energy',
      chapterBody: 'What the room reads before you speak.',
      chapterHint: 'Choose how you want to explore this chapter.',
      chapterActions: const [
        PracticeChapterAction(
          label: 'Read the full chapter',
          subtitle: 'The Interview That Started at 9am',
          icon: IconStyle.book,
        ),
        PracticeChapterAction(
          label: 'Read the chapter summary',
          subtitle: '',
          icon: IconStyle.summary,
        ),
        PracticeChapterAction(
          label: 'Try the chapter practice',
          subtitle: 'The Inner Smile Daily Practice',
          icon: IconStyle.headphones,
        ),
      ],
      nextSession: PracticeProgressionItem(
        eyebrow: 'Next Session',
        title: 'Yi — The Power of Intent',
        body: 'Decide what must land before you speak.',
        badge: 'SESSION $nextSessionNumber',
        actionLabel: 'Continue to Session $nextSessionNumber',
        tone: 'green',
      ),
    );
  }
}
