#Android build (https://docs.flutter.dev/deployment/android)
- flutter build apk --split-per-abi

#Windows build (https://docs.flutter.dev/deployment/windows)
- flutter build windows --build-name [app name] --build-number [app version] 


#Use brew to install cocoapods

1. sudo gem uninstall cocoapods
2. brew install cocoapods
3. brew link --overwrite cocoapods
4. *if need unlink & link again brew unlink cocoapods && brew link cocoapods

#Masos build (https://docs.flutter.dev/deployment/macos)
- flutter build macos --release

