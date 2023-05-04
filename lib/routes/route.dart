import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/orders/torders_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/books/tbooks_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/view.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSC%20Page/tsscpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/franchise_upload/franchiseupload_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/hall%20tkt%20Page/hallticketpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/hall%20tkt%20upload/hallticketupload_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/home_page/homepage_index.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/T%20Store%20item%20page/tstoreitempage_index.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/T%20store%20page/tstorepage_index.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/home(FR)/homefr_index.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/order%20success%20Page/ordersuccess_index.dart';
import 'package:tssr_ctrl/pages/profile/profile_index.dart';
import 'names.dart';
import 'package:tssr_ctrl/pages/login/loginpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR Page/tssrpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/Tssr Upload/tssruploadpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/Tssc Upload/tsscuploadpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/gallery_upload/gallery_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/franchise_page/franchisepage_index.dart';


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
      name: AppRouteNames.TSTORE_ADMIN_ORDERS,
      page: () => TOrdersPage(),
      binding: TOrdersBinding(),
    ),
     GetPage(
      name: AppRouteNames.TSTORE_ADMIN_BOOKS,
      page: () => TBooksPage(),
      binding: TBooksBinding(),
    ),
  ];
}
