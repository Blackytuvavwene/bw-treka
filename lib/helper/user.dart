import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bw_treka/model/user.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
  String uid;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserServices({this.uid});

  UserModel _userFromFirebase(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    users.doc(id).set(values);
  }

  void updateUserData(Map<String, dynamic> values) {
    users.doc(values['id']).update(values);
  }

  void registerContact(String contactUid) async {
    //bool positiveCont;
    await users.doc(contactUid).get().then((doc) {
      //positiveCont = doc.data['positivo_covid'];
    });

    String now = DateTime.now().toString();
    users.doc(uid).collection('contacts').doc(contactUid + now).set({
      'uid': contactUid,
      'datetime': DateFormat('dd-MM-yyyy – kk:mm').format(DateTime.now()),
    });
  }

  Future<UserModel> getUserById(String id) => users.doc(id).get().then((doc) {
        if (doc.data == null) {
          return null;
        }
        return UserModel();
      });

  Future getContacts() async {
    return await users.doc(uid).collection('contacts').get().then((snapshot) {
      return snapshot.docs;
    });
  }
}
