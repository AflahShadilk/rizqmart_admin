// ignore_for_file: empty_catches

import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class WebMessagingService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  
  static const String vapidKey = "BNEm1I08YMzK-ly_jXbmCCEeO_Dg5UofXg53U2OmUCD3V8Yu4fx74SzXgTgCMQQq9GLUlWp0r8pxDQmTK6NjcmA";
  
  static Function(RemoteMessage)? onMessageCallback;
  static Function(RemoteMessage)? onMessageOpenedAppCallback;
  
  static void triggerLocalNotification(String title, String body, {Map<String, dynamic>? data}) {
    if (onMessageCallback != null) {
      try {
        final message = RemoteMessage(
          notification: RemoteNotification(title: title, body: body),
          data: data ?? {},
        );
        onMessageCallback!(message);
      } catch (e) {
      }
    }
  }

  static Future<void> initialize() async {
    try {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        return;
      }

      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (onMessageCallback != null) {
          onMessageCallback!(message);
        }
        _handleForegroundMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (onMessageOpenedAppCallback != null) {
          onMessageOpenedAppCallback!(message);
        }
        _handleMessageClick(message);
      });

      // ignore: unused_local_variable
      String? token;
      if (kIsWeb) {
        token = await _fcm.getToken(vapidKey: vapidKey);
      } else {
        token = await _fcm.getToken();
      }
      
      _fcm.onTokenRefresh.listen((newToken) {
      });

    } catch (e) {
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
  }

  static void _handleMessageClick(RemoteMessage message) {
  }

  static Future<String?> getToken() async {
    try {
      if (kIsWeb) {
        return await _fcm.getToken(vapidKey: vapidKey);
      }
      return await _fcm.getToken();
    } catch (e) {
      return null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      if (kIsWeb) {
        return;
      }
      await _fcm.subscribeToTopic(topic);
    } catch (e) {
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      if (kIsWeb) {
        return;
      }
      await _fcm.unsubscribeFromTopic(topic);
    } catch (e) {
    }
  }
}