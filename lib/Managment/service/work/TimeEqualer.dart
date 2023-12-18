import 'package:cloud_firestore/cloud_firestore.dart';

class TimerFunc {
  String TimeToString(Timestamp timestamp) {
    DateTime eski = timestamp.toDate();
    DateTime suan = DateTime.now();

    Duration fark = suan.difference(eski);

    String zaman = "";

    if (fark.inSeconds >= 60) {
      if (fark.inMinutes >= 60) {
        if (fark.inHours >= 24) {
          if (fark.inDays >= 7) {
           if (fark.inDays >= 7 && fark.inDays <= 29) {
            
            int weeks = fark.inDays ~/ 7;
            zaman = "$weeks weeks ago";
           }else {
            if (fark.inDays >= 30 && fark.inDays <= 364) {
              int month = fark.inDays ~/ 30;
              zaman = "$month month ago";
            }else {
              int year = fark.inDays ~/ 365;
              zaman = "$year years ago";
            }
           }
          }else {
            zaman = "${fark.inDays} days ago";
          }
        }else {
          zaman = "${fark.inHours} hours ago";
        }
      }else {
        zaman = "${fark.inMinutes} minutes ago";
      }
    } else {
      zaman = "${fark.inSeconds} seconds ago";
    }
    return zaman;
  }
}
