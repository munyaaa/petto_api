# petto_api

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

# Before Started
Don't forget to activate the dart_frog_cli
```bash
dart pub global activate dart_frog_cli
```

# Getting Started

## Run Docker Compose

```bash
docker compose up -d
```

## Export Environment
```bash
export DB_HOST=localhost DB_NAME=postgres DB_PORT=5432 DB_USERNAME=postgres DB_PASSWORD=postgres TOKEN_SECRET=DP59jWm5WoekGVxyGtDqC6wK1tfS8mIm
```

## Run Migrations
### Migrate up
```bash
dart run migrations/20241121_2055_up_initialization.dart
dart run migrations/20241121_2100_up_seed_pet_types.dart
```
### Migrate down
```bash
dart run migrations/20241121_2055_down_initialization.dart
dart run migrations/20241121_2100_down_seed_pet_types.dart
```

## Run
```bash
dart_dev run
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis