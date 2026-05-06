# ishhub-mobile — Agent Guide

Flutter mobile client for IshHub. **Phase 9 is complete for the MVP scope**:
OTP/profile setup, worker setup, job posting, Feed, offers/applicants, assigned
Jobs, chat, lifecycle, record/confirm payments, ratings, disputes,
notifications, Street Mode settings, and Profile trust/availability are
implemented. Client nearby-worker search, job edit, richer history/earnings,
blocking/reporting, and UX polish are later product passes.

## Stack

- **Flutter 3.x**, Dart 3
- **Riverpod** for state
- **dio** for HTTP, **web_socket_channel** for chat
- **flutter_secure_storage** for JWT
- **geolocator** + **flutter_map** for geo
- **firebase_messaging** for push
- **go_router** for navigation
- **L10n**: uz / ru / en via ARB files

## Layout

```
lib/
  app.dart, main.dart
  config/      constants, enums, theme
  models/      typed models matching API responses
  providers/   Riverpod providers
  services/    api_client, auth_service, location_service, storage_service
  screens/     auth, chat, home, jobs, profile, street_mode
  widgets/     reusable UI
```

## API contract

The backend API is at `ishhub-api`. Treat
[`../ishhub-docs/docs/phase 3/api-reference.md`](../ishhub-docs/docs/phase%203/api-reference.md)
as the contract. Errors come back as
`{"error": {"code": "snake_case", "message": "..."}}` with proper HTTP
status — surface `error.message` to users.

Important current contracts:
- Worker Feed is discovery-only. Assigned work belongs in Jobs via
  `/assignments/me/`.
- Feed items include `distance_known`; when false, show fallback copy, not a
  fabricated distance.
- Street Mode uses `PUT /users/me/street-mode/` with `available_now`, optional
  `available_radius_m`, and paired coordinates when turning on.
- Worker activation can include skills, bio, default rate, location, radius,
  and initial availability, but GPS permission denial must not block setup.

## Realtime

Chat uses WebSocket at `ws://<host>/ws/threads/<thread_id>/?token=<jwt>`.
JWT goes in the **query string**, not headers (see
`apps/chat/middleware.py` in the backend).

## Conventions

- One feature → one folder under `screens/`.
- Models match backend field names exactly (snake_case kept; convert at the boundary if you must).
- Surface auth errors by triggering re-login through `auth_service`, not by silently retrying.
- Use ARB keys, not hardcoded strings, for any user-facing copy.

## Testing

- Widget tests for screens with logic.
- Manual acceptance checks for changed core flows.

Before handoff, run from `ishhub-mobile/`:

```bash
flutter gen-l10n
dart format lib test
flutter test
./scripts/check-no-hardcoded-ui.sh
flutter analyze --no-fatal-infos --no-fatal-warnings
```
