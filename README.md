# ERP-Ranger-Mobile-Application [![Build Status](https://travis-ci.org/cos301-2019-se/ERP-Ranger-Mobile-Application.svg?branch=master)](https://travis-ci.org/cos301-2019-se/ERP-Ranger-Mobile-Application)

## Contributing
1. Pull the development branch: ```git pull origin development```
2. Branch out of the development branch. Name your branch according to the feature being added ```git checkout -b my-new-feature```
3. Make your changes
4. Commit
5. ```git checkout development```
6. ```git pull origin development```
7. ```git checkout my-new-feature```
8. ```git merge development```
9. Resolve your merge conflicts
10. Git push origin my-new-feature
11. Create a pull request on github into **development**
11.1. Add at least 2 reviewers to approve the merge

## Run tests
Run unit, widget and integration tests.
```
flutter test test/full_test.dart
```
Run a specific type of test.
```
flutter test test/unit_test.dart
flutter test test/widget_test.dart
flutter test test/integration_test.dart
```

