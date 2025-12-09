# Period Record - AI Agent Instructions

## Project Overview
"Period Record" is a Flutter application for tracking menstrual cycles. It prioritizes privacy (local storage), ease of use, and security (biometric lock).

## Architecture & Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: `Provider` (v6). `MultiProvider` is configured in `main.dart`.
- **Database**: `sqflite` (SQLite).
- **Authentication**: `local_auth` for biometric/PIN protection.
- **Localization**: `flutter_localizations` (Supports zh_CN, en_US).
 - **Design System**: Material 3 Expressive (M3 Expressive). The app follows Material 3 expressive theming implemented via `AppTheme` and `ThemeProvider`.

## Core Components & Data Flow

### 1. Data Layer (`lib/database_helper.dart`)
- **Singleton**: `DatabaseHelper` manages the SQLite connection.
- **Schema**: `periods` table stores `start`, `end`, `created_at`, `updated_at` as `INTEGER` (milliseconds since epoch).
- **Migrations**: Handle schema changes in `_onUpgrade` and increment `_newVersion`.

### 2. State Management (`lib/period_provider.dart`)
- **Central Hub**: `PeriodProvider` manages the list of periods and interacts with `DatabaseHelper`.
- **Logic**:
  - `sortedPeriods`: Returns unfinished periods first, then finished periods sorted by end date (descending).
  - `lastPeriod`: Logic to determine the most relevant period for status display.
- **Usage**: UI components should consume `PeriodProvider` to display data and trigger actions (add, edit, delete).

### 3. Business Logic (`lib/models/period_status_logic.dart`)
- **Pure Logic**: `PeriodStatusLogic` calculates the current status (e.g., `startedToday`, `inProgress`, `ended`) based on the `lastPeriod`.
- **Separation**: Keep complex status calculation logic here, not in the UI or Provider.

### 4. Models (`lib/period.dart`)
- **Period**: The primary entity.
  - `start`: `DateTime?` (Start of period).
  - `end`: `DateTime?` (End of period; `null` implies ongoing).
  - `createdAt`, `updatedAt`: Timestamps.
- **Serialization**: `toMap()` and `fromMap()` handle conversion between `DateTime` objects and SQLite `INTEGER` (milliseconds).

## Key Conventions & Patterns

- **Date Handling**:
  - Store dates as `INTEGER` (milliseconds since epoch) in SQLite.
  - Use `DateTime` in Dart models.
  - Use `DateUtil` (in `lib/utils/`) for date comparisons and formatting.
- **Theming**:
  - Controlled by `ThemeProvider` and `AppTheme`.
  - Supports Light/Dark modes.
- **Navigation**:
  - `AuthWrapper` is the root widget to handle security checks before showing `HomePage`.
- **UI Components**:
  - Reusable widgets are in `lib/components/`.
  - Pages are in `lib/pages/`.

## Common Workflows

### Modifying the Database
1.  Update `_newVersion` in `DatabaseHelper`.
2.  Implement the migration logic in `_onUpgrade`.
3.  Update the `Period` model and its `toMap`/`fromMap` methods.

### Adding a New Feature
1.  Define the model in `lib/models/`.
2.  Add database methods in `DatabaseHelper`.
3.  Expose data/methods via a Provider (existing or new).
4.  Create UI in `lib/pages/` or `lib/components/`.

### Handling Period Logic
- **Ongoing Period**: Represented by `end: null`.
- **Status Calculation**: Always use `PeriodStatusLogic.calculateStatus(period)`.

## Critical Files
- `lib/main.dart`: App entry, Provider setup, Theme setup.
- `lib/database_helper.dart`: Database schema and raw operations.
- `lib/period_provider.dart`: State management and business logic integration.
- `lib/period.dart`: Core data model.
