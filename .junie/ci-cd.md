# CI/CD

Goals
- Enforce code quality, run tests on every push/PR, and provide fast feedback.

Stages
1) Setup
- Checkout repo
- Install Flutter (stable) and cache the SDK
- flutter pub get (use pub cache)

2) Lint & Analyze
- flutter format --set-exit-if-changed .
- dart analyze

3) Tests
- flutter test --no-pub

4) Optional Build (on main)
- flutter build apk --debug or --release
- flutter build ios --no-codesign (CI only)

Artifacts
- Test reports (if configured with junit/coverage)
- Build outputs for release pipelines

Caching
- Cache ~/.pub-cache and Flutter SDK to speed up jobs

Env/Secrets
- Not required for Open Library API

Example: GitHub Actions (snippet)
- name: Flutter CI
  on: [push, pull_request]
  jobs:
    build:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: subosito/flutter-action@v2
          with:
            channel: 'stable'
        - run: flutter pub get
        - run: flutter format --set-exit-if-changed .
        - run: dart analyze
        - run: flutter test --no-pub

PR Checks
- Block merge on lint or test failures
- Require at least one reviewer approval

Release
- Tag-based releases trigger build and artifact upload (optional)
