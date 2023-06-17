import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  static final db = FirebaseFirestore.instance;

  static final tssrCollection = db.collection('TSSR_Data');
  static final tsscCollection = db.collection('TSSC_Data');
  static final hallTKTCollection = db.collection('HT_Data');
  static final FranchiseCollection = db.collection('Franchise');
  static final StoreCollection = db.collection('TStore');
  static final OrderCollection = db.collection('Orders');
  static final CourseCollection = db.collection('Courses');
  static final StudentDetailsCollection = db.collection('StudentDetails');
  static final ResultCollection = db.collection('Results');
  static final DeletedAccounts = db.collection('Deleted_Accounts');

  static Future<bool> checkInternetConnection() async {
    try {
      final response = await http
          .get(Uri.parse('https://rickandmortyapi.com/api/character/5'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
