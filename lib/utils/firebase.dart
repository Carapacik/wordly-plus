import 'package:firebase_core/firebase_core.dart';
import 'package:wordle/utils/platform.dart';

Future<FirebaseApp> platformSpecificFirebase() async {
  // does not work on windows and mac
  return Firebase.initializeApp(
    options: PlatformType.currentPlatformType == PlatformTypeEnum.web
        ? const FirebaseOptions(
            apiKey: "AIzaSyAhcjNRAWE9i4xvHnGX_dP8Qsexj2Gbv8A",
            appId: "1:1035703108304:web:97b9de3b33f647abcd14d5",
            messagingSenderId: "1035703108304",
            projectId: "wordle-60cbd",
            authDomain: "wordle-60cbd.firebaseapp.com",
            storageBucket: "wordle-60cbd.appspot.com",
            measurementId: "G-N9J8MD287F",
          )
        : null,
  );
}
