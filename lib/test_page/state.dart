import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class TestPageState {
  var docIdOfFranchise = '';
  var allCourseQuery = DatabaseService.CourseCollection.orderBy('course');
}
