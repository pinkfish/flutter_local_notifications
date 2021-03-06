/// Configures the notification details on iOS.
/// Currently not used.
class NotificationDetailsIOS {
  // Display an alert when the notification is triggered while app is in the foreground. iOS 10+ only
  final bool presentAlert;

  /// Play a sound when the notification is triggered while app is in the foreground. iOS 10+ only
  final bool presentSound;

  /// Apply the badge value when the notification is triggered while app is in the foreground. iOS 10+ only
  final bool presentBadge;

  /// Specifies the name of the file to play for the notification. Requires setting [presentSound] to true. If [presentSound] is set to true but [sound] isn't specified then it will use the default notification sound.
  final String sound;

  /// The category to use to display the notification
  final String categoryId;

  NotificationDetailsIOS(
      {this.presentAlert, this.presentBadge, this.presentSound, this.sound, this.categoryId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'presentAlert': presentAlert,
      'presentSound': presentSound,
      'presentBadge': presentBadge,
      'sound': sound,
      'categoryId': categoryId
    };
  }
}
