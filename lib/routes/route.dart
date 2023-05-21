import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/orders/torders_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/books/tbooks_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/view.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSC/TSSC%20View/tsscpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSC/tssc_view.dart';
import 'package:tssr_ctrl/pages/ADMIN/report_/report_view.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/franchise_upload/franchiseupload_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/hall%20tkt%20View/hallticketpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/hall%20tkt%20upload/hallticketupload_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/home_page/homepage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/study_centre_view.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/T%20Store%20item%20page/tstoreitempage_index.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/T%20store%20page/tstorepage_index.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/home(FR)/homefr_index.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/order%20success%20Page/ordersuccess_index.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/report(FR)/reportfranchise_index.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/student_upload/studentupload_index.dart';
import 'package:tssr_ctrl/pages/profile/profile_index.dart';
import 'package:tssr_ctrl/test.dart';
import 'package:tssr_ctrl/test_page/testpage_index.dart';
import 'names.dart';
import 'package:tssr_ctrl/pages/login/loginpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/TSSR%20View/tssrpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/Tssr%20Upload/tssruploadpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSC/Tssc%20Upload/tsscuploadpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/gallery_upload/gallery_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/tssr_view.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/franchise_view/franchisepage_index.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/student_view/studentpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/courses/courses_index.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: AppRouteNames.LOGIN,
      page: () => LoginPage(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: AppRouteNames.TSSR_ADMIN,
      page: () => TssrPage(),
      binding: TssrPageBinding(),
    ),
    GetPage(
      name: AppRouteNames.TSSR_UPLOAD,
      page: () => TssrUploadPage(),
      binding: TssrUploadPageBinding(),
    ),
    GetPage(
      name: AppRouteNames.HOME,
      page: () => HomePage(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: AppRouteNames.TSSC_UPLOAD,
      page: () => TsscUploadPage(),
      binding: TsscUploadPageBinding(),
    ),
    GetPage(
      name: AppRouteNames.TSSC_ADMIN,
      page: () => TsscPage(),
      binding: TsscPageBinding(),
    ),
    GetPage(
      name: AppRouteNames.HALL_TICKET_UPLOAD,
      page: () => HallTicketUploadPage(),
      binding: HallTicketUploadBinding(),
    ),
    GetPage(
      name: AppRouteNames.HALL_TICKET_VIEW,
      page: () => HallTicketPage(),
      binding: HallTicketPageBinding(),
    ),
    GetPage(
      name: AppRouteNames.GALLERY,
      page: () => GalleryPage(),
      binding: GalleryBinding(),
    ),
    GetPage(
      name: AppRouteNames.FRANCHISE_UPLOAD,
      page: () => FranchiseUploadPage(),
      binding: FranchiseUploadBinding(),
    ),
    GetPage(
      name: AppRouteNames.HOME_FR,
      page: () => HomeFrPage(),
      binding: HomeFrBinding(),
    ),
    GetPage(
      name: AppRouteNames.PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRouteNames.FRANCHISE_DATA,
      page: () => FranchisePage(),
      binding: FranchisePageBinding(),
    ),
    GetPage(
      name: AppRouteNames.T_STORE_FR,
      page: () => TStorePage(),
      binding: TStorePageBinding(),
    ),
    GetPage(
      name: AppRouteNames.T_STORE_ITEM_FR,
      page: () => TStoreItemPage(),
      binding: TStoreItemPageBinding(),
    ),
    GetPage(
      name: AppRouteNames.ORDER_SUCCESS,
      page: () => OrderSuccessPage(),
      binding: OrderSuccessBinding(),
    ),
    GetPage(
      name: AppRouteNames.TSTORE_ADMIN,
      page: () => TStoreAdmin(),
    ),
    GetPage(
      name: AppRouteNames.TSSR_HOME_PAGE,
      page: () => TSSRHomePage(),
    ),
    GetPage(
      name: AppRouteNames.TSSC_HOME_PAGE,
      page: () => TSSCHomePage(),
    ),
    GetPage(
      name: AppRouteNames.REPORT_HOME_PAGE,
      page: () => ReportHomePage(),
    ),
    GetPage(
      name: AppRouteNames.STUDY_CENTRE_HOME_PAGE,
      page: () => StudyCentreHomePage(),
    ),
    GetPage(
      name: AppRouteNames.TSTORE_ADMIN_ORDERS,
      page: () => TOrdersPage(),
      binding: TOrdersBinding(),
    ),
    GetPage(
      name: AppRouteNames.TSTORE_ADMIN_BOOKS,
      page: () => TBooksPage(),
      binding: TBooksBinding(),
    ),
    GetPage(
      name: AppRouteNames.STUDENT_UPLOAD,
      page: () => StudentUpload(),
      binding: StudentUploadBinding(),
    ),
    GetPage(
      name: AppRouteNames.STUDENT_VIEW,
      page: () => StudentPage(),
      binding: StudentPageBinding(),
    ),
    GetPage(
      name: AppRouteNames.COURSES_ADMIN,
      page: () => CoursesPage(),
      binding: CoursesBinding(),
    ),
    GetPage(
      name: AppRouteNames.REPORT_HOME_PAGE_FR,
      page: () => ReportFranchisePage(),
      binding: ReportFranchiseBinding(),
    ),
    GetPage(
      name: AppRouteNames.TEST_PAGE,
      page: () => TestPage(),
      binding: TestPageBinding(),
    ),
  ];
}
