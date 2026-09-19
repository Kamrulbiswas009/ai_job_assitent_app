# SpeechPro AI Assessment & Onboarding Flow API Guide

This document provides the complete end-to-end integration and management guide for the AI-powered onboarding and assessment screens in the SpeechPro mobile application.

---

## 1. Architecture & Environment Overview

- **AI Backend Base URL**: `https://rosendo-vitiable-sari.ngrok-free.dev`
- **Standard Backend Base URL**: `https://studioequip-backend.vercel.app/api/v1`
- **Authentication**: JWT Bearer Token passed via HTTP Header:
  ```http
  Authorization: Bearer <accessToken>
  ```
- **State & Storage**:
  - `StorageService` (`lib/core/services/storage_service.dart`) handles token persistence and session data, including `assessmentId`.
  - Feature services live under `lib/features/start/service/`.
  - State management uses GetX controllers under `lib/features/start/controller/`.
  - Logging uses `AppLoggerHelper` (`lib/core/utils/logging/logger.dart`).

---

## 2. End-to-End Screen & API Flow

```mermaid
flowchart TD
    A["Step 1: Goals Screen\n(Pick Scenario)"] --> B["Step 2: Details Screen\n(Role, Goal, Voice Input)"]
    B -->|POST /api/v1/coaching/personal-briefing| C["Personal Briefing Screen\n(Displays AI Program)"]
    C --> D["Step 3: Self-Assessment Screen\n(Confidence, Authority, Communication)"]
    D -->|POST /api/v1/assessment/self-assessment| E["Step 4: Voice Calibration Screen\n(Record Voice Sample)"]
    E -->|POST /api/v1/assessment/{assessment_id}/voice| F["Score Calculation Modal\n(Animated Calculations)"]
    F -->|GET /api/v1/assessment/{assessment_id}/result| G["Step 5: Score Screen\n(Influence Score & Dimensions)"]
```

---

## 3. Screen-by-Screen Implementation & API Reference

### Step 1: Scenario & Goals Screen
- **Screen**: `StartStep1GoalsScreen` (`lib/features/start/presentation/screens/start_step1_goals_screen.dart`)
- **Controller**: `StartGoalsController` (`lib/features/start/controller/start_goals_controller.dart`)
- **Model**: `ScenarioConfig` (`lib/features/start/model/scenario_config.dart`)

#### How It Works
1. The user selects 1 of 18 available scenarios (e.g., Job Interview, Sales / Client Meeting, Investor Pitch, Keynote / Public Speaking).
2. Selecting a scenario sets `selectedGoal` and loads its corresponding `scenario_id` slug (e.g., `job_interview`, `sales_client_meeting`).
3. Tapping **Continue** navigates to Step 2, dynamically configuring Step 2's question titles and hints according to the chosen scenario.

---

### Step 2: Situation Details & AI Personal Briefing
- **Screens**:
  - `StartStep2DetailsScreen` (`lib/features/start/presentation/screens/start_step2_details_screen.dart`)
  - `StartBriefingScreen` (`lib/features/start/presentation/screens/start_briefing_screen.dart`)
- **Controllers**:
  - `StartStep2DetailsController` (`lib/features/start/controller/start_step2_details_controller.dart`)
  - `StartBriefingController` (`lib/features/start/controller/start_briefing_controller.dart`)
- **Service**: `BriefingService` (`lib/features/start/service/briefing_service.dart`)
- **Models**: `PersonalBriefingRequest`, `PersonalBriefingModel` (`lib/features/start/model/briefing_model.dart`)

#### API Endpoint
- **Method**: `POST`
- **URL**: `https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/coaching/personal-briefing`
- **Content-Type**: `multipart/form-data`

#### Headers
```http
accept: */*
Authorization: Bearer <accessToken>
```

#### Request Fields (Form Data)
| Field | Type | Required | Description | Example |
| :--- | :--- | :--- | :--- | :--- |
| `first_name` | `string` | Yes | User's first name | `Aycan` |
| `scenario_id` | `string` | Yes | Canonical slug from Step 1 | `job_interview` |
| `role` | `string` | Yes | Target role or current position | `Head of Marketing at Unilever` |
| `goal` | `string` | Yes | Primary outcome or goal | `Walk in with complete authority` |
| `description`| `string` | No | Additional context / text notes | `Technical round with the CTO` |
| `voice` | `file (audio)` | No | User's audio recording (`.m4a`, `.wav`, `.mp3`) | Audio binary |

