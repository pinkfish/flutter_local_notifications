import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/src/initialization_settings.dart';
import 'package:flutter_local_notifications/src/notification_details.dart';
import 'package:meta/meta.dart';
import 'package:platform/platform.dart';

typedef Future<dynamic> MessageHandler(String message);

/// The available intervals for periodically showing notifications
enum RepeatInterval { EveryMinute, Hourly, Daily, Weekly }

class NotificationButton {
  final int notificationId;
  final String payload;
  final String action;

  NotificationButton({this.notificationId, this.payload, this.action});

  String toString() => "NotificationButton {$notificationId $payload $action}";
}

class FlutterLocalNotificationsPlugin {
  factory FlutterLocalNotificationsPlugin() => _instance;

  @visibleForTesting
  FlutterLocalNotificationsPlugin.private(
      MethodChannel channel, Platform platform)
      : _channel = channel,
        _platform = platform {
    onActionButtonPushedStream = _buttonController.stream.asBroadcastStream();
  }

  static final FlutterLocalNotificationsPlugin _instance =
      new FlutterLocalNotificationsPlugin.private(
          const MethodChannel('dexterous.com/flutter/local_notifications'),
          const LocalPlatform());

  final MethodChannel _channel;
  final Platform _platform;
  final StreamController<NotificationButton> _buttonController =
      new StreamController<NotificationButton>();

  Stream<NotificationButton> onActionButtonPushedStream;

  /// Initializes the plugin. Call this method on application before using the plugin further
  Future<bool> initialize(InitializationSettings initializationSettings) async {
    print("$onActionButtonPushedStream");
    var serializedPlatformSpecifics =
        _retrievePlatformSpecificInitializationSettings(initializationSettings);
    print(serializedPlatformSpecifics);
    _channel.setMethodCallHandler(_handleMethod);
    var result =
        await _channel.invokeMethod('initialize', serializedPlatformSpecifics);
    return result;
  }

  /// Show a notification with an optional payload that will be passed back to the app when a notification is tapped
  Future show(int id, String title, String body,
      NotificationDetails notificationDetails,
      {String payload}) async {
    var serializedPlatformSpecifics =
        _retrievePlatformSpecificNotificationDetails(notificationDetails);
    await _channel.invokeMethod('show', <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'platformSpecifics': serializedPlatformSpecifics,
      'payload': payload ?? ''
    });
  }

  /// Cancel/remove the notificiation with the specified id
  Future cancel(int id) async {
    await _channel.invokeMethod('cancel', id);
  }

  /// Cancels/removes all notifications
  Future cancelAll() async {
    await _channel.invokeMethod('cancelAll');
  }

  /// Schedules a notification to be shown at the specified time with an optional payload that is passed through when a notification is tapped
  Future schedule(int id, String title, String body, DateTime scheduledDate,
      NotificationDetails notificationDetails,
      {String payload}) async {
    var serializedPlatformSpecifics =
        _retrievePlatformSpecificNotificationDetails(notificationDetails);
    await _channel.invokeMethod('schedule', <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'millisecondsSinceEpoch': scheduledDate.millisecondsSinceEpoch,
      'platformSpecifics': serializedPlatformSpecifics,
      'payload': payload ?? ''
    });
  }

  /// Periodically show a notification using the specified interval.
  /// For example, specifying a hourly interval means the first time the notification will be an hour after the method has been called and then every hour after that.
  Future periodicallyShow(int id, String title, String body,
      RepeatInterval repeatInterval, NotificationDetails notificationDetails,
      {String payload}) async {
    var serializedPlatformSpecifics =
        _retrievePlatformSpecificNotificationDetails(notificationDetails);
    await _channel.invokeMethod('periodicallyShow', <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'calledAt': new DateTime.now().millisecondsSinceEpoch,
      'repeatInterval': repeatInterval.index,
      'platformSpecifics': serializedPlatformSpecifics,
      'payload': payload ?? ''
    });
  }

  Map<String, dynamic> _timeToMap(DateTime time) {
    return {
      'hour': time.hour,
      'minute': time.minute,
      'second': time.second,
    };
  }

  /// Shows a notification on a daily interval at the specified time and
  /// day specified in the input DateTime
  Future showDailyAtTime(int id, String title, String body,
      DateTime notificationTime, NotificationDetails notificationDetails,
      {String payload}) async {
    var serializedPlatformSpecifics =
        _retrievePlatformSpecificNotificationDetails(notificationDetails);
    await _channel.invokeMethod('showDailyAtTime', <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'calledAt': new DateTime.now().millisecondsSinceEpoch,
      'repeatInterval': RepeatInterval.Daily.index,
      'repeatTime': _timeToMap(notificationTime),
      'platformSpecifics': serializedPlatformSpecifics,
      'payload': payload ?? ''
    });
  }

  /// Shows a notification on a daily interval at the specified time
  Future showWeeklyAtDayAndTime(int id, String title, String body,
      DateTime notificationTime, NotificationDetails notificationDetails,
      {String payload}) async {
    var serializedPlatformSpecifics =
        _retrievePlatformSpecificNotificationDetails(notificationDetails);
    await _channel.invokeMethod('showWeeklyAtDayAndTime', <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'calledAt': new DateTime.now().millisecondsSinceEpoch,
      'repeatInterval': RepeatInterval.Weekly.index,
      'repeatTime': _timeToMap(notificationTime),
      'day': notificationTime.weekday,
      'platformSpecifics': serializedPlatformSpecifics,
      'payload': payload ?? ''
    });
  }

  Map<String, dynamic> _retrievePlatformSpecificNotificationDetails(
      NotificationDetails notificationDetails) {
    Map<String, dynamic> serializedPlatformSpecifics;
    if (_platform.isAndroid) {
      serializedPlatformSpecifics = notificationDetails?.android?.toMap();
    } else if (_platform.isIOS) {
      serializedPlatformSpecifics = notificationDetails?.iOS?.toMap();
    }
    return serializedPlatformSpecifics;
  }

  Map<String, dynamic> _retrievePlatformSpecificInitializationSettings(
      InitializationSettings initializationSettings) {
    Map<String, dynamic> serializedPlatformSpecifics;
    print('doing this');
    if (_platform.isAndroid) {
      serializedPlatformSpecifics = initializationSettings?.android?.toMap();
    } else if (_platform.isIOS) {
      serializedPlatformSpecifics = initializationSettings?.ios?.toMap();
    }
    print(serializedPlatformSpecifics);
    return serializedPlatformSpecifics;
  }

  Future<void> _handleMethod(MethodCall call) async {
    print("handleMethod");
    print("${call.arguments}");
    if (call.method == "buttonPressed") {
      Map<dynamic, dynamic> args = call.arguments;
      NotificationButton buttonValue = new NotificationButton(
          notificationId: args["notification_id"],
          payload: args["payload"],
          action: args["action"]);
      _buttonController.add(buttonValue);
      return;
    }
    String payload = call.arguments[0];
    int id = call.arguments[1];
    String action = call.arguments[2];
    if (action == 'com.apple.UNNotificationDefaultActionIdentifier') {
      action = '';
    }
    NotificationButton buttonValue = new NotificationButton(
        notificationId: id, payload: payload, action: action);
    _buttonController.add(buttonValue);
  }
}
