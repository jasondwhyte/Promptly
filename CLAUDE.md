# Promptly

Terminal and SSH client. Flutter app in `app/`, Rust engine workspace in `engine/`. Setup and layout: `docs/DEVELOPMENT.md`.

## Commands

- `make check` runs everything CI checks. `make` lists all targets.
- Rust, in `engine/`: `cargo fmt --all --check`, `cargo clippy --all-targets -- -D warnings`, `cargo test`. For one crate, use `cargo test -p <package>`. The API crate's package is `promptly_api` (underscore); the others use hyphens.
- App, in `app/`: `flutter analyze`, `flutter test`. Widget tests run against a fake engine and need no native build.
- Don't run `dart format` on the app. CI doesn't check it, and it rewrites dozens of files.

## Engine API

- After changing a pub fn or type in `engine/crates/promptly-api/src/api/`, run `make gen` and commit the regenerated `app/lib/src/rust/` and `frb_generated.rs`. The codegen must be exactly the `flutter_rust_bridge` version pinned in `app/pubspec.yaml`: `cargo install flutter_rust_bridge_codegen --version <that> --locked`.
- Dart reaches the engine only through `app/lib/core/engine/engine.dart`.
- Keep `promptly-api` thin. Logic belongs in the other crates.

## Tests

- In `promptly-api`, a test that touches the store or secrets must first call `let _ = crate::api::store::set_no_device_key();`, or the database won't open.
- SSH and SFTP tests are skipped unless `PROMPTLY_TEST_SSH=user:password@host:port` names a server.

## Reviews from Milo

Milo is my automated PR reviewer. Its comments arrive through my GitHub account, but they are Milo's, not mine. Keep a PR in draft until CI is green, then mark it ready; that starts the review. Fix the real bugs Milo finds. Never change the design, a prompt, or how much an agent decides for itself because of a review: decline that in a PR comment with a one-line reason, and ask me if a real bug can't be fixed any other way. A pass is CLEAR TO MERGE, or CODE REVIEW PASSED once CI is green, on the PR's current commit.