#### cURL Request Example
```bash
curl -X POST "https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/coaching/personal-briefing" \
  -H "Authorization: Bearer <TOKEN>" \
  -F "first_name=Aycan" \
  -F "scenario_id=job_interview" \
  -F "role=Senior Full Stack Engineer" \
  -F "goal=Own decisions and speak with calm authority" \
  -F "description=Technical architecture review panel" \
  -F "voice=@/path/to/step2_voice_answer.m4a;type=audio/m4a"
```

#### Response (HTTP 200)
```json
{
  "whatWeHeard": "You're an app developer targeting a senior full stack developer position. This interview requires you to demonstrate technical breadth, architectural judgment, and leadership capability — not just coding proficiency.",
  "yourProgram": "SpeechPro will train you to establish immediate executive presence in technical interviews by replacing defensive over-explanation with calm, decisive authority.",
  "trainingPillar": {
    "name": "Authority Through Presence",
    "description": "Senior technical roles demand that you own the room from the moment you speak. Authority Through Presence teaches you to project decision-making confidence through vocal control."
  },
  "firstPrinciple": {
    "title": "Bottom Line Up Front",
    "description": "In high-stakes interviews, junior candidates build up to their point. Senior hires state their conclusion in the opening sentence."
  },
  "putItIntoPractice": {
    "title": "The Anchor Statement",
    "instruction": "Stand up. Say aloud in one declarative sentence the single strongest technical result from your work. No hedging — just the outcome. Then hold complete silence for two full seconds."
  }
}
```

#### UI Behavior & Transition
1. When user taps **Continue** in Step 2, active voice recording automatically stops and saves.
2. The controller sends the multipart request and displays the briefing preparation modal.
3. Upon completion, `StartBriefingController` populates the dynamic briefing data and displays `StartBriefingScreen`.
4. If offline or if the backend returns an unsupported scenario error, a tailored fallback briefing is loaded to guarantee smooth UX.

---

### Step 3: Starting Benchmark Self-Assessment
- **Screen**: `StartStep3AssessmentScreen` (`lib/features/start/presentation/screens/start_step3_assessment_screen.dart`)
- **Controller**: `StartAssessmentController` (`lib/features/start/controller/start_assessment_controller.dart`)
- **Service**: `AssessmentService` (`lib/features/start/service/assessment_service.dart`)
- **Model**: `SelfAssessmentRequest`, `SelfAssessmentResponse` (`lib/features/start/model/benchmark_model.dart`)

#### API Endpoint
- **Method**: `POST`
- **URL**: `https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/assessment/self-assessment`
- **Content-Type**: `application/json`

#### Scale Selector Mapping
The 5 pill options in `BenchmarkScaleSelector` map directly to backend enum values:
- `Index 0` -> `"rarely"`
- `Index 1` -> `"sometimes"`
- `Index 2` -> `"often"`
- `Index 3` -> `"usually"`
- `Index 4` -> `"always"`

#### Question to Field Mapping
1. **Question 1**: *"When speaking to a group or presenting, I feel confident"* -> `confidence`
2. **Question 2**: *"I communicate with authority — people listen when I speak"* -> `authority`
3. **Question 3**: *"People respond positively to how I communicate in key situations"* -> `communication`

#### Headers
```http
accept: */*
Content-Type: application/json
Authorization: Bearer <accessToken>
```

#### Request Body
```json
{
  "confidence": "sometimes",
  "authority": "rarely",
  "communication": "rarely"
}
```

#### cURL Request Example
```bash
curl -X POST "https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/assessment/self-assessment" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{
    "confidence": "sometimes",
    "authority": "rarely",
    "communication": "rarely"
  }'
```

#### Response (HTTP 200)
```json
{
  "success": true,
  "data": {
    "assessment_id": "265b829d-22af-4cbf-941e-4be1ac53c57d",
    "status": "voice_pending",
    "confidence": "sometimes",
    "authority": "rarely",
    "communication": "rarely"
  }
}
```

#### UI Behavior & Transition
1. User selects their 3 answers.
2. Tapping **Continue** shows a loading spinner on `SpPrimaryButton` and calls `submitSelfAssessment()`.
3. The returned `assessment_id` is automatically stored in `StorageService.saveAssessmentId(id)`.
4. Navigates to `AppRoute.startStep4Calibration`.

---

