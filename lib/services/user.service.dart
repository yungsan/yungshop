import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final _fs = FirebaseFirestore.instance.collection('users');

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUser() async {
    return await _fs.get();
  }

  getUser(String? id) async {
    return await _fs.doc(id).get();
  }
}
