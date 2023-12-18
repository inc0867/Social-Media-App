import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:http/http.dart' as http;

class FirebaseNotificatinService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _service = FireService();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('user');
  Future<void> initNof() async {
    await _firebaseMessaging.requestPermission();

    await _firebaseMessaging.getToken();
  }

  Future<void> setToken(String userid) async {
    DocumentSnapshot documentSnapshot = await _service.getuserdata(userid);
    if (documentSnapshot["Token"] == "") {
      final String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await users.doc(userid).update({
          'Token': token,
        });
      }
    }
  }

  Future<void> sendNotification(
    bool multiaple,
    List<String> token,
    String sendername,
    String msg,
    String gname,
  ) async {
    String apikey =
        "YOUR_API_KEY";
    String apiurl = "https://fcm.googleapis.com/fcm/send";

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$apikey'
    };

    final payload = <String, dynamic>{
      'notification': <String, dynamic>{
        'body': '$sendername: $msg',
        'title': gname,
      },

      'priority': 'high', // Bildirim önceliği (yüksek)
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
      },
      'registration_ids': token,
    };

    try {
      final response = await http.post(Uri.parse(apiurl),
          headers: headers, body: json.encode(payload));
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print("$e");
    }
  }
}
