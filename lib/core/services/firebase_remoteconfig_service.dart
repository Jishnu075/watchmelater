import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteconfigService {
  final FirebaseRemoteConfig _firebaseRemoteConfig;

  static FirebaseRemoteconfigService? _instance;
  static FirebaseRemoteconfigService get instance {
    _instance ??= FirebaseRemoteconfigService._internal();
    return _instance!;
  }

  FirebaseRemoteconfigService._internal()
      : _firebaseRemoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        // the minimum fetch duration is set for 1hour, so any changes made in the remote config only appears after 1hour (cache mechanism)
        minimumFetchInterval: const Duration(hours: 1)));
    await _firebaseRemoteConfig.setDefaults({
      'welcome_message':
          'Just login and save those movies you want to watch later.'
    });
    await fetchAndActivate();
  }

  Future<void> fetchAndActivate() async {
    try {
      await _firebaseRemoteConfig.fetchAndActivate();
    } catch (e) {
      //TODO add logging
      print('Error fetching remote config: $e');
    }
  }

  // String get welcomeMessage =>
  //     _firebaseRemoteConfig.getString('welcome_message');
}
