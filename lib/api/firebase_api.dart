import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // Richiediamo all'utente il permesso per le notifiche
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('\n\n\n\n\n\n\n\n\n\n\n');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    final fcmToken = await _firebaseMessaging.getToken();

    print('FCM Token: $fcmToken');
    if (fcmToken != null) {
      print('FCM Token: $fcmToken');
    } else {
      print('FCM Token not available yet');
    }

    final apnsToken = await _firebaseMessaging.getAPNSToken();
    if (apnsToken != null) {
      print('APNS Token: $apnsToken');
    } else {
      print('APNS Token not available yet');
    }


    print('\n\n\n\n\n\n\n\n\n\n\n');


    await FirebaseMessaging.instance.setAutoInitEnabled(true);

  }
}