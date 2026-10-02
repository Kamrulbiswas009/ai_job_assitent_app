import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_step2_details_controller.dart';
import 'package:studioequip_mobile_app/features/start/model/briefing_model.dart';
import 'package:studioequip_mobile_app/features/start/model/scenario_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sampleJsonResponse = '''{
  "whatWeHeard": "You're an app developer targeting a senior full stack developer position. This interview requires you to demonstrate technical breadth, architectural judgment, and leadership capability — not just coding proficiency. The panel will assess whether you command the room like someone who owns decisions, not someone seeking approval.",
  "yourProgram": "SpeechPro will train you to establish immediate executive presence in technical interviews by replacing defensive over-explanation with calm, decisive authority. You'll learn to anchor your credibility in the first ten seconds, structure answers with surgical precision using bottom-line-up-front framing, and deploy strategic silence to project seniority. This transforms the interview from an interrogation into a peer-level strategic conversation where the panel perceives you as the senior hire before you finish your first answer.",
  "trainingPillar": {
    "name": "Authority Through Presence",
    "description": "Senior technical roles demand that you own the room from the moment you speak. Authority Through Presence teaches you to project decision-making confidence and architectural command through vocal control, deliberate pacing, and unhedged statements — so interviewers instinctively place you at the senior level before evaluating your technical depth."
  },
  "firstPrinciple": {
    "title": "Bottom Line Up Front",
    "description": "In high-stakes interviews, junior candidates build up to their point. Senior hires state their conclusion in the opening sentence. Bottom Line Up Front eliminates anxious preambles and positions you as someone who thinks in outcomes, not explanations. You'll lead every answer with your strongest value proposition or technical judgment, then support it — never the reverse."
  },
  "putItIntoPractice": {
    "title": "The Anchor Statement",
    "instruction": "Stand up. Say aloud in one declarative sentence the single strongest technical result or architectural decision you can confidently defend from your own work. No hedging, no setup, no context — just the outcome. Then hold complete silence for two full seconds. Repeat until the silence feels commanding, not uncomfortable."
  }
}''';

  group('Personal Briefing Model Tests', () {
    test('PersonalBriefingModel correctly parses user response json', () {
      final Map<String, dynamic> jsonMap = jsonDecode(sampleJsonResponse);
      final model = PersonalBriefingModel.fromJson(jsonMap);

      expect(
        model.whatWeHeard,
        contains(
          "You're an app developer targeting a senior full stack developer position",
        ),
      );
      expect(
        model.yourProgram,
        contains(
          "SpeechPro will train you to establish immediate executive presence",
        ),
      );
      expect(model.trainingPillar.name, equals("Authority Through Presence"));
      expect(
        model.trainingPillar.description,
        contains("Senior technical roles demand that you own the room"),
      );
      expect(model.firstPrinciple.title, equals("Bottom Line Up Front"));
      expect(
        model.firstPrinciple.description,
        contains("In high-stakes interviews, junior candidates build up to their point"),
      );
      expect(model.putItIntoPractice.title, equals("The Anchor Statement"));
      expect(
        model.putItIntoPractice.instruction,
        contains("Stand up. Say aloud in one declarative sentence"),
      );
    });

    test('PersonalBriefingRequest formats correctly to json', () {
      const request = PersonalBriefingRequest(
        firstName: 'string',
        scenarioId: 'Job interview ',
        role: 'App developer',
        goal: 'senior full stack developer  ',
        voice: ' ',
      );

      final json = request.toJson();
      expect(json['first_name'], equals('string'));
      expect(json['scenario_id'], equals('Job interview '));
      expect(json['role'], equals('App developer'));
      expect(json['goal'], equals('senior full stack developer  '));
      expect(json['voice'], equals(' '));
    });

    test('PersonalBriefingModel fallback is complete and valid', () {
      const fallback = PersonalBriefingModel.fallback;
      expect(fallback.whatWeHeard, isNotEmpty);
      expect(fallback.yourProgram, isNotEmpty);
      expect(fallback.trainingPillar.name, isNotEmpty);
      expect(fallback.trainingPillar.description, isNotEmpty);
      expect(fallback.firstPrinciple.title, isNotEmpty);
      expect(fallback.firstPrinciple.description, isNotEmpty);
      expect(fallback.putItIntoPractice.title, isNotEmpty);
      expect(fallback.putItIntoPractice.instruction, isNotEmpty);
    });

    test('PersonalBriefingModel.createFallback customizes for scenario', () {
      final customFallback = PersonalBriefingModel.createFallback(
        scenarioTitle: 'Investor Pitch',
        firstName: 'Aycan',
        role: 'Founder & CEO',
        goal: 'Raise Seed Round',
      );
      expect(customFallback.whatWeHeard, contains('Investor Pitch'));
      expect(customFallback.whatWeHeard, contains('Aycan'));
      expect(customFallback.yourProgram, contains('Investor Pitch'));
      expect(customFallback.trainingPillar.name, isNotEmpty);
      expect(customFallback.firstPrinciple.title, isNotEmpty);
      expect(customFallback.putItIntoPractice.title, isNotEmpty);
    });
  });

  group('Scenario Configuration & Step 2 Dynamic UI Tests', () {
    test('ScenarioConfig contains all 18 scenarios with unique slugs and titles', () {
      expect(ScenarioConfig.all.length, equals(18));
      final slugs = ScenarioConfig.all.map((s) => s.slug).toSet();
      expect(slugs.length, equals(18));
    });

    test('ScenarioConfig.findByTitleOrId resolves correctly', () {
      final pitch = ScenarioConfig.findByTitleOrId('Investor Pitch');
      expect(pitch.slug, equals('investor_pitch'));
      expect(pitch.roleTitle, equals('What is your role or venture?'));
      expect(
        pitch.voiceQuestionTitle,
        equals('In your own words — what is your pitch and why should investors back you?'),
      );

      final interview = ScenarioConfig.findByTitleOrId('job_interview');
      expect(interview.title, equals('Job Interview'));
      expect(interview.roleTitle, equals('What role are you applying for?'));
    });

    test('StartStep2DetailsController initializes with empty text fields and dynamic scenario titles', () {
      final controller = StartStep2DetailsController();
      controller.onInit();

      // Initially text fields are empty/null, user can text here
      expect(controller.interviewKeywordsController.text, isEmpty);
      expect(controller.roleApplyingController.text, isEmpty);
      expect(controller.voiceAnswerTextController.text, isEmpty);

      // Default scenario is Job Interview
      expect(controller.selectedGoalTitle.value, equals('Job Interview'));
      expect(controller.roleFieldTitle.value, equals('What role are you applying for?'));

      // Changing scenario dynamically updates titles and hints
      controller.syncScenario(title: 'TED Talk or Presentation');
      expect(controller.selectedGoalTitle.value, equals('TED Talk or Presentation'));
      expect(controller.selectedScenarioSlug.value, equals('ted_talk_presentation'));
      expect(controller.roleFieldTitle.value, equals('What is your speaking topic or presentation?'));
      expect(
        controller.voiceQuestionTitle.value,
        equals('In your own words — what is your core message and why must this audience hear it?'),
      );

      // Verify initial form validation is false (Continue disabled)
      expect(controller.isFormValid.value, isFalse);

      // Verify user can enter text and form becomes valid (Continue enabled)
      controller.interviewKeywordsController.text = 'Keynote on Generative AI';
      expect(controller.isFormValid.value, isFalse); // Still missing role

      controller.roleApplyingController.text = 'Featured Speaker';
      expect(controller.isFormValid.value, isTrue); // Both filled -> enabled!

      expect(controller.interviewKeywordsController.text, equals('Keynote on Generative AI'));
      expect(controller.roleApplyingController.text, equals('Featured Speaker'));

      controller.onClose();
    });

    test('submitDetailsAndProceed automatically stops active voice recording', () async {
      final controller = StartStep2DetailsController();
      controller.onInit();

      controller.isRecording.value = true;
      controller.recordedAudioPath.value = '/test/step2_voice_answer.m4a';

      await controller.submitDetailsAndProceed();

      // Verify recording is stopped automatically
      expect(controller.isRecording.value, isFalse);
      expect(controller.recordedAudioPath.value, equals('/test/step2_voice_answer.m4a'));
      expect(controller.isProcessingBriefing.value, isTrue);

      controller.onClose();
    });
  });
}
