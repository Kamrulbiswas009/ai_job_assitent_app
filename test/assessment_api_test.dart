import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studioequip_mobile_app/core/services/storage_service.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_assessment_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_calibration_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_score_controller.dart';
import 'package:studioequip_mobile_app/features/start/model/benchmark_model.dart';
import 'package:studioequip_mobile_app/features/start/model/calibration_model.dart';
import 'package:studioequip_mobile_app/features/start/model/influence_score_model.dart';
import 'package:studioequip_mobile_app/features/start/service/assessment_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  group('SelfAssessment Models Tests', () {
    test('SelfAssessmentRequest serializes correctly to JSON', () {
      const request = SelfAssessmentRequest(
        confidence: 'rarely',
        authority: 'sometimes',
        communication: 'often',
      );

      final json = request.toJson();
      expect(json['confidence'], equals('rarely'));
      expect(json['authority'], equals('sometimes'));
      expect(json['communication'], equals('often'));

      final fromJson = SelfAssessmentRequest.fromJson(json);
      expect(fromJson.confidence, equals('rarely'));
      expect(fromJson.authority, equals('sometimes'));
      expect(fromJson.communication, equals('often'));
    });

    test('SelfAssessmentResponse parses user response format correctly', () {
      const responseStr = '''{
        "success": true,
        "data": {
          "assessment_id": "265b829d-22af-4cbf-941e-4be1ac53c57d",
          "status": "voice_pending",
          "confidence": "rarely",
          "authority": "rarely",
          "communication": "rarely"
        }
      }''';

      final Map<String, dynamic> jsonMap = jsonDecode(responseStr);
      final response = SelfAssessmentResponse.fromJson(jsonMap);

      expect(response.success, isTrue);
      expect(response.data, isNotNull);
      expect(
        response.data!.assessmentId,
        equals('265b829d-22af-4cbf-941e-4be1ac53c57d'),
      );
      expect(response.data!.status, equals('voice_pending'));
      expect(response.data!.confidence, equals('rarely'));
      expect(response.data!.authority, equals('rarely'));
      expect(response.data!.communication, equals('rarely'));
    });
  });

  group('AssessmentService Tests', () {
    test(
      'submitSelfAssessment sends correct JSON body and returns parsed response',
      () async {
        final mockClient = MockClient((request) async {
          expect(request.method, equals('POST'));
          expect(
            request.url.path,
            contains('/api/v1/assessment/self-assessment'),
          );
          expect(request.headers['Content-Type'], contains('application/json'));

          final body = jsonDecode(request.body);
          expect(body['confidence'], equals('sometimes'));
          expect(body['authority'], equals('often'));
          expect(body['communication'], equals('always'));

          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'assessment_id': 'test-uuid-1234',
                'status': 'voice_pending',
                'confidence': 'sometimes',
                'authority': 'often',
                'communication': 'always',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        });

        final service = AssessmentService(client: mockClient);
        const req = SelfAssessmentRequest(
          confidence: 'sometimes',
          authority: 'often',
          communication: 'always',
        );

        final result = await service.submitSelfAssessment(req);
        expect(result, isNotNull);
        expect(result!.success, isTrue);
        expect(result.data!.assessmentId, equals('test-uuid-1234'));
        expect(result.data!.status, equals('voice_pending'));
      },
    );

    test('submitSelfAssessment returns null on server error', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Internal Server Error'}),
          500,
        );
      });

      final service = AssessmentService(client: mockClient);
      const req = SelfAssessmentRequest(
        confidence: 'rarely',
        authority: 'rarely',
        communication: 'rarely',
      );

      final result = await service.submitSelfAssessment(req);
      expect(result, isNull);
    });
  });

  group('StorageService AssessmentId Tests', () {
    test('saveAssessmentId and assessmentId getter work accurately', () async {
      expect(StorageService.assessmentId, isNull);

      await StorageService.saveAssessmentId('assessment-abc-123');
      expect(StorageService.assessmentId, equals('assessment-abc-123'));

      await StorageService.logoutUser();
      expect(StorageService.assessmentId, isNull);
    });
  });

  group('StartAssessmentController Tests', () {
    test('setBenchmarkAnswer updates selectedIndex properly', () {
      final controller = StartAssessmentController();
      expect(controller.benchmarkQuestions[0].selectedIndex, isNull);

      controller.setBenchmarkAnswer(0, 4); // Always
      expect(controller.benchmarkQuestions[0].selectedIndex, equals(4));

      controller.setBenchmarkAnswer(1, 2); // Often
      expect(controller.benchmarkQuestions[1].selectedIndex, equals(2));
    });

    test(
      'submitAssessmentAndProceed saves assessment_id and handles success',
      () async {
        final mockClient = MockClient((request) async {
          final body = jsonDecode(request.body);
          expect(body['confidence'], equals('sometimes'));
          expect(body['authority'], equals('rarely'));
          expect(body['communication'], equals('rarely'));

          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'assessment_id': '265b829d-22af-4cbf-941e-4be1ac53c57d',
                'status': 'voice_pending',
                'confidence': 'sometimes',
                'authority': 'rarely',
                'communication': 'rarely',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        });

        final service = AssessmentService(client: mockClient);
        final controller = StartAssessmentController(
          assessmentService: service,
        );

        // Select answers to enable submission
        controller.setBenchmarkAnswer(0, 1); // sometimes
        controller.setBenchmarkAnswer(1, 0); // rarely
        controller.setBenchmarkAnswer(2, 0); // rarely

        expect(controller.isLoading.value, isFalse);
        expect(controller.assessmentId.value, isEmpty);

        await controller.submitAssessmentAndProceed();

        expect(controller.isLoading.value, isFalse);
        expect(
          controller.assessmentId.value,
          equals('265b829d-22af-4cbf-941e-4be1ac53c57d'),
        );
        expect(
          StorageService.assessmentId,
          equals('265b829d-22af-4cbf-941e-4be1ac53c57d'),
        );
      },
    );

    test(
      'submitAssessmentAndProceed handles offline server by creating fallback assessment_id',
      () async {
        final mockClient = MockClient((request) async {
          return http.Response('<!DOCTYPE html><html>Offline</html>', 404);
        });

        final service = AssessmentService(client: mockClient);
        final controller = StartAssessmentController(
          assessmentService: service,
        );

        controller.setBenchmarkAnswer(0, 0);
        controller.setBenchmarkAnswer(1, 1);
        controller.setBenchmarkAnswer(2, 2);

        await controller.submitAssessmentAndProceed();

        expect(controller.isLoading.value, isFalse);
        expect(controller.assessmentId.value, startsWith('fallback_'));
        expect(StorageService.assessmentId, startsWith('fallback_'));
      },
    );
  });

  group('CalibrationVoiceResponse Model Tests', () {
    test('CalibrationVoiceResponse parses json format accurately', () {
      const jsonStr = '''{
        "success": true,
        "assessment_id": "265b829d-22af-4cbf-941e-4be1ac53c57d",
        "status": "processing",
        "message": "Voice received. Calculating your score..."
      }''';

      final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      final model = CalibrationVoiceResponse.fromJson(jsonMap);

      expect(model.success, isTrue);
      expect(
        model.assessmentId,
        equals('265b829d-22af-4cbf-941e-4be1ac53c57d'),
      );
      expect(model.status, equals('processing'));
      expect(
        model.message,
        equals('Voice received. Calculating your score...'),
      );

      final jsonOut = model.toJson();
      expect(jsonOut['success'], isTrue);
      expect(
        jsonOut['assessment_id'],
        equals('265b829d-22af-4cbf-941e-4be1ac53c57d'),
      );
      expect(jsonOut['status'], equals('processing'));
      expect(
        jsonOut['message'],
        equals('Voice received. Calculating your score...'),
      );
    });
  });

  group('StartCalibrationController Tests', () {
    test('skipCalibration sets isCalculating to true', () async {
      final controller = StartCalibrationController();
      expect(controller.isCalculating.value, isFalse);

      await controller.skipCalibration();
      expect(controller.isCalculating.value, isTrue);
    });

    test('submitVoiceAndProceed without recorded file notifies user', () async {
      final controller = StartCalibrationController();
      controller.recordedAudioPath.value = '';

      await controller.submitVoiceAndProceed();
      // Should not start calculation if file is missing
      expect(controller.isCalculating.value, isFalse);
    });

    test(
      'submitVoiceAndProceed with existing file submits and activates isCalculating',
      () async {
        final tempDir = await Directory.systemTemp.createTemp('voice_test');
        final testFile = File('${tempDir.path}/test_voice.m4a');
        await testFile.writeAsString('test voice data');

        await StorageService.saveAssessmentId('test-calib-1234');

        final controller = StartCalibrationController();
        controller.recordedAudioPath.value = testFile.path;

        expect(controller.isCalculating.value, isFalse);
        await controller.submitVoiceAndProceed();

        expect(controller.isCalculating.value, isTrue);

        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      },
    );
  });

  group('AssessmentResultResponse Model Tests', () {
    test('AssessmentResultResponse parses full Step 5 JSON correctly', () {
      const jsonStr = '''{
        "assessment_id": "265b829d-22af-4cbf-941e-4be1ac53c57d",
        "influence_score": 75,
        "dimensions": {
          "confidence": 70,
          "presence": 80,
          "authority": 65,
          "leadership": 75,
          "persuasion": 85,
          "communication": 90
        },
        "interpretation": {
          "range": "70-89",
          "title": "Strong Command",
          "description": "You command the room effectively."
        },
        "training_path": {
          "pillar": "Executive Gravitas",
          "focus_1": "Decisive Framing",
          "focus_2": "Strategic Pauses"
        }
      }''';

      final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      final model = AssessmentResultResponse.fromJson(jsonMap);

      expect(
        model.assessmentId,
        equals('265b829d-22af-4cbf-941e-4be1ac53c57d'),
      );
      expect(model.influenceScore, equals(75));
      expect(model.dimensions.confidence, equals(70));
      expect(model.dimensions.presence, equals(80));
      expect(model.dimensions.authority, equals(65));
      expect(model.dimensions.leadership, equals(75));
      expect(model.dimensions.persuasion, equals(85));
      expect(model.dimensions.communication, equals(90));
      expect(model.interpretation.range, equals('70-89'));
      expect(model.interpretation.title, equals('Strong Command'));
      expect(
        model.interpretation.description,
        equals('You command the room effectively.'),
      );
      expect(model.trainingPath.pillar, equals('Executive Gravitas'));
      expect(model.trainingPath.focus1, equals('Decisive Framing'));
      expect(model.trainingPath.focus2, equals('Strategic Pauses'));
    });
  });

  group('StartScoreController Tests', () {
    test(
      'fetchResult loads data from AssessmentService and updates reactive state',
      () async {
        final mockClient = MockClient((request) async {
          expect(request.method, equals('GET'));
          expect(
            request.url.path,
            contains('/api/v1/assessment/test-result-1234/result'),
          );

          return http.Response(
            jsonEncode({
              'assessment_id': 'test-result-1234',
              'influence_score': 82,
              'dimensions': {
                'confidence': 85,
                'presence': 80,
                'authority': 78,
                'leadership': 88,
                'persuasion': 82,
                'communication': 80,
              },
              'interpretation': {
                'range': '80-100',
                'title': 'High Authority',
                'description': 'Exceptional natural command.',
              },
              'training_path': {
                'pillar': 'Pacing Mastery',
                'focus_1': 'Cadence Control',
                'focus_2': 'Unshakable Frame',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        });

        await StorageService.saveAssessmentId('test-result-1234');
        final service = AssessmentService(client: mockClient);
        final controller = StartScoreController(assessmentService: service);
        await controller.fetchResult();

        expect(controller.startingInfluenceScore, equals(82));
        expect(controller.dimensions.confidence, equals(85));
        expect(controller.dimensions.presence, equals(80));
        expect(controller.interpretation.title, equals('High Authority'));
        expect(controller.trainingPath.pillar, equals('Pacing Mastery'));
      },
    );
  });
}
