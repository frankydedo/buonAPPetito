import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {

  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    //richiediamo all utente il permesso per le notifiche
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();

    print('Token: ' + fcmToken.toString());
  }

  void handleMessage(RemoteMessage? message){
    if(message == null) return;

    print(message.toString());

  }
}