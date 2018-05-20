import 'package:flutter/foundation.dart';

/// This represents an action on a button in the android context.
class AndroidNotificationAction {
  /// The icon to display with the button (can be null).
  String icon;

  /// The text in the button itself.
  String text;

  /// The payload to send back to the system when the button is pushed.
  String payload;

  /// If this is an action notification and will do something exciting.
  /// This means the payload should be a url.
  bool launchApplication;

  AndroidNotificationAction(
      {this.icon,
      @required this.text,
      this.payload,
      this.launchApplication = true});
}
