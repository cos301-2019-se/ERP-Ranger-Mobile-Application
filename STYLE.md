# ERP Ranger Mobile Application 
# Style Guide

## Code
* Use 2 spaces for indentation instead of tabs.
* Try to not exceed 80 characters per line.
* Remember spaces after each ```,```, ```;``` and ```()```.

#### Control Strucutres
* Always use curly braces for all control structures!
```dart
if () { /// Always have a space between if, () and {}
  /// Do something
} else { ///Always have a space between }, else and {
  /// Do something
}

switch () { /// Always have a space between switch, () and {}
  /// Cases
}
```
#### Naming Conventions
```dart
class Foo {} /// Use UpperCamelCase for classes and names
```
```dart
/// User lowercase_with_underscores for libraries,
/// packages, directories and source files
import 'loading_screen.dart';
import 'second_directory/other_screen.dart';
```
#### More Information of Code Style
[Flutter Formatting Rules](https://github.com/dart-lang/dart_style/wiki/Formatting-Rules)

## Documentation
#### Single Line Comments
```dart
// Always use slashes for single line comments

/* Never use block comments */
```
```dart
// A 2 slash comment won't be included in the docs

/// A 3 slash comment will be included in the docs
```
#### Multiline Comments
```dart
/// Use this format for multiline comments.
/// It is much more compact and reads easier.

/*
  Don't use this format for comments.
  You can use this format to comment out code.
*/

/**
  Never use this format for comments.
  I repeat never use this format.
*/
```
```dart
/// Always start a comment with a short description
/// 
/// Then leave an open line before you start writing a longer
/// more detailed description.
```

#### More Information on Comments
[Flutter Documentation Style](https://www.dartlang.org/guides/language/effective-dart/documentation)

## More Information on Flutter
[Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)