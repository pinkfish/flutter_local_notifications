package com.dexterous.flutterlocalnotifications.models;

public class ActionButton {
    public String icon;
    public Integer iconResourceId;
    public String text;
    public String payload;
    public IntentAction launchApplication = IntentAction.LaunchApplication;
}