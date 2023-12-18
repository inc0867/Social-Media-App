import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';

class AuthService {
  final CollectionReference userauth =
      FirebaseFirestore.instance.collection('user');

  Future<bool> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await userauth.doc(value.user!.uid).set({
          'username': username,
          'email': email,
          'thinks': [],
          'Token': '',
          'admin:': '',
          'pp': '',
          'box':[],
          'desc': '',
          'deleteds':[],
          'groups': [],
          'status': '',
          'followers': [],
          'follows': [],
          'stars': [],
          'hobbys': [],
        });
        await UserPrefs.saveuserid(value.user!.uid);
        await UserPrefs.saveusername(username);
        await UserPrefs.saveuserlogged(true);
      });

      return true;
    } catch (e) {
      print("$e");
      return false;
    }
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        DocumentSnapshot documentSnapshot =
            await userauth.doc(value.user!.uid).get();
        await UserPrefs.saveusername(documentSnapshot['username']);
        await UserPrefs.saveuserid(value.user!.uid);
        await UserPrefs.saveuserlogged(true);
      });
      return true;
    } catch (e) {
      print("$e");
      return false;
    }
  }
}
