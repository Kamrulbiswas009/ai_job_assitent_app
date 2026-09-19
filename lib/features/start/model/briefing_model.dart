class PersonalBriefingRequest {
  final String firstName;
  final String scenarioId;
  final String role;
  final String goal;
  final String description;
  final String voice;
  final String? voiceFilePath;

  const PersonalBriefingRequest({
    required this.firstName,
    required this.scenarioId,
    required this.role,
    required this.goal,
    this.description = '',
    this.voice = '',
    this.voiceFilePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'scenario_id': scenarioId,
      'role': role,
      'goal': goal,
      'description': description,
      'voice': voice,
    };
  }

  factory PersonalBriefingRequest.fromJson(Map<String, dynamic> json) {
    return PersonalBriefingRequest(
      firstName: json['first_name'] as String? ?? '',
      scenarioId: json['scenario_id'] as String? ?? '',
      role: json['role'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      description: json['description'] as String? ?? '',
      voice: json['voice'] as String? ?? '',
    );
  }
}

class TrainingPillarModel {
  final String name;
  final String description;

  const TrainingPillarModel({
    required this.name,
    required this.description,
  });

  factory TrainingPillarModel.fromJson(Map<String, dynamic> json) {
    return TrainingPillarModel(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}

class PrincipleModel {
  final String title;
  final String description;

  const PrincipleModel({
    required this.title,
    required this.description,
  });

  factory PrincipleModel.fromJson(Map<String, dynamic> json) {
    return PrincipleModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

class PracticeModel {
  final String title;
  final String instruction;

  const PracticeModel({
    required this.title,
    required this.instruction,
  });

  factory PracticeModel.fromJson(Map<String, dynamic> json) {
    return PracticeModel(
      title: json['title'] as String? ?? '',
      instruction: json['instruction'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'instruction': instruction,
    };
  }
}

class PersonalBriefingModel {
  final String whatWeHeard;
  final String yourProgram;
  final TrainingPillarModel trainingPillar;
  final PrincipleModel firstPrinciple;
  final PracticeModel putItIntoPractice;

  const PersonalBriefingModel({
    required this.whatWeHeard,
    required this.yourProgram,
    required this.trainingPillar,
    required this.firstPrinciple,
    required this.putItIntoPractice,
  });

  factory PersonalBriefingModel.fromJson(Map<String, dynamic> json) {
    return PersonalBriefingModel(
      whatWeHeard: json['whatWeHeard'] as String? ?? '',
      yourProgram: json['yourProgram'] as String? ?? '',
      trainingPillar: json['trainingPillar'] is Map<String, dynamic>
          ? TrainingPillarModel.fromJson(
              json['trainingPillar'] as Map<String, dynamic>,
            )
          : const TrainingPillarModel(name: '', description: ''),
      firstPrinciple: json['firstPrinciple'] is Map<String, dynamic>
          ? PrincipleModel.fromJson(
              json['firstPrinciple'] as Map<String, dynamic>,
            )
          : const PrincipleModel(title: '', description: ''),
      putItIntoPractice: json['putItIntoPractice'] is Map<String, dynamic>
          ? PracticeModel.fromJson(
              json['putItIntoPractice'] as Map<String, dynamic>,
            )
          : const PracticeModel(title: '', instruction: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'whatWeHeard': whatWeHeard,
      'yourProgram': yourProgram,
      'trainingPillar': trainingPillar.toJson(),
      'firstPrinciple': firstPrinciple.toJson(),
      'putItIntoPractice': putItIntoPractice.toJson(),
    };
  }

  /// Default fallback model
  static const PersonalBriefingModel fallback = PersonalBriefingModel(
    whatWeHeard:
        "You have a job interview coming up and you want to walk in with complete authority and conviction. That intention — to own the room before a single question is asked — is exactly the right place to start. The goal here is not to perform confidence but to build the kind of settled certainty that comes through in every answer you give.",
    yourProgram:
        "Walking in prepared is the difference between being considered and being chosen. The person on the other side of that table will decide within seven seconds whether you belong in that room and everything after that is either confirmation or recovery, which means your body language, your eye contact and the volume and pace of your first words matter more than any answer you will give.",
    trainingPillar: TrainingPillarModel(
      name: "Authority Through Presence",
      description:
          "For an interview where you want complete authority and conviction, presence is the foundation — the room must feel that you have already decided you belong there.",
    ),
    firstPrinciple: PrincipleModel(
      title: "The Private Room Rule",
      description:
          "Before you enter the interview, your internal state sets the tone for everything that follows — this doctrine trains you to arrive already settled, already authoritative, so the room receives you that way from the first moment.",
    ),
    putItIntoPractice: PracticeModel(
      title: "The Anchor Statement",
      instruction:
          "Think of the single most important thing you want the interviewer to believe about you by the end of that conversation. Say it aloud as one clear, unhedged sentence — no qualifiers, no softening — and hold the silence after it. That is where your authority lives.",
    ),
  );

  /// Dynamic fallback generator tailored to any selected scenario
  static PersonalBriefingModel createFallback({
    required String scenarioTitle,
    String? firstName,
    String? role,
    String? goal,
  }) {
    final name = (firstName != null && firstName.trim().isNotEmpty)
        ? firstName.trim()
        : 'Aycan';
    final roleText = (role != null && role.trim().isNotEmpty)
        ? role.trim()
        : 'candidate';
    final goalText = (goal != null && goal.trim().isNotEmpty)
        ? goal.trim()
        : 'projecting commanding presence and authority';

    return PersonalBriefingModel(
      whatWeHeard:
          "$name, you are preparing for $scenarioTitle as $roleText with a focus on $goalText. That intention — to own the room and communicate with absolute conviction — is where transformative progress begins. The key is not to perform confidence, but to build settled certainty that resonates in every word you speak.",
      yourProgram:
          "SpeechPro will train you to command immediate authority in your $scenarioTitle. In high-stakes moments, your audience assesses your conviction within the first seven seconds. Everything after that is either confirmation or recovery. We will train you to anchor your credibility upfront, eliminate defensive hesitation, and deploy strategic pauses that signal unmistakable seniority.",
      trainingPillar: TrainingPillarModel(
        name: "Authority Through Presence",
        description:
            "For $scenarioTitle, presence is the foundation — the room must feel that you have already decided you belong there before you utter a single explanation.",
      ),
      firstPrinciple: PrincipleModel(
        title: "The Private Room Rule",
        description:
            "Before you begin, your internal state sets the tone for everything that follows — this doctrine trains you to arrive already settled, already authoritative, so others receive you that way from the first second.",
      ),
      putItIntoPractice: PracticeModel(
        title: "The Anchor Statement",
        instruction:
            "Think of the single most important point you want your audience to remember about your $scenarioTitle. Say it aloud as one clear, unhedged sentence — no qualifiers, no softening — and hold complete silence for two seconds after it. That is where your authority lives.",
      ),
    );
  }
}
