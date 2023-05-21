import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  static final db = FirebaseFirestore.instance;

  static final tssrCollection = db.collection('TSSR_Data');
  static final tsscCollection = db.collection('TSSC_Data');
  static final hallTKTCollection = db.collection('HT_Data');
  static final FranchiseCollection = db.collection('Franchise');
  static final StoreCollection = db.collection('TStore');
  static final OrderCollection = db.collection('Orders');
  static final CourseCollection = db.collection('Courses');
  static final StudentDetailsCollection = db.collection('StudentDetails');
}