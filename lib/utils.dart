import 'dart:io';

import 'package:xml/xml.dart';

class Utils {
  static Future<bool> fileNotExists(String path) async {
    bool exists = await File(path).exists();
    return !exists;
  }

  static Future<bool> filesNotExists(List<String> paths) async {
    for (String path in paths) {
      if (await File(path).exists()) {
        return false;
      }
    }
    return true;
  }

  static Future<void> saveFile(String filePath, String data) async {
    await File(filePath).writeAsString(data, flush: true);
  }

  static Future<void> renameAndroid(String filePath, String appName) async {
    String data = await File(filePath).readAsString();
    XmlDocument document = XmlDocument.parse(data);
    var application = document.children.first.findAllElements('application').first;
    application.setAttribute('android:label', appName);

    await saveFile(filePath, document.toXmlString());
    printFinishMessage('android');
  }

  static Future<void> renameIOS(String filePath, String appName) async {
    String data = await File(filePath).readAsString();
    XmlDocument document = XmlDocument.parse(data);
    var keys = document.findElements('plist').first.findElements('dict').first.children;

    /// Removing xml elements which are generated due to line breaks (this xml parser is creating xml element as 'XmlText' for line breaks)
    keys.removeWhere((element) => element is XmlText);
    for (int i = 0; i < keys.length; i++) {
      /// Will be true if google is already configured
      if (keys[i].innerText == 'CFBundleDisplayName') {
        var value = XmlElement(XmlName('string'));
        value.innerText = appName;
        keys.removeAt(i + 1);
        keys.insert(i + 1, value);
      }
    }
    await saveFile(filePath, document.toXmlString(pretty: true));
    printFinishMessage('ios');
  }

  static Future<void> renameAllIOS(List<String> filePaths, String appName) async {
    for (String path in filePaths) {
      if (!await fileNotExists(path)) {
        await renameIOS(path, appName);
      }
    }
  }

  static Future<void> updateGoogleApiKey(String filePath, String apiKey) async {
    String data = await File(filePath).readAsString();
    XmlDocument document = XmlDocument.parse(data);
    var metaData = document.findAllElements('meta-data').firstWhere(
        (element) => element.getAttribute('android:name') == 'com.google.android.geo.API_KEY',
        orElse: () => XmlElement(XmlName('meta-data')));

    metaData.setAttribute('android:name', 'com.google.android.geo.API_KEY');
    metaData.setAttribute('android:value', apiKey);

    if (!document.findAllElements('meta-data').contains(metaData)) {
      var application = document.children.first.findAllElements('application').first;
      application.children.add(metaData);
    }

    await saveFile(filePath, document.toXmlString());
    logMessage('✅ Google API Key Updated Successfully in AndroidManifest.xml');
  }

  static void printFinishMessage(String platform) {
    logMessage('✅ FINISHED RENAMING [${platform.toUpperCase()}] PROJECT\n');
  }

  static void printNoConfigFound(String platform) {
    logMessage('🧐 NO CONFIGURATION FOUND FOR <${platform.toUpperCase()}> PROJECT');
  }

  static void logMessage(String message) {
    /// ignore: avoid_print
    print(message);
  }
}
