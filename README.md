# NovaChrono - Ali Cinar and Michael Spiegel
On Linux we used the following versions of flutter and dart:
```txt
Flutter 3.16.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 9e1c857886 (7 weeks ago) • 2023-11-30 11:51:18 -0600
Engine • revision cf7a9d0800
Tools • Dart 3.2.2 • DevTools 2.28.3
```

On macOS we used the following versions of flutter and dart:
```txt
Flutter 3.16.8 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 67457e669f (vor 5 Tagen) • 2024-01-16 16:22:29 -0800
Engine • revision 6e2ea58a5c
Tools • Dart 3.2.5 • DevTools 2.28.5
```

To check the build on windows we used the following versions of flutter and dart:
```txt
Flutter 3.16.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 9e1c857886 (7 weeks ago) • 2023-11-30 11:51:18 -0600
Engine • revision cf7a9d0800
Tools • Dart 3.2.2 • DevTools 2.28.3
```

## Requirements
### Windows

On Windows you need:
* Git
* Visual Studio 2022 with the Desktop Development with C++ Workload

If you have those two things installed all you need is to install the Flutter SDK from
[https://docs.flutter.dev/get-started/install/windows/desktop?tab=download](https://docs.flutter.dev/get-started/install/windows/desktop?tab=download).
Follow the installation steps provided on this page.

### Linux
The prerequisites can be installed with the following command:

```bash
sudo apt-get install clang cmake git ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev
```

On Linux you can install the Flutter SDK with snap:
```bash
sudo snap install flutter --classic
```

### macOS
On macOS you need the following prerequisites:
* Xcode 15
* CocoaPods 1.12
* Git

Then download and install the Flutter SDK [https://docs.flutter.dev/get-started/install/macos/desktop?tab=download](https://docs.flutter.dev/get-started/install/macos/desktop?tab=download).
You also need to configure Xcode although it says "Configure iOS development".
In the text below it says "To develop Flutter apps for macOS, install Xcode to compile to native bytecode."

## Building the application
To build the application run the following command:
```
flutter build [platform] --release
```

Substitute platform with one of the following:
* windows

```bash
flutter build windows --release
```

You can find the build in `build\windows\x64\runner\Release\`.

* linux

```bash
flutter build linux --release
```

You can find the build in `build/linux/x64/release/bundle/`.

* macos

```bash
flutter build macos --release
```

You can find the build in `build/macos/Build/Products/Release/`.

## Running the application in debug mode
To run the application you can start it in you IDE or you use the following command:
```bash
flutter run
```

Depending on how many targets flutter finds you have to specify the target with `-d target`.
n this case the target can be linux, windows or macos.

## Running tests
### Unit Tests
To run unit tests use the following command:
```bash
flutter test test/unit_tests
```

### Integration Tests
On Linux it was necessary to install `libsqlite3-dev` because the library `libsqlite3.so`
was not available during the integration tests.

To run integration tests use the following command:
```bash
flutter test test/integration_tests
```

### End to end tests
Currently it is not possible to run all the integration tests with 
`flutter test integration_test` with a desktop device as target device. 
You have to specify each test individually like 
`flutter test integration_test/edit_task_flow_test.dart`.

There is still an open issue for this problem [https://github.com/flutter/flutter/issues/101031](https://github.com/flutter/flutter/issues/101031).

To run all end to end test you have to run the file `run_all_test.dart` which is a workaround
for the mentioned issue. 
This can be done with the following command:

```bash
flutter test integration_test/run_all_test.dart
```

## Location of the SQLite db
### File location during development
#### Windows/Linux
On Windows and Linux the .db file is stored in the directory `.dart_tool/sqflite_common_ffi/databases` inside the project.

#### macOS
On macOS, the .db file is stored at the following location:
`/Users/<username>/Library/Containers/at.fhv.novaChrono/Data/.dart_tool/sqflite_common_ffi/databases/novachrono.db`
It is recommended to show hidden folders/files.

### File location when the release build is run
#### Windows
On Windows the .db file is stored in the directory `build/windows/x64/runner/Release/.dart_tool/sqflite_common_ffi/databases/novachrono.db`.

#### Linux
On Linux the .db fle is stored in the directory `build/linux/x64/release/bundle/.dart_tool/sqflite_common_ffi/databases/novachrono.db`.

#### macOS
On macOS, the .db file is stored at the following location:
`/Users/<username>/Library/Containers/at.fhv.novaChrono/Data/.dart_tool/sqflite_common_ffi/databases/novachrono.db`
It is recommended to show hidden folders/files.

## Known Issues
* During the macOS build it shows many warnings regarding sqlite. 
There was an issue opened but it was closed with the information that 
'Unfortunately one has to live with those warnings...'. 
See [https://github.com/davidmartos96/sqflite_sqlcipher/issues/36](https://github.com/davidmartos96/sqflite_sqlcipher/issues/36).
* During the tests a warning is shown that the sqflite factory is changed.
As this is needed to use SQLite on desktop this warnings can be ignored.
* The in C implemented encryptionLib is only supported on Linux and macOS. 
On Windows it will use a dart implementation.
* During the integration tests the in C implemented encryptionLib is not present. 
In this case it will use a dart implementation. For the end to end test it works with the
C lib.