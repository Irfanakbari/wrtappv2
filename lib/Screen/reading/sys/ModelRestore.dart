import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wrtappv2/Auth/sys/auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RestoreBookmark {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
//  final FirebaseAuth _user = FirebaseAuth.instance;
  var user = Auth();

  // get current user email
  Future<String?> getUserEmail() {
    return user.getEmail();
  }

  Future<void> restoreBookmark() async {
    var email = await getUserEmail();
    final doc = await firestore.collection(email!).doc("bookmark").get();
    final data = doc.data();
    final bookmark = data;
  }

  // backup bookmark
  Future<void> backupBookmark(List datas) async {
    var email = await getUserEmail();
    // delete old bookmark
    if (await firestore
        .collection(email!)
        .doc("bookmark")
        .get()
        .then((value) => value.exists)) {
      await firestore.collection(email).doc("bookmark").delete();
      for (var i = 0; i < datas.length; i++) {
        await firestore.collection(email).doc("bookmark").set(
          {
            i.toString(): datas[i],
          },
          SetOptions(merge: true),
        );
      }
    }
    for (var i = 0; i < datas.length; i++) {
      await firestore.collection(email).doc("bookmark").set(
        {
          i.toString(): datas[i],
        },
        SetOptions(merge: true),
      );
    }
    // add new bookmark
  }

// get data from firestore
  Future<void> getData() async {
    var email = await getUserEmail();
    var datas = await firestore.collection(email!).doc('bookmark').get();
    var src = datas.data();
    // delete all bookmark in hive
    var box = await Hive.openBox('bookmarks');
    await box.clear();
    // restore bookmark
    for (var i = 0; i < src!.length; i++) {
      // data.add(src[i.toString()]);
      await box.put(src[i.toString()]['id'], src[i.toString()]);
    }
  }
}
