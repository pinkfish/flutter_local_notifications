package com.dexterous.flutterlocalnotifications;

import com.google.gson.Gson;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import com.dexterous.flutterlocalnotifications.models.NotificationChannelSettings;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class NotificationChannelSettingsFactory {
     public static NotificationChannelSettings createFromArguments(List<Object> arguments) {

        @SuppressWarnings("unchecked") HashMap<String, Object> map =
                (HashMap<String, Object>)arguments.get(0);

        NotificationChannelSettings settings = new NotificationChannelSettings();

        settings.Id = (String) map.get("id");
        settings.Name= (String) map.get("name");
        settings.Description = (String) map.get("description");
        settings.Importance = (int) map.get("importance");
        @SuppressWarnings("unchecked") ArrayList<Integer> vibratePattern =
                (ArrayList<Integer>)map.get("vibratePattern");

        return settings;
    }
}