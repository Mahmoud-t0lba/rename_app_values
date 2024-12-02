library rename_app;

import 'package:rename_app/constants.dart';
import 'package:rename_app/rename_app.dart';
import 'package:rename_app/utils.dart';

String? android;
String? ios;
String? googleApiKey;

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    Utils.logMessage(help);
    return;
  }
  parseArguments(arguments);
  Utils.logMessage('📱 Android App Name: $android');
  Utils.logMessage('📱 IOS App Name: $ios');
  await RenameApp.android(android ?? '');
  await RenameApp.updateGoogleApiKey(googleApiKey ?? '');
  await RenameApp.ios(ios ?? '');

  Utils.logMessage(
    "--------------------------------\n✅  RENAMED APPS SUCCESSFULLY!\n--------------------------------",
  );
}

void parseArguments(List<String> args) {
  for (var arg in args) {
    List<String> splitted = arg.split('=');
    if (splitted.length != 2) {
      Utils.logMessage(help);
      return;
    }
    if (splitted.first == "all") {
      android = splitted.last;
      ios = splitted.last;
      googleApiKey = splitted.last;
      return;
    }
    if (splitted.first == "android") {
      android = splitted.last;
    }
    if (splitted.first == "ios") {
      ios = splitted.last;
    }
    if (splitted.first == "google_api_key") {
      googleApiKey = splitted.last;
    }

    if (splitted.first == "others") {
      android = android ?? splitted.last;
      ios = ios ?? splitted.last;
      googleApiKey = googleApiKey ?? splitted.last;
    }
  }
}
