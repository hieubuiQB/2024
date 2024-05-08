import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/app/services/shared_prefences.dart';

class BillService {



  final CollectionReference billsCollection = FirebaseFirestore.instance.collection('bills');

  Future<void> saveBill(Map<String, dynamic> billData) async {

    final userId = await SharedPreferenceHelper().getUserId();
    print("billDatabillDatabillData ${jsonEncode(billData)}");
    billsCollection.doc(userId).collection('orderItems').add(billData).then((value) {
      print("User Added");
    }).catchError((error) {
      print("Failed to add user: $error");
    });
  }

  Stream<QuerySnapshot> getBills(String userId) {

    billsCollection.doc(userId).collection('orderItems').snapshots();
    return const Stream.empty();
  }
}
