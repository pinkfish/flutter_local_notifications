import 'package:flutter/foundation.dart';

enum ActionOnClick {
  OpenURL,
  LaunchApplication,
  BackgroundService
}

/// This represents an action on a button in the android context.
class AndroidNotificationAction {
  /// The icon to display with the button (can be null).
  String icon;

  /// The text in the button itself.
  String text;

  /// The payload to send back to the system when the button is pushed.
  String payload;

  /// If this is an action notification and will do something exciting.
  /// If the setup is openURL then the payload is a url.
  ActionOnClick actionOnClick;

  AndroidNotificationAction(
      {this.icon,
      @required this.text,
      this.payload,
      this.actionOnClick = ActionOnClick.LaunchApplication});
}
