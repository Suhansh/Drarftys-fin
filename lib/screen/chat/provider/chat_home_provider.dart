import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHomeProvider {
  final FirebaseFirestore firebaseFirestore;

  ChatHomeProvider({required this.firebaseFirestore});

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore.collection(collectionPath).doc(path).update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getStreamFireStore(String pathCollection, int limit, String? textSearch) {
    return firebaseFirestore
        .collection(pathCollection)
        .limit(limit)
        // .where(FirestoreConstants.shopId, isEqualTo: textSearch)
        .snapshots();
  }


}
