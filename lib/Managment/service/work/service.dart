import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireService {
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('thinks');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference groups =
      FirebaseFirestore.instance.collection('groups');

  Future<DocumentSnapshot> getuserdata(String userid) async {
    DocumentSnapshot documentSnapshot = await users.doc(userid).get();
    return documentSnapshot;
  }

  Future<List<DocumentSnapshot>> getsharebyhobbys(String userid) async {
    DocumentSnapshot documentSnapshot = await users.doc(userid).get();
    List hobbys = documentSnapshot["hobbys"];

    if (hobbys.isNotEmpty) {
      List<DocumentSnapshot> documentSnapshot = [];

      for (String hobby in hobbys) {
        QuerySnapshot querySnapshot =
            await posts.where('type', isEqualTo: hobby).get();

        if (querySnapshot.docs.isNotEmpty) {
          for (var element in querySnapshot.docs) {
            documentSnapshot.add(element);
          }
        }
      }
      return documentSnapshot;
    } else {
      QuerySnapshot querySnapshot = await posts.get();

      List<DocumentSnapshot> ldoc = [];

      for (var element in querySnapshot.docs) {
        ldoc.add(element);
      }

      return ldoc;
    }
  }

  Future<void> create_a_post(
    String username,
    String userid,
    String text,
    String type,
    bool islem, [
    File? file,
  ]) async {
    if (islem == true) {
      await posts.add({
        'time': DateTime.now(),
        'url': '',
        'img': false,
        'userid': userid,
        'username': username,
        'type': type,
        'text': text,
        'stars': [],
        'reports': [],
      }).then((value) async {
        await users.doc(userid).update({
          'thinks': FieldValue.arrayUnion([value.id]),
        });
        Reference reference = FirebaseStorage.instance
            .ref()
            .child('images/$username/${value.id}/${file!.path}');

        TaskSnapshot taskSnapshot = await reference.putFile(file);

        String url = await taskSnapshot.ref.getDownloadURL();
        await posts.doc(value.id).update({
          'url': url,
          'img': true,
        });
      });
    } else {
      await posts.add({
        'time': DateTime.now(),
        'url': '',
        'img': false,
        'userid': userid,
        'username': username,
        'type': type,
        'text': text,
        'stars': [],
        'reports': [],
      }).then((value) async {
        await users.doc(userid).update({
          'thinks': FieldValue.arrayUnion([value.id]),
        });
      });
    }
  }

  Future<void> changeuserphoto(String userid, File file) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("$userid/${file.path}");

    TaskSnapshot taskSnapshot = await reference.putFile(file);
    String url = await taskSnapshot.ref.getDownloadURL();
    await users.doc(userid).update({
      'pp': url,
    });
  }

  Future<DocumentSnapshot> getmsgdata(String msgid, String gid) async {
    DocumentSnapshot documentSnapshot =
        await groups.doc(gid).collection('chats').doc(msgid).get();
    return documentSnapshot;
  }

  Future<void> sendajoinequest(String gid, String uid) async {
    await groups.doc(gid).update({
      'reqs': FieldValue.arrayUnion([uid]),
    });
  }

  Future<DocumentSnapshot> getthinkdata(String thinkid) async {
    DocumentSnapshot documentSnapshot = await posts.doc(thinkid).get();
    return documentSnapshot;
  }

  Future<void> addtodeleteds(String msgid, String userid) async {
    users.doc(userid).update({
      'deleteds': FieldValue.arrayUnion([msgid])
    });
  }

  Future<void> starfunction(String userid, String thinkid) async {
    DocumentSnapshot documentSnapshot = await getthinkdata(thinkid);
    String type = documentSnapshot["type"];
    List Tstars = documentSnapshot["stars"];

    if (Tstars.contains(userid)) {
      await users.doc(userid).update({
        'stars': FieldValue.arrayRemove([thinkid]),
      });
      await posts.doc(thinkid).update({
        'stars': FieldValue.arrayRemove([userid]),
      });
    } else {
      await users.doc(userid).update({
        'stars': FieldValue.arrayUnion([thinkid]),
      });
      await posts.doc(thinkid).update({
        'stars': FieldValue.arrayUnion([userid]),
      });
      await users.doc(userid).update({
        'hobbys': FieldValue.arrayUnion([type]),
      });
    }
  }

  Stream<QuerySnapshot> getcommetsstream(String thinkid) {
    Stream<QuerySnapshot> stream = posts
        .doc(thinkid)
        .collection('comments')
        .orderBy('time', descending: false)
        .snapshots();
    return stream;
  }

  Future<bool> checkcommentthink(
      String docid, String docthinkid, String userid) async {
    DocumentSnapshot documentSnapshot =
        await posts.doc(docid).collection('comments').doc(docthinkid).get();

    List stars = documentSnapshot['stars'];
    if (stars.contains(userid)) {
      return true;
    } else {
      return false;
    }
  }

  Future<DocumentSnapshot> getgroupdata(String gid) async {
    DocumentSnapshot documentSnapshot = await groups.doc(gid).get();
    return documentSnapshot;
  }

  Future<void> invategroup(String gid, String uid) async {
    users.doc(uid).update({
      'box': FieldValue.arrayUnion([gid])
    });
  }

  Future<void> jorDtoG(String gid, String uid, bool a) async {
    if (a == true) {
      await users.doc(uid).update({
        'groups': FieldValue.arrayUnion([gid]),
      });
      await groups.doc(gid).update({
        'members': FieldValue.arrayUnion([uid]),
      });
      await users.doc(uid).update({
        'box': FieldValue.arrayRemove([gid]),
      });
    } else {
      await users.doc(uid).update({
        'box': FieldValue.arrayRemove([gid]),
      });
    }
  }

  Future<Stream<DocumentSnapshot>> getuserstream(String userid) async {
    Stream<DocumentSnapshot> stream = users.doc(userid).snapshots();
    return stream;
  }

  Future<Stream<QuerySnapshot>> search(String type, String name) async {
    if (type == "F") {
      Stream<QuerySnapshot> querySnapshot =
          users.where('username', isEqualTo: name).snapshots();

      return querySnapshot;
    } else if (type == "P") {
      Stream<QuerySnapshot> querySnapshot =
          posts.where('text', isEqualTo: name).snapshots();
      return querySnapshot;
    } else {
      Stream<QuerySnapshot> querySnapshot =
          groups.where('gname', isEqualTo: name).snapshots();
      return querySnapshot;
    }
  }

  Future<void> read(String gid, String msg) async {
    groups.doc(gid).collection('chats').doc(msg).update({
      'read': true,
    });
  }

  Future<Stream<QuerySnapshot>> getchatstreamgroups(String userid) async {
    Stream<QuerySnapshot> stream = groups
        .doc(userid)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
    return stream;
  }

  Future<void> sendamessage(String userid, String username, String msg,
      String gid, bool img, String avatar) async {
    await groups.doc(gid).collection('chats').add({
      'readers': [userid],
      'username': username,
      'avatar': avatar,
      'img': img,
      'gid': gid,
      'msg': msg,
      'userid': userid,
      'read': false,
      'time': DateTime.now(),
      'res': false,
      'resurl': ''
    });
  }

  Future<void> SendaImage(String userid, String username, String msg,
      String gid, bool img, String avatar, File file) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('$gid/$userid/images/${file.path}');

    TaskSnapshot taskSnapshot = await reference.putFile(file);
    String url = await taskSnapshot.ref.getDownloadURL();

    await groups.doc(gid).collection('chats').add({
      'username': username,
      'avatar': avatar,
      'img': img,
      'gid': gid,
      'msg': msg,
      'userid': userid,
      'read': false,
      'time': DateTime.now(),
      'res': true,
      'resurl': url,
    });
  }

  Future<void> joinGroup(String userid, String gid) async {
    await groups.doc(gid).update({
      'members': FieldValue.arrayUnion([userid]),
    });
    await users.doc(userid).update({
      'groups': FieldValue.arrayUnion([gid]),
    });
  }

  Future<List<String>> GetGroupUserToken(
    String gid,
  ) async {
    DocumentSnapshot documentSnapshot = await getgroupdata(gid);
    List members = documentSnapshot['members'];
    List<String> memberstoken = [];
    for (String id in members) {
      DocumentSnapshot documentSnapshot = await getuserdata(id);
      memberstoken.add(documentSnapshot["Token"]);
    }

    return memberstoken;
  }

  Future<int> getnewmessages(String userid, String gid) async {
    List unreadenmessages = [];
    QuerySnapshot querySnapshot =
        await groups.doc(gid).collection('chats').get();
    for (DocumentSnapshot element in querySnapshot.docs) {
      List readers = element["readers"];
      if (readers.contains(userid)) {
      } else {
        unreadenmessages.add(element.id);
      }
    }

    return unreadenmessages.length;
  }

  Future<void> create_a_group(
    String userid,
    bool katsek,
    String gname,
    String username,
  ) async {
    await groups.add({
      'reqs': [],
      'time': DateTime.now(),
      'gname': gname,
      'creatorname': username,
      'creatorid': userid,
      'gdesc': '',
      'url': '',
      'members': [userid],
      'admins': [userid],
      'katsek': katsek,
    }).then((value) async {
      await users.doc(userid).update({
        'groups': FieldValue.arrayUnion([value.id]),
      });
    });
  }

  Future<void> follow(String myid, String otheruserid) async {
    await users.doc(myid).update({
      'follows': FieldValue.arrayUnion([otheruserid]),
    });
    await users.doc(otheruserid).update({
      'followers': FieldValue.arrayUnion([myid]),
    });
  }

  Future<void> removefromgroup(String gid, String uid) async {
    await groups.doc(gid).update({
      'members': FieldValue.arrayRemove([uid]),
    });
    await users.doc(uid).update({
      'groups': FieldValue.arrayRemove([gid]),
    });
  }

  Future<void> makeaadmin(String gid, String uid) async {
    await groups.doc(gid).update({
      'admins': FieldValue.arrayUnion([uid]),
    });
    await users.doc(uid).update({
      'admin': FieldValue.arrayUnion([gid]),
    });
  }

  Future<void> changegphoto(String gid, File file) async {
    Reference reference =
        FirebaseStorage.instance.ref().child('$gid/${file.path}');

    TaskSnapshot taskSnapshot = await reference.putFile(file);

    String url = await taskSnapshot.ref.getDownloadURL();

    await groups.doc(gid).update({
      'url': url,
    });
  }

  Future<void> addreaders(String uid, String gid, String msgid) async {
    groups.doc(gid).collection('chats').doc(msgid).update({
      'readers': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> leavefromGroup(bool admin, String uid, String gid) async {
    if (admin == true) {
      await users.doc(uid).update({
        'groups': FieldValue.arrayRemove([gid]),
      });
      await users.doc(uid).update({
        'admin': FieldValue.arrayRemove([gid]),
      });
      await groups.doc(gid).update({
        'members': FieldValue.arrayRemove([uid]),
      });
      await groups.doc(gid).update({
        'admins': FieldValue.arrayRemove([uid]),
      });
    } else {
      await users.doc(uid).update({
        'groups': FieldValue.arrayRemove([gid]),
      });
      await groups.doc(gid).update({
        'members': FieldValue.arrayRemove([uid]),
      });
    }
  }

  Future<void> unfollow(String myid, String otheruserid) async {
    await users.doc(myid).update({
      'follows': FieldValue.arrayRemove([otheruserid]),
    });
    await users.doc(otheruserid).update({
      'followers': FieldValue.arrayRemove([myid]),
    });
  }

  Stream<DocumentSnapshot> getgstream(String gid) {
    return groups.doc(gid).snapshots();
  }

  Future<void> addcommentstarla(
      String docid, String docthinkid, String userid) async {
    DocumentSnapshot documentSnapshot =
        await posts.doc(docid).collection('comments').doc(docthinkid).get();

    List stars = documentSnapshot['stars'];
    if (stars.contains(userid)) {
      posts.doc(docid).collection('comments').doc(docthinkid).update({
        'stars': FieldValue.arrayRemove([userid]),
      });
    } else {
      posts.doc(docid).collection('comments').doc(docthinkid).update({
        'stars': FieldValue.arrayUnion([userid]),
      });
    }
  }

  Future<void> acceptORdecline(String gid, String uid, bool aORd) async {
    if (aORd == true) {
      await groups.doc(gid).update({
        'reqs': FieldValue.arrayRemove([uid]),
      });
      await groups.doc(gid).update({
        'members': FieldValue.arrayUnion([uid]),
      });
      await users.doc(uid).update({
        'groups': FieldValue.arrayUnion([gid]),
      });
    } else {
      await groups.doc(gid).update({
        'reqs': FieldValue.arrayRemove([uid]),
      });
    }
  }

  Future<void> SendaMessages(
      String documentid, String userid, String username, String text) async {
    await posts.doc(documentid).collection('comments').add({
      'stars': [],
      'username': username,
      'text': text,
      'userid': userid,
      'time': DateTime.now()
    });
  }

  Future<bool> starli(String userid, String thinkid) async {
    DocumentSnapshot documentSnapshot = await getthinkdata(thinkid);

    List stars = documentSnapshot["stars"];

    if (stars.contains(userid)) {
      return true;
    } else {
      return false;
    }
  }
}
