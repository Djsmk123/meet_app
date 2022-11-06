import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Collections {
  final org = FirebaseFirestore.instance.collection('organisation');
  final userData = FirebaseFirestore.instance.collection('users_data');
  final eventData = FirebaseFirestore.instance.collection('events');

   User? user=FirebaseAuth.instance.currentUser;
  final userType = FirebaseFirestore.instance.collection('users');
}
