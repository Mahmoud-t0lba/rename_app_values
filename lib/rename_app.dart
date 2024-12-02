library rename_app;

import 'package:rename_app/constants.dart';
import 'package:rename_app/utils.dart';

class RenameApp {
  static Future<void> android(String android) async {
    if (await Utils.fileNotExists(androidManifestFile)) {
      Utils.printNoConfigFound('android');
      return;
    }

    if (android.isEmpty) {
      return;
    }

    await Utils.renameAndroid(androidManifestFile, android);
  }

  static Future<void> ios(String ios) async {
    List<String> iosPlistFiles = [iosPlistPath, iosDebugPlistPath, iosReleasePlistPath];
    if (await Utils.filesNotExists(iosPlistFiles) || ios.isEmpty) {
      Utils.printNoConfigFound('ios');
      return;
    }

    if (ios.isEmpty) {
      return;
    }

    await Utils.renameAllIOS(iosPlistFiles, ios);
  }

  static Future<void> updateGoogleApiKey(String apiKey) async {
    if (await Utils.fileNotExists(androidManifestFile)) {
      Utils.printNoConfigFound('updateGoogleApiKey');
      return;
    }

    // If API Key is provided, update it in AndroidManifest.xml
    if (apiKey.isNotEmpty) {
      await Utils.updateGoogleApiKey(androidManifestFile, apiKey);
    }
  }
}
