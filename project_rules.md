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
| **Icons & Media** | `flutter_svg`, `iconsax`, `cupertino_icons` | Vector icons & iconography |
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
│   │   └── widgets/                     # Reusable global UI widgets (buttons, cards, headers)
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
│       │   ├── icon_path.dart           # Icon asset string paths
│       │   ├── image_path.dart          # Image asset string paths
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
│   │       └── widgets/                 # Feature-specific widgets
│   ├── onboarding/                      # Onboarding, Speech Pro Intro & Plans
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
- **Decoupled Business Logic:** UI `StatelessWidget` / `StatefulWidget` files must not contain API calls or raw state mutations. Delegate all logic, form states, and API executions to the respective `<Feature>Controller` extending `GetxController`.
- **Reactive State:** Use `.obs` variables (`RxString`, `RxBool`, `Rx<T>`) and `Obx(() => ...)` or `GetBuilder` for granular UI updates.
- **Dependency Injection:** 
  - Register permanent/shared controllers in `ControllerBinder` (`lib/core/bindings/controller_binder.dart`) using `Get.lazyPut(..., fenix: true)`.
  - Feature-specific controllers should be bound either via route bindings or initialized lazily.
- **Navigation:** Use named routes via GetX (`Get.toNamed(AppRoute.screenName)`, `Get.offAllNamed(...)`, `Get.back()`).

### 3.2. Responsive UI & Layout Rules (`ScreenUtil`)
- **Base Canvas:** The UI design is tailored to **428 x 932 px** (`ScreenUtilInit` in `app.dart`).
- **Always Apply ScreenUtil Extensions:**
  - Widths / horizontal paddings / margins: `.w` (e.g., `20.w`)
  - Heights / vertical paddings / spacings: `.h` (e.g., `16.h`, `SizedBox(height: 24.h)`)
  - Border Radii: `.r` (e.g., `BorderRadius.circular(12.r)`)
  - Font sizes: `.sp` (e.g., `fontSize: 16.sp`)
- **Never Hardcode Fixed Dimensions** without `.w`, `.h`, `.r`, or `.sp`.

### 3.3. Colors & Styling Guidelines
- **Color Centralization:** All colors must be referenced through `AppColors` from `lib/core/utils/constants/colors.dart`.
  - Primary Brand Red: `AppColors.primary` (`#CC0000`)
  - Neutral Black / Surface Dark: `AppColors.black` (`#0A0A0A`), `AppColors.pureBlack` (`#000000`)
  - Surface Background: `AppColors.white`, `AppColors.surfaceGray` (`#F7F7F7`)
  - Gray Text / Borders: `AppColors.gray` (`#888888`), `AppColors.border`, `AppColors.placeholder`
- **Typography:**
  - Standard font family: `GoogleFonts.inter` or `GoogleFonts.poppins` / `getTextStyle()`.
  - Explicitly define `fontSize`, `fontWeight`, `color`, and `height` (line-height).

### 3.4. Assets & Icon Management
- **Never Hardcode Asset Paths** directly in widgets.
  - Image paths must be added to `ImagePath` (`lib/core/utils/constants/image_path.dart`).
  - Icon paths must be added to `IconPath` (`lib/core/utils/constants/icon_path.dart`).
- Use `SvgPicture.asset()` for `.svg` files and `Image.asset()` for `.png` / `.jpg` files.

### 3.5. Networking & Error Handling
- **Unified Client:** Use `NetworkCaller` (`lib/core/services/network_caller.dart`) for HTTP requests.
- **Response Format:** All API calls must return `ResponseData` with fields `isSuccess`, `statusCode`, `responseData`, `errorMessage`.
- **Loading & Toasts:** Display loading states using `EasyLoading.show()` or controller-level `RxBool isLoading`. Present clear error messages to users via SnackBars or EasyLoading error toasts.

### 3.6. Clean Code & Dart Standards
- Always declare constructors with `const` where possible.
- Avoid large monolithic build methods — break screens down into smaller private or feature widgets in `presentation/widgets/`.
- Use strong null-safety practices and typed model parsing (`fromJson` / `toJson`).
- Clean up controllers, text controllers, stream subscriptions, and timer listeners in `onClose()`.

---

## 4. Route Definition Protocol

When creating a new screen:
1. Define the route constant in `AppRoute` (`lib/routes/app_routes.dart`).
2. Add the `GetPage` entry with the page widget and optional binding.
3. Use `Get.toNamed(AppRoute.<routeName>)` for navigation.

---

## 5. Development Workflow Checklist

Before committing or finishing a feature:
- [ ] UI accurately matches Figma specifications (`node-id` designs).
- [ ] All dimensions, fonts, and paddings use `ScreenUtil` (`.w`, `.h`, `.sp`, `.r`).
- [ ] No hardcoded colors or asset path strings.
- [ ] Business logic and state reside in GetX controllers.
- [ ] Route is registered in `AppRoute`.
- [ ] Code passes Flutter linter without warnings (`flutter analyze`).