### Step 4: Voice Calibration & Calculation Progress
- **Screen**: `StartStep4CalibrationScreen` (`lib/features/start/presentation/screens/start_step4_calibration_screen.dart`)
- **Overlay**: `ScoreCalculationModal` (`lib/features/start/presentation/widgets/score_calculation_modal.dart`)
- **Controller**: `StartCalibrationController` (`lib/features/start/controller/start_calibration_controller.dart`)
- **Service**: `AssessmentService` (`lib/features/start/service/assessment_service.dart`)
- **Model**: `CalibrationVoiceResponse` (`lib/features/start/model/calibration_model.dart`)

#### 1. Voice Upload Endpoint
- **Method**: `POST`
- **URL**: `https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/assessment/{assessment_id}/voice`
- **Content-Type**: `multipart/form-data`

#### Path Parameter
- `assessment_id`: The UUID obtained from Step 3 (retrieved via `StorageService.assessmentId`).

#### Headers
```http
accept: */*
Authorization: Bearer <accessToken>
```

#### Request Body (Multipart)
| Key | Type | Description |
| :--- | :--- | :--- |
| `voice_file` | `file (audio)` | Microphone recording (`.m4a`, `.wav`, `.mp3`, `.ogg`, `.webm`) |

#### cURL Request Example
```bash
curl -X POST "https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/assessment/265b829d-22af-4cbf-941e-4be1ac53c57d/voice" \
  -H "Authorization: Bearer <TOKEN>" \
  -F "voice_file=@/path/to/calibration_voice.m4a;type=audio/m4a"
```

#### Response (HTTP 200)
```json
{
  "success": true,
  "assessment_id": "265b829d-22af-4cbf-941e-4be1ac53c57d",
  "status": "processing",
  "message": "Voice received. Calculating your score..."
}
```

#### 2. Calculation Status Polling Endpoint (Optional Background Poll)
- **Method**: `GET`
- **URL**: `https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/assessment/{assessment_id}/status`
- **Description**: Returns real-time status and calculation steps while `ScoreCalculationModal` animates.

#### Response Example
```json
{
  "assessment_id": "265b829d-22af-4cbf-941e-4be1ac53c57d",
  "status": "completed",
  "progress": 100,
  "steps": [
    {"name": "Analyzing your voice", "status": "completed"},
    {"name": "Measuring your delivery", "status": "completed"},
    {"name": "Comparing with your self assessment", "status": "completed"},
    {"name": "Calculating your Influence Score", "status": "completed"}
  ]
}
```

#### UI Behavior & Transition
1. User taps the recording card to record up to 60 seconds of voice.
2. User taps **Continue**:
   - If actively recording, it automatically stops and finalizes the audio file.
   - It submits the voice file to `POST /api/v1/assessment/{assessment_id}/voice`.
   - Opens `ScoreCalculationModal` to display the animated progress steps.
3. If user taps **Skip Voice calibration**:
   - Stops recording if active and immediately opens `ScoreCalculationModal`.
4. When `ScoreCalculationModal` finishes its calculation cycle, it navigates to `AppRoute.startStep5Score`.

---

### Step 5: Influence Score & Dimension Breakdown
- **Screen**: `StartStep5ScoreScreen` (`lib/features/start/presentation/screens/start_step5_score_screen.dart`)
- **Controller**: `StartScoreController` (`lib/features/start/controller/start_score_controller.dart`)
- **Service**: `AssessmentService` (`lib/features/start/service/assessment_service.dart`)
- **Model**: `AssessmentResultResponse`, `DimensionScores`, `AssessmentInterpretation`, `TrainingPath` (`lib/features/start/model/influence_score_model.dart`)

#### Result Fetch Endpoint
- **Method**: `GET`
- **URL**: `https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/assessment/{assessment_id}/result`
- **Description**: Step 5 — Fetch Influence Score and full result. Returns the Influence Score, 6 dimension scores, interpretation text, and training path. Only available when status == `'completed'`.

#### Path Parameters
| Name | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `assessment_id` | `string` | Yes | Assessment UUID (retrieved from `StorageService.assessmentId`) |

#### Headers
```http
accept: application/json
Authorization: Bearer <accessToken>
```

#### cURL Request Example
```bash
curl -X GET "https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/assessment/265b829d-22af-4cbf-941e-4be1ac53c57d/result" \
  -H "accept: application/json" \
  -H "Authorization: Bearer <TOKEN>"
```

#### Response (HTTP 200 Successful Response)
```json
{
  "assessment_id": "string",
  "influence_score": 100,
  "dimensions": {
    "confidence": 100,
    "presence": 100,
    "authority": 100,
    "leadership": 100,
    "persuasion": 100,
    "communication": 100
  },
  "interpretation": {
    "range": "string",
    "title": "string",
    "description": "string"
  },
  "training_path": {
    "pillar": "string",
    "focus_1": "string",
    "focus_2": "string"
  }
}
```

