import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/bil_services.dart';
import '../../services/shared_prefences.dart';
import '../../utils/app_widget.dart';

class AllBillsPage extends StatefulWidget {
  AllBillsPage({super.key});

  @override
  State<AllBillsPage> createState() => _AllBillsPageState();
}

class _AllBillsPageState extends State<AllBillsPage> {
  final BillService billService = BillService();
  String? userId;
  QuerySnapshot? querySnapshot;
  StreamSubscription? billSubscription;
  @override
  void initState() {
    super.initState();
    initRegister();
  }

  initRegister() {
    SharedPreferenceHelper().getUserId().then((userIds) {
      if (userIds != null) {
        userId = userIds;
        billSubscription = billService.billsCollection
            .doc(userId)
            .collection('orderItems')
            .snapshots()
            .listen((QuerySnapshot event) {
          setState(() {
            querySnapshot = event;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    billSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Tổng hóa đơn',
            style: AppWidget.HeadlinextFieldStyle(),
          ),
        ),
        body: (querySnapshot?.docs.isEmpty ?? true)
            ? const SizedBox()
            : ListView.builder(
                itemCount: querySnapshot?.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      querySnapshot?.docs[index].data() as Map<String, dynamic>;
                  String? foodName = '...';
                  if (data['orderItems'] != null && data['orderItems'].length >= 0) {
                    foodName = data['orderItems'][0]['foodName'] ?? 'Unknown';
                  }

                  // Convert timestamp to DateTime object
                  DateTime timestamp = (data['time'] as Timestamp).toDate();

                  // Format timestamp using DateFormat
                  String formattedDate = DateFormat.yMMMd().add_jm().format(timestamp);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(
                        'Food: $foodName',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price: \$${data['totalPrice']}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Timestamp: $formattedDate',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
        );
  }
}
