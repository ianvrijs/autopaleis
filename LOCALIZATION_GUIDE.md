# Localization Guide

This project uses standard Flutter localization with complete support for English (`en`) and Dutch (`nl`). 
This guide explains how to add new specialized strings for new features or screens.

## File Locations

The localization files are located in `lib/l10n/`:
- **English (Source):** `lib/l10n/app_en.arb`
- **Dutch:** `lib/l10n/app_nl.arb`

## How to Add a New String

1. **Open `app_en.arb`** and add your new key-value pair.
   ```json
   {
     ...
     "helloWorld": "Hello World",
     "welcomeUser": "Welcome {userName}",
     "@welcomeUser": {
       "placeholders": {
         "userName": {
           "type": "String"
         }
       }
     }
   }
   ```
   > **Note:** Keys must be camelCase (e.g., `myNewString`).

2. **Open `app_nl.arb`** and add the *same key* with the Dutch translation.
   ```json
   {
     ...
     "helloWorld": "Hallo Wereld",
     "welcomeUser": "Welkom {userName}"
   }
   ```

3. **Generate Dart Code**
   Run the following command in your terminal to update the generated Dart classes:
   ```bash
   flutter gen-l10n
   ```
   *Note: VS Code often runs this automatically when you save an .arb file, but running it manually ensures everything is synced.*

## How to Use in Code

1. **Import the localization class**:
   ```dart
   import 'package:autopaleis/l10n/app_localizations.dart';
   // OR relative path like 
   // import '../../l10n/app_localizations.dart';
   ```

2. **Access the string**:
   Inside any widget's `build` method:
   ```dart
   @override
   Widget build(BuildContext context) {
     final l10n = AppLocalizations.of(context)!;
     
     return Text(l10n.helloWorld);
   }
   ```

   **For strings with parameters:**
   ```dart
   Text(l10n.welcomeUser('John'));
   ```

## Important Rules

1. **Keys must match exactly:** If you add `"myKey"` to `app_en.arb`, you MUST add `"myKey"` to `app_nl.arb`. Missing keys will cause compile-time errors or runtime crashes.
2. **Parameters must match:** If defined with placeholders in English, the Dutch version must use the same placeholder names (e.g., `{userName}`).
3. **No Trailing Commas:** Standard JSON rules apply. The last item in the list must *not* have a comma after it.

## Troubleshooting

- **"Undefined name 'l10n'":** Make sure you initialized the variable `final l10n = AppLocalizations.of(context)!;` at the start of your `build` method.
- **"The getter 'myKey' isn't defined":** You probably forgot to run `flutter gen-l10n` or save the .arb files.
- **JSON Syntax Error:** Check for missing commas between lines or extra commas at the end of the file.
