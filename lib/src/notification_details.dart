import 'package:flutter_local_notifications/src/platform/android/notification_details_android.dart';
import 'package:flutter_local_notifications/src/platform/ios/notification_details_ios.dart';

/// Contains notification settings for each platform
class NotificationDetails {
  /// Notification details for Android
  final NotificationDetailsAndroid android;

  /// Notification details for iOS
  final NotificationDetailsIOS iOS;

  const NotificationDetails(this.android, this.iOS);
}
