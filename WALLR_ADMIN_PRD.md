# WALLR Admin Panel — Product Requirements Document
## Flutter Web | Production-Ready | v1.0

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [Design System — Executive Dark Admin](#3-design-system)
4. [Folder Structure](#4-folder-structure)
5. [Packages](#5-packages)
6. [Firebase Connection](#6-firebase-connection)
7. [Cloudinary Integration](#7-cloudinary-integration)
8. [Firestore Data Model](#8-firestore-data-model)
9. [Pages & Features](#9-pages--features)
10. [Navigation & Routing](#10-navigation--routing)
11. [State Management — BLoC](#11-state-management--bloc)
12. [Responsive Layout Strategy](#12-responsive-layout-strategy)
13. [Development Sequence](#13-development-sequence)

---

## 1. Project Overview

**App Name:** WALLR Admin Panel  
**Platform:** Flutter Web (Desktop + Tablet + Mobile web views)  
**Purpose:** Admin control center for managing wallpapers, users, collections, categories, subscriptions, analytics, notifications, and announcements.  
**Backend:** Same Firebase project as WALLR user app  
**Image Storage:** Cloudinary (same account as user app)  
**Theme:** Dark only — Executive Dark Admin design system  

### Key Principle
> Keep it simple. No over-engineering. Clean Architecture but without unnecessary abstraction layers. Admin is a tool — it should work fast and be easy to maintain.

---

## 2. Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter Web (SDK ^3.10.0) |
| Backend | Firebase — same project as user app |
| Auth | Firebase Auth (email only — admin login) |
| Database | Cloud Firestore |
| Image Storage | Cloudinary (upload via Dio + REST API) |
| State Management | Flutter BLoC (`flutter_bloc`) |
| Navigation | GoRouter |
| Responsive | `flutter_adaptive_scaffold` or `responsive_framework` |
| HTTP | Dio (Cloudinary upload) |
| Charts | `fl_chart` |
| DI | GetIt |
| Environment | `flutter_dotenv` |
| Icons | Material Icons (Google Fonts) |
| Fonts | Inter via `google_fonts` |
| Tables | `data_table_2` |
| File Picker | `file_picker` (web supported) |
| Equality | `equatable` |
| UUID | `uuid` |
| Dates | `intl` |

---

## 3. Design System

### Color Tokens

```dart
// lib/core/constants/admin_colors.dart

abstract final class AdminColors {

  // ── Backgrounds & Surfaces ──────────────────────────────────
  static const background      = Color(0xFF0F0F0F);  // Main canvas
  static const sidebar         = Color(0xFF141414);  // Fixed sidebar
  static const surface         = Color(0xFF1A1A1A);  // Cards, containers
  static const surfaceElevated = Color(0xFF1E1E1E);  // Table alternate rows
  static const inputSurface    = Color(0xFF222222);  // Input fields
  static const topBar          = Color(0xFF141414);  // Top bar

  // ── Borders ─────────────────────────────────────────────────
  static const border          = Color(0xFF2A2A2A);  // All borders — 1px

  // ── Text ────────────────────────────────────────────────────
  static const textPrimary     = Color(0xFFFFFFFF);  // Headlines, main
  static const textSecondary   = Color(0xFF9CA3AF);  // Body, descriptions
  static const textTertiary    = Color(0xFF6B7280);  // Captions, hints

  // ── Primary — Gold ──────────────────────────────────────────
  static const gold            = Color(0xFFF5C518);  // Primary action
  static const goldDim         = Color(0xFFD4A017);  // Hover state
  static const onGold          = Color(0xFF000000);  // Text on gold button

  // ── Status / Functional ─────────────────────────────────────
  static const success         = Color(0xFF22C55E);  // Active, online
  static const successBg       = Color(0xFF052E16);  // Success badge bg
  static const warning         = Color(0xFFF59E0B);  // Warning
  static const warningBg       = Color(0xFF1C1107);  // Warning badge bg
  static const error           = Color(0xFFEF4444);  // Error, delete
  static const errorBg         = Color(0xFF1F0707);  // Error badge bg
  static const info            = Color(0xFF3B82F6);  // Info
  static const infoBg          = Color(0xFF030B1A);  // Info badge bg

  // ── Misc ─────────────────────────────────────────────────────
  static const premium         = Color(0xFFFFD700);  // Premium badge
  static const free            = Color(0xFF6B7280);  // Free badge
  static const divider         = Color(0xFF1F1F1F);  // Section dividers
}
```

### Typography

```dart
// lib/core/constants/admin_text_styles.dart
// All use Inter font via google_fonts

// display    → 32sp, w700, ls: -0.02em   (page titles)
// headlineLg → 24sp, w600, ls: -0.01em   (section headers)
// headlineMd → 20sp, w600               (card titles)
// bodyLg     → 16sp, w400               (table content)
// bodyMd     → 14sp, w400               (descriptions)
// bodySm     → 12sp, w400               (captions)
// labelLg    → 14sp, w600, ls: 0.01em   (button text, table headers)
// labelMd    → 12sp, w500               (badges, chips)
// labelSm    → 11sp, w500               (status text)
```

### Layout Rules

```
Sidebar:      260px fixed width
TopBar:       64px fixed height
Content pad:  32px all sides (desktop), 16px (mobile)
Card radius:  12px
Button/Input: 8px radius
Badge/Chip:   6px radius
Border:       1px solid #2A2A2A everywhere
Gutter:       24px
```

### Responsive Breakpoints

```
Desktop:  > 1200px  → Sidebar visible + full layout
Tablet:   768–1200px → Sidebar collapsible (icon only)
Mobile:   < 768px   → Sidebar hidden (drawer)
```

---

## 4. Folder Structure

```
wallr_admin/
├── .env
├── pubspec.yaml
├── web/
│   └── index.html
│
└── lib/
    ├── main.dart
    │
    ├── config/
    │   ├── di/
    │   │   └── injection.dart           # GetIt setup
    │   └── routes/
    │       ├── app_router.dart          # GoRouter config
    │       └── route_names.dart         # Route constants
    │
    ├── core/
    │   ├── constants/
    │   │   ├── admin_colors.dart        # All color tokens
    │   │   ├── admin_text_styles.dart   # Typography
    │   │   ├── admin_dimensions.dart    # Spacing, radius
    │   │   └── admin_strings.dart       # All UI strings
    │   ├── error/
    │   │   ├── failures.dart
    │   │   └── exceptions.dart
    │   ├── network/
    │   │   └── network_info.dart
    │   ├── theme/
    │   │   └── admin_theme.dart         # ThemeData dark
    │   ├── utils/
    │   │   ├── cloudinary_service.dart  # Upload via Dio
    │   │   ├── date_formatter.dart
    │   │   └── validators.dart
    │   └── widgets/
    │       ├── admin_sidebar.dart       # Fixed sidebar
    │       ├── admin_topbar.dart        # Top bar
    │       ├── admin_shell.dart         # Shell = sidebar + topbar + content
    │       ├── admin_card.dart          # Standard card container
    │       ├── admin_button.dart        # Primary/Secondary/Ghost buttons
    │       ├── admin_text_field.dart    # Input field
    │       ├── admin_badge.dart         # Status badge
    │       ├── admin_table.dart         # Reusable data table wrapper
    │       ├── stat_card.dart           # Dashboard metric cards
    │       └── loading_widget.dart      # Centered loader
    │
    └── features/
        ├── auth/
        │   ├── data/
        │   │   ├── datasources/admin_auth_datasource.dart
        │   │   └── repositories/admin_auth_repository_impl.dart
        │   ├── domain/
        │   │   ├── entities/admin_user_entity.dart
        │   │   ├── repositories/admin_auth_repository.dart
        │   │   └── usecases/
        │   │       ├── sign_in_usecase.dart
        │   │       └── sign_out_usecase.dart
        │   └── presentation/
        │       ├── bloc/
        │       │   ├── auth_bloc.dart
        │       │   ├── auth_event.dart
        │       │   └── auth_state.dart
        │       └── pages/
        │           └── login_page.dart
        │
        ├── dashboard/
        │   ├── data/
        │   │   ├── datasources/dashboard_datasource.dart
        │   │   └── repositories/dashboard_repository_impl.dart
        │   ├── domain/
        │   │   ├── entities/dashboard_stats_entity.dart
        │   │   ├── repositories/dashboard_repository.dart
        │   │   └── usecases/get_dashboard_stats_usecase.dart
        │   └── presentation/
        │       ├── bloc/
        │       │   ├── dashboard_bloc.dart
        │       │   ├── dashboard_event.dart
        │       │   └── dashboard_state.dart
        │       └── pages/
        │           └── dashboard_page.dart
        │
        ├── wallpapers/
        │   ├── data/
        │   │   ├── datasources/wallpaper_datasource.dart
        │   │   ├── models/wallpaper_model.dart
        │   │   └── repositories/wallpaper_repository_impl.dart
        │   ├── domain/
        │   │   ├── entities/wallpaper_entity.dart
        │   │   ├── repositories/wallpaper_repository.dart
        │   │   └── usecases/
        │   │       ├── get_wallpapers_usecase.dart
        │   │       ├── upload_wallpaper_usecase.dart
        │   │       ├── update_wallpaper_usecase.dart
        │   │       └── delete_wallpaper_usecase.dart
        │   └── presentation/
        │       ├── bloc/
        │       │   ├── wallpaper_bloc.dart
        │       │   ├── wallpaper_event.dart
        │       │   └── wallpaper_state.dart
        │       └── pages/
        │           ├── manage_wallpapers_page.dart
        │           └── upload_wallpaper_page.dart
        │
        ├── categories/
        │   ├── data/ ...
        │   ├── domain/ ...
        │   └── presentation/
        │       ├── bloc/ ...
        │       └── pages/
        │           └── categories_page.dart
        │
        ├── collections/
        │   ├── data/ ...
        │   ├── domain/ ...
        │   └── presentation/
        │       ├── bloc/ ...
        │       └── pages/
        │           └── collections_page.dart
        │
        ├── featured/
        │   ├── data/ ...
        │   ├── domain/ ...
        │   └── presentation/
        │       ├── bloc/ ...
        │       └── pages/
        │           └── featured_content_page.dart
        │
        ├── users/
        │   ├── data/ ...
        │   ├── domain/ ...
        │   └── presentation/
        │       ├── bloc/ ...
        │       └── pages/
        │           └── users_page.dart
        │
        ├── analytics/
        │   └── presentation/
        │       ├── bloc/ ...
        │       └── pages/
        │           └── analytics_page.dart
        │
        ├── subscriptions/
        │   └── presentation/
        │       ├── bloc/ ...
        │       └── pages/
        │           └── subscriptions_page.dart
        │
        ├── notifications/
        │   └── presentation/
        │       ├── bloc/ ...
        │       └── pages/
        │           └── notifications_page.dart
        │
        ├── announcements/
        │   └── presentation/
        │       ├── bloc/ ...
        │       └── pages/
        │           └── announcements_page.dart
        │
        └── settings/
            └── presentation/
                ├── bloc/ ...
                └── pages/
                    └── settings_page.dart
```

---

## 5. Packages

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase — same project as user app
  firebase_core: ^3.x.x
  firebase_auth: ^5.x.x
  cloud_firestore: ^5.x.x

  # State Management
  flutter_bloc: ^9.x.x
  bloc: ^9.x.x
  equatable: ^2.x.x

  # Navigation
  go_router: ^14.x.x

  # DI
  get_it: ^8.x.x

  # Responsive — Web specific
  responsive_framework: ^1.x.x

  # HTTP — Cloudinary upload
  dio: ^5.x.x

  # Charts
  fl_chart: ^0.x.x

  # Tables
  data_table_2: ^2.x.x

  # File Picker — web supported
  file_picker: ^8.x.x

  # Fonts
  google_fonts: ^6.x.x

  # Utils
  flutter_dotenv: ^6.x.x
  intl: ^0.x.x
  uuid: ^4.x.x

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.x.x
  mocktail: ^1.x.x
  flutter_lints: ^4.x.x
```

**Install command:**
```bash
flutter pub add firebase_core firebase_auth cloud_firestore flutter_bloc bloc equatable go_router get_it responsive_framework dio fl_chart data_table_2 file_picker google_fonts flutter_dotenv intl uuid
```

```bash
flutter pub add --dev bloc_test mocktail flutter_lints
```

---

## 6. Firebase Connection

> **Same Firebase project as user app** — no new project needed.

### Steps

**1. Firebase Console → Project Settings → Web Apps → Add App**
```
App nickname: WALLR Admin
Register app → get firebaseConfig object
```

**2. `firebase_options.dart` generate karo:**
```bash
flutterfire configure
# Select same Firebase project as user app
# Select Web platform
```

**3. Firestore Security Rules — Admin access:**
```javascript
// Add this rule to existing rules
// Only admin users can write wallpapers/categories/collections

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Admin check function
    function isAdmin() {
      return request.auth != null &&
        get(/databases/$(database)/documents/admins/$(request.auth.uid)).data.isAdmin == true;
    }

    // Wallpapers — admin write, all authenticated read
    match /wallpapers/{id} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }

    // Categories — admin write, all authenticated read
    match /categories/{id} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }

    // Collections — admin write, user read
    match /collections/{id} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }

    // Users — admin read all, user read own
    match /users/{uid} {
      allow read: if request.auth.uid == uid || isAdmin();
      allow write: if request.auth.uid == uid || isAdmin();
    }

    // Admins collection — only admins can read
    match /admins/{uid} {
      allow read: if isAdmin();
      allow write: if false; // Only via Firebase Console
    }

    // Announcements — admin write, all read
    match /announcements/{id} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }
  }
}
```

**4. Create first admin manually in Firebase Console:**
```
Firestore → admins collection → Add document
Document ID: {admin_uid}
Fields: { isAdmin: true, email: "admin@wallr.app" }
```

---

## 7. Cloudinary Integration

Same `.env` as user app:
```
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_UPLOAD_PRESET=wallr_wallpapers
```

### Upload Flow (Admin → Cloudinary → Firestore)

```
Admin selects image (file_picker)
       ↓
Dio POST to Cloudinary REST API
(unsigned upload using preset)
       ↓
Cloudinary returns { secure_url, public_id }
       ↓
Admin fills metadata (title, category, tags)
       ↓
Firestore wallpapers collection me save karo:
{ imageUrl: secure_url, ...metadata }
       ↓
User app Firestore se fetch karta hai → image show hoti hai
```

### `cloudinary_service.dart`

```dart
// lib/core/utils/cloudinary_service.dart

class CloudinaryService {
  final Dio _dio;

  CloudinaryService(this._dio);

  static String get _cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  static String get _uploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET']!;

  Future<CloudinaryUploadResult> uploadWallpaper({
    required Uint8List fileBytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      ),
      'upload_preset': _uploadPreset,
      'folder': 'wallpapers',
    });

    final response = await _dio.post(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      data: formData,
      onSendProgress: (sent, total) {
        onProgress?.call(sent / total);
      },
    );

    return CloudinaryUploadResult(
      secureUrl: response.data['secure_url'],
      publicId: response.data['public_id'],
      width: response.data['width'],
      height: response.data['height'],
      format: response.data['format'],
      bytes: response.data['bytes'],
    );
  }

  // Thumbnail URL — same as user app
  String getThumbnailUrl(String imageUrl) => imageUrl.replaceFirst(
        '/image/upload/',
        '/image/upload/w_400,h_600,c_fill,f_auto,q_auto/',
      );
}

class CloudinaryUploadResult {
  final String secureUrl;
  final String publicId;
  final int width;
  final int height;
  final String format;
  final int bytes;

  const CloudinaryUploadResult({
    required this.secureUrl,
    required this.publicId,
    required this.width,
    required this.height,
    required this.format,
    required this.bytes,
  });
}
```

---

## 8. Firestore Data Model

> Same collections as user app — admin reads and writes the same data.

```
wallpapers/{id}
  title:            string
  imageUrl:         string        ← Cloudinary secure_url
  thumbnailUrl:     string        ← Cloudinary transformed URL
  category:         string        ← matches categories/{id}.slug
  tags:             string[]
  resolution:       string        ← "4K", "2K", "HD"
  width:            number
  height:           number
  isPremium:        bool
  isActive:         bool          ← admin toggle
  isEditorChoice:   bool          ← admin manually sets
  isTrendingPinned: bool          ← admin override
  downloadCount:    number        ← auto-incremented by user app
  viewCount:        number        ← auto-incremented by user app
  uploadedBy:       string        ← admin uid
  createdAt:        timestamp

categories/{id}
  name:             string
  slug:             string        ← URL-safe e.g. "abstract"
  iconName:         string        ← Material icon name
  coverUrl:         string        ← Cloudinary URL
  wallpaperCount:   number        ← updated on wallpaper add/delete
  isPremium:        bool
  isActive:         bool
  sortOrder:        number        ← drag-to-reorder
  createdAt:        timestamp

collections/{id}
  name:             string
  description:      string
  coverUrl:         string
  isPremium:        bool
  isActive:         bool
  isFeatured:       bool          ← show on home screen
  wallpaperCount:   number
  createdAt:        timestamp

  wallpapers/{wallpaperId}        ← subcollection
    wallpaperId:    string
    addedAt:        timestamp

announcements/{id}
  title:            string
  message:          string
  type:             string        ← "banner" | "modal" | "snackbar"
  targetScreen:     string        ← "all" | "home" | "categories" etc.
  priority:         number
  bgColor:          string
  textTheme:        string        ← "light" | "dark"
  ctaText:          string?
  ctaUrl:           string?
  startsAt:         timestamp
  endsAt:           timestamp?
  isActive:         bool
  createdAt:        timestamp

admins/{uid}
  isAdmin:          bool
  email:            string

notifications_log/{id}           ← push notification history
  title:            string
  body:             string
  targetAudience:   string
  sentAt:           timestamp
  sentBy:           string        ← admin uid
```

---

## 9. Pages & Features

---

### 9.1 Admin Login Page

**Route:** `/login`

**Design:**
- Full dark background `#0F0F0F`
- Center card `#1A1A1A`, 12px radius
- Diamond logo mark (gold) + "WALLR Admin" title
- Email + Password fields
- Gold "Sign In" button
- "Protected admin access only" footer note

**Logic:**
- Firebase Auth — email/password only
- After login → check `admins/{uid}` exists in Firestore
- If not admin → sign out + show error "Unauthorized access"
- If admin → redirect to `/dashboard`

**BLoC:**
```
Events: SignInRequested(email, password), SignOutRequested
States: AuthInitial, AuthLoading, AuthSuccess, AuthFailure(msg), Unauthorized
```

---

### 9.2 Dashboard Overview Page

**Route:** `/dashboard`

**Design:**
- 4 stat cards row: Total Wallpapers, Total Users, Active Subs, Downloads Today
- Each card: icon + number + trend (up/down %)
- Recent Uploads table: last 5 wallpapers with status
- Trending Now section: top 5 by downloadCount

**Stat Cards Data Source:**
```
Total Wallpapers  → wallpapers collection count
Total Users       → users collection count
Active Subs       → users where isPremium == true count
Downloads Today   → aggregate (Cloud Function or daily counter doc)
```

**BLoC:**
```
Events: DashboardLoadRequested
States: DashboardInitial, DashboardLoading, DashboardLoaded(stats), DashboardError
```

---

### 9.3 Manage Wallpapers Page

**Route:** `/wallpapers`

**Design:**
- Page header: "Wallpapers" + total count
- Action bar: Export button + "Upload New" button (gold)
- Filter bar: Category dropdown, Status (Active/Inactive), Tier (Free/Premium), Sort
- Data table with columns:
  - Thumbnail (40×56px, 4px radius)
  - Title
  - Category
  - Resolution badge
  - Premium toggle
  - Editor's Choice toggle (star icon)
  - Active/Inactive toggle
  - Actions: Edit, Delete

**Pagination:** 20 per page, Firestore cursor-based

**BLoC:**
```
Events: WallpapersLoadRequested, WallpaperFilterChanged, 
        WallpaperToggleActive, WallpaperToggleEditorChoice,
        WallpaperDeleteRequested, WallpapersLoadMore
States: WallpapersInitial, WallpapersLoading, WallpapersLoaded, 
        WallpapersError
```

---

### 9.4 Upload Wallpaper Page

**Route:** `/wallpapers/upload`

**Design:**
- Left panel (60%): Media upload area + drag & drop + metadata form
- Right panel (40%): Live preview (lock screen / home screen mockup)

**Form Fields:**
- File upload: `file_picker` — JPG/PNG/WEBP up to 50MB
- Wallpaper Title
- Category (dropdown — from Firestore categories)
- Tags (chip input)
- Premium Only toggle
- Editor's Choice toggle (Featured)
- Auto-detected: Resolution, Width, Height, File size, Format
- Color palette extraction (display only)

**Upload Flow:**
1. File selected → preview shown
2. Admin fills metadata
3. "Publish Wallpaper" clicked
4. Upload to Cloudinary → get `imageUrl`
5. Save to Firestore `wallpapers` collection
6. Show success + redirect to Manage Wallpapers

**BLoC:**
```
Events: FileSelected, MetadataChanged, PublishRequested
States: UploadInitial, FileSelected(previewUrl), 
        UploadInProgress(progress), UploadSuccess, UploadFailure
```

---

### 9.5 Categories Page

**Route:** `/categories`

**Design:**
- "Add Category" button (gold)
- Drag-to-reorder list
- Table columns: Icon, Name, Slug, Wallpaper Count, Active toggle, Edit, Delete

**Add/Edit Category Dialog:**
- Name field
- Slug (auto-generated from name)
- Icon picker (Material icon name input)
- Cover image upload (Cloudinary)
- Premium toggle
- Active toggle

**BLoC:**
```
Events: CategoriesLoadRequested, CategoryAdded, CategoryUpdated, 
        CategoryDeleted, CategoryReordered
States: CategoriesInitial, CategoriesLoading, CategoriesLoaded, CategoriesError
```

---

### 9.6 Collections Page

**Route:** `/collections`

**Design:**
- "Create Collection" button (gold)
- Collections grid (2-column on desktop): cover image + name + item count + premium badge
- Tabs: All Collections / Featured

**Collection Detail (Dialog/Side Panel):**
- Edit name, description, cover image
- Featured toggle
- Premium toggle
- Wallpaper list within collection (add/remove)

**BLoC:**
```
Events: CollectionsLoadRequested, CollectionCreated, CollectionUpdated,
        CollectionDeleted, WallpaperAddedToCollection, WallpaperRemovedFromCollection
States: CollectionsInitial, CollectionsLoading, CollectionsLoaded, CollectionsError
```

---

### 9.7 Featured Content Page

**Route:** `/featured`

**Design:**
- Section 1 — "Editor's Choice Carousel": drag-to-reorder list, max 10
- Section 2 — "Trending Pinned": manual override, max 5, note about auto-trending
- Section 3 — "Featured Collections": drag-to-reorder

**Logic:**
- Editor's Choice → updates `isEditorChoice: true/false` in Firestore
- Trending Pinned → updates `isTrendingPinned: true/false`
- Featured Collections → updates `isFeatured: true/false` in collections

**BLoC:**
```
Events: FeaturedContentLoadRequested, EditorChoiceUpdated, 
        TrendingPinnedUpdated, FeaturedCollectionUpdated
States: FeaturedInitial, FeaturedLoading, FeaturedLoaded, FeaturedError
```

---

### 9.8 Users Page

**Route:** `/users`

**Design:**
- Total count header
- Search bar (by name/email)
- Filter: All / Premium / Free / Blocked
- Table columns: Avatar, Name, Email, Plan (badge), Downloads, Joined Date, Actions
- Actions: View Details, Block/Unblock

**User Detail Side Panel:**
- Profile info (read only)
- Stats: Downloads, Favourites, Collections
- Premium status + expiry
- Block/Unblock button

**BLoC:**
```
Events: UsersLoadRequested, UserSearched, UserFiltered,
        UserBlockToggled, UsersLoadMore
States: UsersInitial, UsersLoading, UsersLoaded, UsersError
```

---

### 9.9 Analytics Page

**Route:** `/analytics`

**Design:**
- Time filter: Today / 30D / Year
- Export Report button
- 4 metric cards: Total Downloads, Active Users (MAU), New Registrations, Top Category
- Line chart: User Acquisition Over Time (`fl_chart`)
- Bar chart: Downloads by Category
- Table: Top 10 Trending Wallpapers

**Data Source:**
- Firestore aggregate queries
- `downloadCount` sum across wallpapers
- User registrations by `createdAt`

**BLoC:**
```
Events: AnalyticsLoadRequested(period), AnalyticsExportRequested
States: AnalyticsInitial, AnalyticsLoading, AnalyticsLoaded, AnalyticsError
```

---

### 9.10 Subscriptions Page

**Route:** `/subscriptions`

**Design:**
- 4 stat cards: Total Subscribers, Monthly Revenue, Active Plans, Churned
- Revenue line chart — last 12 months (`fl_chart`)
- Pie/Donut chart: Plan Distribution
- Subscribers table: Name, Plan, Start Date, Status

**Data Source:**
- Firestore `users` where `isPremium == true`
- Revenue data — read-only from RevenueCat webhook data stored in Firestore

**BLoC:**
```
Events: SubscriptionsLoadRequested
States: SubscriptionsInitial, SubscriptionsLoading, SubscriptionsLoaded, SubscriptionsError
```

---

### 9.11 Push Notifications Page

**Route:** `/notifications`

**Design:**
- Compose form:
  - Target Audience: All / Premium / Free / Specific
  - Title (0/65 chars)
  - Body (0/240 chars)
  - Image URL (optional)
  - On Tap Action dropdown
  - Schedule: Send now or pick datetime
- Preview panel
- Send button (gold)
- Notification History table below

**Integration:** Firebase Cloud Messaging (FCM) via Cloud Functions  
**Note:** Admin sends request → Firestore writes notification doc → Cloud Function triggers FCM send

**BLoC:**
```
Events: NotificationFormChanged, NotificationSendRequested, 
        NotificationHistoryLoadRequested
States: NotificationInitial, NotificationSending, NotificationSent, 
        NotificationError, HistoryLoaded
```

---

### 9.12 Announcements Page

**Route:** `/announcements`

**Design:**
- Create Announcement form:
  - Title
  - Message (0/150 chars)
  - Type: Banner / Modal / Snackbar
  - Target Screen: All / Home / Categories / Wallpaper Detail / Profile
  - Priority (1-10)
  - Background Color picker
  - Text Theme: Light / Dark
  - CTA Text + URL (optional)
  - Display Timing: Start date + End date
- Active Announcements list below

**Logic:**
- Saves to Firestore `announcements` collection
- User app reads active announcements on app start

**BLoC:**
```
Events: AnnouncementFormChanged, AnnouncementSaveRequested,
        AnnouncementsLoadRequested, AnnouncementDeleted
States: AnnouncementInitial, AnnouncementSaving, AnnouncementSaved,
        AnnouncementsLoaded, AnnouncementError
```

---

### 9.13 App Settings Page

**Route:** `/settings`

**Design:**
- General Settings: App Name, Support Email, App Logo upload
- Content Moderation: Auto-approve toggle, NSFW filter toggle, Report threshold
- API Credentials: Firebase Project ID, AdMob ID (masked)
- Legal: Privacy Policy URL, Terms URL

**Logic:**
- Settings saved to Firestore `app_config/global` document
- User app reads this on startup for dynamic config

**BLoC:**
```
Events: SettingsLoadRequested, SettingsSaveRequested
States: SettingsInitial, SettingsLoading, SettingsLoaded, SettingsSaving, SettingsSaved, SettingsError
```

---

## 10. Navigation & Routing

```dart
// lib/config/routes/route_names.dart

abstract final class RouteNames {
  static const login         = '/login';
  static const dashboard     = '/dashboard';
  static const wallpapers    = '/wallpapers';
  static const uploadWallpaper = '/wallpapers/upload';
  static const categories    = '/categories';
  static const collections   = '/collections';
  static const featured      = '/featured';
  static const users         = '/users';
  static const analytics     = '/analytics';
  static const subscriptions = '/subscriptions';
  static const notifications = '/notifications';
  static const announcements = '/announcements';
  static const settings      = '/settings';
}
```

```dart
// GoRouter config
// - Unauthenticated → redirect to /login
// - Authenticated + not admin → redirect to /login with error
// - ShellRoute wraps all authenticated pages with AdminShell widget
//   (AdminShell = Sidebar + TopBar + content area)
```

---

## 11. State Management — BLoC

### Simple Rule
```
1 feature = 1 BLoC
BLoC talks to UseCase only
UseCase talks to Repository
Repository talks to DataSource (Firestore/Cloudinary)
```

### BLoC Template
```dart
// Every BLoC follows this pattern:
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final FeatureUseCase _useCase;

  FeatureBloc(this._useCase) : super(const FeatureInitial()) {
    on<FeatureLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(event, emit) async {
    emit(const FeatureLoading());
    final result = await _useCase(params);
    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (data)    => emit(FeatureLoaded(data)),
    );
  }
}
```

### GetIt DI
```dart
// lib/config/di/injection.dart
// Register: DataSources → Repositories → UseCases → BLoCs
// All BLoCs: registerFactory (new instance each time)
// Repositories, DataSources: registerLazySingleton
```

---

## 12. Responsive Layout Strategy

### Package: `responsive_framework`

```dart
// main.dart
ResponsiveBreakpoints.builder(
  child: child,
  breakpoints: [
    const Breakpoint(start: 0,    end: 767,  name: MOBILE),
    const Breakpoint(start: 768,  end: 1199, name: TABLET),
    const Breakpoint(start: 1200, end: 1920, name: DESKTOP),
  ],
)
```

### AdminShell — Responsive Behavior

```
Desktop (>1200px):
  Row[
    Sidebar (260px, fixed),
    Column[TopBar (64px), Content (flex)]
  ]

Tablet (768-1200px):
  Row[
    Sidebar (64px icon-only, collapsible),
    Column[TopBar (64px), Content (flex)]
  ]

Mobile (<768px):
  Column[
    TopBar (64px) with hamburger menu,
    Content (full width)
  ]
  Sidebar → Drawer (opens on hamburger tap)
```

### Content Area Rules
```
Desktop:  Content max-width 1400px, 32px padding
Tablet:   Full width, 16px padding
Mobile:   Full width, 12px padding

Tables:   Horizontal scroll on tablet/mobile
Cards:    Grid adjusts: 4-col → 2-col → 1-col
```

---

## 13. Development Sequence

### Phase 1 — Foundation
- [ ] Flutter Web project create
- [ ] `pubspec.yaml` all packages
- [ ] `.env` setup
- [ ] Firebase connect (same project, web platform)
- [ ] `firebase_options.dart` generate
- [ ] `AdminColors`, `AdminTextStyles`, `AdminDimensions`, `AdminStrings`
- [ ] `AdminTheme` (ThemeData dark)
- [ ] Core widgets: `AdminShell`, `AdminSidebar`, `AdminTopBar`
- [ ] Core widgets: `AdminCard`, `AdminButton`, `AdminTextField`, `AdminBadge`
- [ ] GoRouter setup + route names
- [ ] GetIt injection setup

### Phase 2 — Auth
- [ ] Login page UI
- [ ] `AuthBloc` — email/password Firebase Auth
- [ ] Admin verification (check `admins` collection)
- [ ] Auth guard in GoRouter

### Phase 3 — Dashboard
- [ ] `DashboardBloc`
- [ ] Firestore queries for stats
- [ ] `StatCard` widget
- [ ] Recent uploads table
- [ ] Dashboard page UI

### Phase 4 — Wallpapers (Core Feature)
- [ ] `CloudinaryService` — Dio upload
- [ ] `WallpaperBloc`
- [ ] Upload page — file picker + form + progress + Cloudinary + Firestore
- [ ] Manage page — table + filters + toggles

### Phase 5 — Categories + Collections
- [ ] Categories CRUD
- [ ] Drag-to-reorder (`ReorderableListView`)
- [ ] Collections CRUD
- [ ] Featured Content page

### Phase 6 — Users
- [ ] Users table + search + filter
- [ ] Block/Unblock functionality
- [ ] User detail side panel

### Phase 7 — Analytics
- [ ] `fl_chart` line + bar charts
- [ ] Metric cards
- [ ] Time period filter

### Phase 8 — Communication
- [ ] Push Notifications (FCM via Cloud Function)
- [ ] Announcements CRUD

### Phase 9 — Subscriptions + Settings
- [ ] Subscriptions dashboard (read-only)
- [ ] App Settings CRUD

### Phase 10 — Polish
- [ ] Responsive testing (Desktop / Tablet / Mobile)
- [ ] Loading states on all pages
- [ ] Error states on all pages
- [ ] `flutter build web --release` test

---

## Performance Rules

1. **Firestore pagination** — always `.limit(20)` with cursor, never fetch all
2. **Images** — always Cloudinary transformed URLs (thumbnails in tables)
3. **Charts** — `fl_chart` is lightweight, no heavy chart libraries
4. **BLoC streams** — always `close()` in dispose
5. **Tables** — `data_table_2` for smooth web scrolling
6. **No setState** in pages — pure BLoC everywhere
7. **const constructors** — wherever possible

---

## .env File

```
# Same as user app
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_UPLOAD_PRESET=wallr_wallpapers
```

---

*PRD Version: 1.0 | WALLR Admin Panel | Flutter Web*
