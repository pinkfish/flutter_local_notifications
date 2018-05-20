// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.dexterous.flutterlocalnotifications;

import android.content.Intent;
import android.app.IntentService;
import android.util.Log;

import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;

import io.flutter.plugin.common.MethodChannel;

public class FlutterActionService extends IntentService {
    private static MethodChannel sSharedChannel;

    public FlutterActionService() {
        super("FlutterActionService");
        System.out.println("Creating service");
    }

    public static MethodChannel getSharedChannel() {
        return sSharedChannel;
    }

    public static void setSharedChannel(MethodChannel channel) {
        System.out.println("setSharedChannel");

        if (sSharedChannel != null && sSharedChannel != channel) {
            //Log.d(FlutterLocalNotificationsPlugin.LOGGING_TAG, "sSharedChannel tried to overwrite an existing Registrar");
            return;
        }
        //Log.d(FlutterLocalNotificationsPlugin.LOGGING_TAG, "sSharedChannel set");
        sSharedChannel = channel;
    }

    @Override
    public void onHandleIntent(Intent intent) {
        System.out.println("onHandleIntent");
        //FlutterLocalNotificationsPlugin.customLog("LocalNotificationsService handling intent in the background");
        FlutterLocalNotificationsPlugin.handleIntent(intent);
    }
}