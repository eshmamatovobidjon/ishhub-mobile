# ishhub-mobile — Agent Guide

Flutter mobile client for IshHub. Currently a scaffold — the production
build is **Phase 9** in the
[implementation roadmap](../ishhub-docs/docs/implementation-roadmap.md).

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
- Maestro flows under `.maestro/` (one per Phase 9 acceptance scenario; see roadmap).
