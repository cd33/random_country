# random_country

A Flutter project that displays a random country with informations (food, cinema and infos).
Uses the [OpenRouter API](https://openrouter.ai/).

## Getting Started

First, you need to get an API key from [OpenRouter](https://openrouter.ai/).

Then, you need to create a `.env` file in the root of the project with the following content:

```bash
OPENROUTER_API_KEY=YOUR_API_KEY
```

You can change the LLM in lib/openai_service.dart.

```dart
'model': 'deepseek/deepseek-r1:free'
```

## Utils commands

```bash
flutter create random_country
flutter emulators --launch Medium_Phone
flutter run
flutter build apk --release
```
