# StudioEquip (SpeechPro) Mobile App - Master Project Rules & Architecture Guidelines

> **Project Name:** `studioequip_mobile_app`  
> **Brand Identity:** SpeechPro / StudioEquip  
> **Target Framework:** Flutter (Dart SDK `^3.11.5`)  
> **Design Canvas Reference:** iPhone 14/15 Pro Max (`428 x 932`)

---

## 1. Core Tech Stack & Key Dependencies

| Category | Package / Tool | Version / Purpose |
| :--- | :--- | :--- |
| **Framework** | `Flutter` / `Dart` | Core Mobile Application SDK |
| **State Management & Routing** | `get` (`^4.6.6`) | Reactive state, navigation, dependency injection |
| **Responsiveness** | `flutter_screenutil` (`^5.9.3`) | Screen adaptation (Design Size: `428 x 932`) |
| **Typography** | `google_fonts` (`^6.2.1`) | `Inter` / `Poppins` font families |
| **Icons & Media** | `flutter_svg` (`^2.3.0`), `iconsax`, `cupertino_icons` | Vector SVG & Iconography |
| **Voice & Audio Recording** | `record` (`^7.1.1`), `path_provider` (`^2.1.6`), `permission_handler` (`^13.0.2`) | Real audio recording (.m4a AAC) & microphone permissions |
| **Networking** | `http` (`^1.1.0`), `web_socket_channel` (`^3.0.1`) | REST API & Real-time WebSockets |
| **Serialization** | `json_annotation`, `json_serializable`, `build_runner` | Strongly typed model parsing |
| **Local Storage** | `shared_preferences` (`^2.3.2`) | Token, user settings & session cache |
| **Feedback / Toast** | `flutter_easyloading` (`^3.0.5`), `logger` | Loaders, toasts, and debug logging |

---

## 2. Project Directory Structure

The project strictly follows a **Feature-First / Modular Architecture**:

```
lib/
├── app.dart                             # App initialization, ThemeMode, ScreenUtilInit, GetMaterialApp
├── main.dart                            # Flutter main entry point
│
├── core/                                # Shared logic, utilities, services, and common widgets
│   ├── bindings/
│   │   └── controller_binder.dart       # Global GetX bindings & dependency injection
│   ├── common/
│   │   ├── styles/                      # Global text styles & typography builders
│   │   └── widgets/                     # Reusable global UI widgets
│   │       ├── sp_primary_button.dart   # Global standard primary button
│   │       ├── custom_card_text_field.dart # Global standard single/multi-line card text field
│   │       ├── custom_button.dart       # Core custom button widget
│   │       ├── custom_text_field.dart   # Core input field
│   │       └── custom_toast.dart        # Toast notifications
│   ├── datetime_formate/                # Date and time formatting helpers
│   ├── localization/                    # Localization and i18n configurations
│   ├── models/
│   │   └── response_data.dart           # Unified API response wrapper model
│   ├── services/
│   │   ├── firebase/                    # Push notifications (FCM), notification services
│   │   ├── network_caller.dart          # HTTP client (GET, POST, PUT, DELETE) with error handling
│   │   ├── storage_service.dart         # SharedPreferences abstraction
│   │   └── websoketMathod/              # Real-time WebSocket connection handling
│   └── utils/
│       ├── constants/
│       │   ├── api_constants.dart       # API endpoints & base URLs
│       │   ├── app_texts.dart           # Static string constants
│       │   ├── colors.dart              # AppColors (Primary, Neutral, Status, Theme colors)
│       │   ├── enums.dart               # Global enums
│       │   ├── icon_path.dart           # Icon asset string paths (icMic, icBack, etc.)
│       │   ├── image_path.dart          # Image asset string paths (logoHeader, confetti, etc.)
│       │   └── sizer.dart               # Spacing & sizing constants
│       ├── device/                      # Screen & device utility functions
│       ├── formatters/                  # Input & string formatters
│       ├── helpers/                     # Helper functions & dialog utilities
│       ├── logging/                     # Logger configuration
│       ├── theme/                       # Light & Dark theme definitions
│       └── validators/                  # Form input validation rules
│
├── features/                            # Feature modules
│   ├── authentication/
│   │   ├── controller/                  # GetxControllers for Auth
│   │   ├── model/                       # Data models & DTOs
│   │   └── presentation/
│   │       ├── screens/                 # Auth screens (Login, Register, OTP, Reset)
│   │       └── widgets/                 # Auth-specific widgets
│   ├── onboarding/                      # Onboarding, Speech Pro Intro & Uses of AI
│   │   ├── controller/
│   │   └── presentation/screens/        # onboarding_screen.dart, uses_of_ai_screen.dart, etc.
│   ├── start/                           # Start Flow / Modular Feature (Steps 1 to 5 + Briefing)
│   │   ├── controller/                  # Modular GetxControllers per step
│   │   │   ├── start_membership_controller.dart     # Membership intro & confetti
│   │   │   ├── start_goals_controller.dart          # Step 1: Goals list & selection API
│   │   │   ├── start_step2_details_controller.dart  # Step 2: Role, keywords, voice submission API
│   │   │   ├── start_briefing_controller.dart       # Briefing: Loading & AI generation API
│   │   │   ├── start_assessment_controller.dart     # Step 3: Benchmark assessment questions API
│   │   │   ├── start_calibration_controller.dart    # Step 4: Voice calibration recording & upload API
│   │   │   └── start_score_controller.dart          # Step 5: Influence score & training path API
│   │   ├── model/                       # Modular Typed Models with JSON serialization
│   │   │   ├── goal_model.dart                      # GoalCategoryModel (fromJson/toJson)
│   │   │   ├── goal_details_model.dart              # GoalDetailsModel
│   │   │   ├── briefing_model.dart                  # PersonalBriefingModel & BriefingPillarModel
│   │   │   ├── benchmark_model.dart                 # BenchmarkQuestionModel
│   │   │   ├── calibration_model.dart               # VoiceCalibrationModel
│   │   │   ├── influence_score_model.dart           # InfluenceScoreModel & TrainingPathInfo
│   │   │   └── start_models.dart                    # Barrel export file
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── start_membership_intro_screen.dart # Intro + Confetti + 3 Pillars
│   │       │   ├── start_step1_goals_screen.dart      # 18 Goal items selection
│   │       │   ├── start_step2_details_screen.dart    # Role details & voice answer
│   │       │   ├── start_briefing_screen.dart         # AI loading + Personal Briefing
│   │       │   ├── start_step3_assessment_screen.dart # 3 Benchmark questions
│   │       │   ├── start_step4_calibration_screen.dart# Voice calibration & waveform
│   │       │   └── start_step5_score_screen.dart      # Influence score gauge + Training plan
│   │       └── widgets/
│   │           ├── start_header.dart                  # Header with back, 333x96 logo & 5-step bar
│   │           ├── goal_item_tile.dart                # Goal card item
│   │           ├── voice_recorder_card.dart           # Real voice recorder & waveform widget
│   │           ├── benchmark_scale_selector.dart      # 1-to-5 scale selector
│   │           └── influence_score_gauge.dart         # Influence score radial gauge
│   ├── home/                            # Home screen & Dashboard
│   ├── practice/                        # Voice & Audio Practice Sessions
│   ├── critique/                        # AI Speech Analysis & Critiques
│   ├── progress/                        # User Progress & Analytics
│   └── profile/                         # User Profile, Notifications & Settings
│
└── routes/
    └── app_routes.dart                  # Route constants & GetPage route tables
```

---

## 3. Architecture & Code Conventions

### 3.1. State Management & GetX Rules
- **Decoupled Business Logic:** UI `StatelessWidget` / `StatefulWidget` files must not contain raw state mutations or direct business logic. Delegate all logic, form states, and audio recording to the respective `<Feature>Controller` extending `GetxController`.
- **Reactive State:** Use `.obs` variables (`RxString`, `RxBool`, `RxInt`, `RxList`, `Rx<T>`) and `Obx(() => ...)` for granular UI updates.
- **GetX In-Tree Construction Gotcha:** Avoid putting `ListView.builder` inside `Obx` if the list is static/pre-defined to avoid initial build "no observable found" exceptions. Use `Column` with `.map()` inside `Obx` or standard `GetBuilder`.
- **Dependency Injection:** 
  - Register permanent/shared controllers in `ControllerBinder` (`lib/core/bindings/controller_binder.dart`) using `Get.lazyPut(..., fenix: true)`.
  - Feature-specific controllers should be bound either via route bindings or initialized lazily.
- **Navigation:** Use named routes via GetX (`Get.toNamed(AppRoute.screenName)`, `Get.offAllNamed(...)`, `Get.back()`).

### 3.2. Global Reusable Widgets Protocol
- **Primary Buttons:** Always use `SpPrimaryButton` (`lib/core/common/widgets/sp_primary_button.dart`) for screen action buttons with standard height (`56.h`), full width, `AppColors.primary` background, rounded corners (`12.r` or `14.r`), and `GoogleFonts.inter` typography.
- **Form & Card TextFields:** Always use `CustomCardTextField` (`lib/core/common/widgets/custom_card_text_field.dart`).
  - Do **NOT** wrap `TextField` inside a fixed-height `Container`.
  - Use single `TextFormField` configured with `OutlineInputBorder`, `filled: true`, `fillColor: Colors.transparent` or `AppColors.white`, `minLines`, and `maxLines`.
  - Default unselected border color: `#E5E5EA` (`16.r`).
  - Active/focused border color: `AppColors.primary` (`#CC0000`).
- **Start Flow Header:** Always use `StartHeader(currentStep: X)` (`lib/features/start/presentation/widgets/start_header.dart`) for 5-step flow screens.
  - Circular back button: 36x36 with `assets/icons/ic_back.svg`.
  - Logo: 333x96 via `assets/images/logo_header.png`.
  - Step Progress Bar: 5 animated segments (`AppColors.primary` for active/completed, `#E5E5EA` for upcoming).