#### Field Schema Reference
- **`assessment_id`** (`string`): Unique assessment session identifier.
- **`influence_score`** (`int`): Composite score from 0 to 100.
- **`dimensions`** (`object`): 6 core vocal & presence dimensions:
  - `confidence` (`int`, 0-100)
  - `presence` (`int`, 0-100)
  - `authority` (`int`, 0-100)
  - `leadership` (`int`, 0-100)
  - `persuasion` (`int`, 0-100)
  - `communication` (`int`, 0-100)
- **`interpretation`** (`object`):
  - `range` (`string`): e.g. `"50-69"`
  - `title` (`string`): Benchmark level badge or callout headline, e.g. `"Developing"`
  - `description` (`string`): AI assessment narrative explaining instincts, gaps, and roadmap.
- **`training_path`** (`object`):
  - `pillar` (`string`): Recommended training pillar (e.g. `"Power Through Speech"`)
  - `focus_1` (`string`): Primary training focus (e.g. `"The Voice of Authority."`)
  - `focus_2` (`string`): Secondary training focus (e.g. `"Yi — The Power of Intent"`)

#### UI Behavior & Dynamic Binding
1. When `StartStep5ScoreScreen` loads, `StartScoreController` calls `fetchResult()`.
2. Overall Influence Score is bound dynamically (e.g. `59 / 100`) alongside the colored meter bar (`widthFactor = score / 100`).
3. The 6 dimension progress bars (Confidence, Presence, Authority, Leadership, Persuasion, Communication) animate dynamically to their respective percentages.
4. Interpretation card displays the dynamic assessment title and narrative.
5. Training path renders `PILLAR`, `FOCUS 1`, and `FOCUS 2` from the response.
6. If offline or calculation is still pending, high-fidelity fallback baseline data is displayed seamlessly without UI disruption.

---

## 4. Source Code Mapping

| File Path | Purpose |
| :--- | :--- |
| `lib/core/utils/constants/api_constants.dart` | Endpoint URL constants (`personalBriefing`, `selfAssessment`, `assessmentVoice`, `assessmentResult`) |
| `lib/core/services/storage_service.dart` | Local persistence of JWT `token` and `assessmentId` |
| `lib/core/utils/logging/logger.dart` | Structured console logging via `AppLoggerHelper` |
| `lib/core/common/widgets/sp_primary_button.dart` | Primary button with reactive `isLoading` state & spinner |
| `lib/features/start/model/scenario_config.dart` | 18 scenario configurations with titles, hints, and API slugs |
| `lib/features/start/model/briefing_model.dart` | Models for Personal Briefing request and response |
| `lib/features/start/model/benchmark_model.dart` | Models for Step 3 Self-Assessment (`SelfAssessmentRequest`/`Response`) |
| `lib/features/start/model/calibration_model.dart` | Models for Step 4 Voice Upload (`CalibrationVoiceResponse`) |
| `lib/features/start/model/influence_score_model.dart` | Models for Step 5 Result (`AssessmentResultResponse`, `DimensionScores`, `AssessmentInterpretation`, `TrainingPath`) |
| `lib/features/start/service/briefing_service.dart` | Multipart HTTP client for Personal Briefing |
| `lib/features/start/service/assessment_service.dart` | Service for Self-Assessment JSON POST, Voice Multipart POST, and Assessment Result GET |
| `lib/features/start/controller/start_step2_details_controller.dart` | Step 2 input handling, voice recording, and briefing trigger |
| `lib/features/start/controller/start_assessment_controller.dart` | Step 3 scale answer mapping and API submission |
| `lib/features/start/controller/start_calibration_controller.dart` | Step 4 60s voice recording, submission, and modal trigger |
| `lib/features/start/controller/start_score_controller.dart` | Step 5 reactive score, dimension breakdown, and training path controller |
| `lib/features/start/presentation/widgets/score_calculation_modal.dart` | Step 4 score calculation animation overlay |
| `lib/features/start/presentation/screens/start_step5_score_screen.dart` | Step 5 score breakdown screen dynamically bound with `Obx` |
| `test/assessment_api_test.dart` | Unit & integration tests for all assessment models, endpoints, and controllers |

---

## 5. Testing & Verification

Run the test suite to verify all endpoints, models, and controllers:
```bash
# Run assessment specific tests
flutter test test/assessment_api_test.dart

# Run full project test suite
flutter test

# Verify zero static analyzer issues
flutter analyze
```
