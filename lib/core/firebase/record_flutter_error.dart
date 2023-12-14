
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

Future<void> recordFlutterError() async {
  if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
    /// Pass all uncaught errors from the flutter framework to Crashlytics.
    /// 
    /// By overriding FlutterError.onError with FirebaseCrashlytics.instance.recordFlutterError,
    /// it will automatically catch all errors that are thrown within the Flutter framework.
    
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
}