### 3.3. Audio Recording & Microphone Permissions
- **Library:** Use `package:record/record.dart` (`AudioRecorder`).
- **Configuration:**
  - Android permission: `android.permission.RECORD_AUDIO` registered in `android/app/src/main/AndroidManifest.xml`.
  - iOS permission: `NSMicrophoneUsageDescription` registered in `ios/Runner/Info.plist`.
- **Recording Implementation:**
  - Check permission with `audioRecorder.hasPermission()`.
  - Save audio files as `.m4a` AAC to `getApplicationDocumentsDirectory()`.
  - Provide fallback error handling so UI timers and state transitions function smoothly in all environments.
  - Always dispose `AudioRecorder` in `onClose()`.
- **Icon Asset:** Always use `IconPath.icMic` (`assets/icons/ic_mic.svg`) inside recording action buttons.

### 3.4. Responsive UI & Layout Rules (`ScreenUtil`)
- **Base Canvas:** The UI design is strictly tailored to **428 x 932 px** (`ScreenUtilInit` in `app.dart`).
- **Always Apply ScreenUtil Extensions:**
  - Widths / horizontal paddings / margins: `.w` (e.g., `20.w`)
  - Heights / vertical paddings / spacings: `.h` (e.g., `16.h`, `SizedBox(height: 24.h)`)
  - Border Radii: `.r` (e.g., `BorderRadius.circular(16.r)`)
  - Font sizes: `.sp` (e.g., `fontSize: 14.sp`)
- **Never Hardcode Fixed Dimensions** without `.w`, `.h`, `.r`, or `.sp`.

### 3.5. Colors & Styling Guidelines
- **Color Centralization:** All colors must be referenced through `AppColors` from `lib/core/utils/constants/colors.dart`.
  - Primary Brand Red: `AppColors.primary` (`#CC0000`)
  - Neutral Black / Surface Dark: `AppColors.black` (`#0A0A0A`), `AppColors.pureBlack` (`#000000`)
  - Surface Background: `AppColors.white`, `AppColors.surfaceGray` (`#F7F7F7`)
  - Gray Text / Borders: `AppColors.gray` (`#888888`), `Color(0xFFE5E5EA)`
- **Typography:**
  - Standard font family: `GoogleFonts.inter` (or `GoogleFonts.poppins`).
  - Explicitly define `fontSize`, `fontWeight`, `color`, and `height` (line-height).

### 3.6. Assets & Icon Management
- **Never Hardcode Asset Paths** directly in widgets.
  - Image paths must be added to `ImagePath` (`lib/core/utils/constants/image_path.dart`).
  - Icon paths must be added to `IconPath` (`lib/core/utils/constants/icon_path.dart`).
- Use `SvgPicture.asset()` for `.svg` files and `Image.asset()` for `.png` / `.jpg` files.

### 3.7. Clean Code & Dart Standards
- Always declare constructors with `const` where possible.
- Avoid large monolithic build methods — break screens down into smaller private or feature widgets in `presentation/widgets/`.
- Use strong null-safety practices and typed model parsing (`fromJson` / `toJson`).
- Clean up controllers, text controllers, stream subscriptions, and timer listeners in `onClose()`.

---

## 4. Route Definition Protocol

When creating a new screen:
1. Define the route constant in `AppRoute` (`lib/routes/app_routes.dart`).
2. Add the `GetPage` entry with the page widget and optional binding in `AppRoute.routes`.
3. Use `Get.toNamed(AppRoute.<routeName>)` for navigation.

### Start Flow Routes Reference:
- `AppRoute.startMembershipIntro`: `/start_membership_intro` (Intro + Confetti + 3 Pillars)
- `AppRoute.startStep1Goals`: `/start_step1_goals` (18 Goals selection)
- `AppRoute.startStep2Details`: `/start_step2_details` (Role keywords + Voice recording)
- `AppRoute.startBriefing`: `/start_briefing` (Checklist animation -> AI Personal Briefing)
- `AppRoute.startStep3Assessment`: `/start_step3_assessment` (3 Benchmark questions)
- `AppRoute.startStep4Calibration`: `/start_step4_calibration` (Voice calibration & waveform)
- `AppRoute.startStep5Score`: `/start_step5_score` (Influence Score 59/100 + Training Plan)

---

## 5. Development Workflow Checklist

Before committing or finishing a feature:
- [ ] UI accurately matches Figma specifications (`node-id` designs).
- [ ] All dimensions, fonts, and paddings use `ScreenUtil` (`.w`, `.h`, `.sp`, `.r`).
- [ ] Reusable global widgets (`SpPrimaryButton`, `CustomCardTextField`, `StartHeader`) are used.
- [ ] No hardcoded colors or asset path strings (use `AppColors`, `IconPath`, `ImagePath`).
- [ ] Business logic, timers, and state reside in GetX controllers.
- [ ] All controllers, text editing controllers, and audio streams are cleaned up in `onClose()`.
- [ ] Route is registered in `AppRoute`.
- [ ] Code passes Flutter linter without warnings (`flutter analyze`).
