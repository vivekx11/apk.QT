# Quiz App - Setup Guide

## Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

## Features Overview

### 🎯 Splash Screen
- Beautiful animated splash screen with app logo
- Smooth transition to login page

### 🔐 Login/Signup Page
- Clean form validation
- Email and password fields
- Toggle between login and signup modes
- Modern glassmorphic design

### 📚 Category Selection
- 10 quiz categories to choose from
- Beautiful grid layout with icons
- Smooth navigation

### 🎮 Difficulty Selection
- Three difficulty levels: Easy, Medium, Hard
- Glassmorphic cards with smooth animations
- Visual feedback on selection

### ❓ Quiz Page
- 10 questions per quiz
- Multiple choice answers
- Progress indicator
- Real-time score tracking
- Instant feedback on answers

### 📊 Score Page
- Final score display
- Percentage calculation
- Motivational messages
- Return to home button

### ⚙️ Settings Page
- View quiz history
- See all past scores
- Logout functionality
- Clean data visualization

## App Flow

```
Splash Screen
    ↓
Login/Signup
    ↓
Category Selection
    ↓
Difficulty Selection
    ↓
Quiz Questions
    ↓
Score Display
```

## Color Scheme

- Primary: `#6366F1` (Indigo)
- Secondary: `#F43F5E` (Rose)
- Background: `#F8F9FE` (Light Gray)
- Text: `#1F2937` (Dark Gray)

## Dependencies Used

- **http**: API calls to Open Trivia Database
- **html_unescape**: Decode HTML entities in questions
- **hive & hive_flutter**: Local storage for quiz scores

## API Information

The app uses the Open Trivia Database API:
- Base URL: `https://opentdb.com/api.php`
- Parameters:
  - `amount`: Number of questions (10)
  - `category`: Category ID
  - `difficulty`: easy/medium/hard
  - `type`: multiple (multiple choice)

## Troubleshooting

### Issue: Dependencies not installing
**Solution**: Run `flutter clean` then `flutter pub get`

### Issue: App not running
**Solution**: Ensure you have Flutter SDK installed and configured properly

### Issue: API not loading questions
**Solution**: Check your internet connection

## Testing

Run tests with:
```bash
flutter test
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Support

For issues or questions, please check the Flutter documentation at https://flutter.dev
