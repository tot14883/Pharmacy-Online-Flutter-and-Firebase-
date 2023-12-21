import 'package:flutter/material.dart';
import 'package:pharmacy_online/core/router/custom_page_route_builder.dart';
import 'package:pharmacy_online/feature/admin/page/admin_dashboard_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/banned_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/cosent_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/forgot_password_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_in_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_in_successful_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_up_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_up_successful_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/term_and_condition_screen.dart';
import 'package:pharmacy_online/feature/cart/page/address_delivery_screen.dart';
import 'package:pharmacy_online/feature/cart/page/my_cart_screen.dart';
import 'package:pharmacy_online/feature/cart/page/order_summary_screen.dart';
import 'package:pharmacy_online/feature/chat/page/chat_screen.dart';
import 'package:pharmacy_online/feature/chat/page/request_consult_screen.dart';
import 'package:pharmacy_online/feature/dashboard/page/dashboard_screen.dart';
import 'package:pharmacy_online/feature/home/page/home_screen.dart';
import 'package:pharmacy_online/feature/home/page/notification_screen.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/feature/order/page/add_review_screen.dart';
import 'package:pharmacy_online/feature/order/page/evidence_bank_transfer_screen.dart';
import 'package:pharmacy_online/feature/order/page/evidence_transportation_screen.dart';
import 'package:pharmacy_online/feature/order/page/order_detail_screen.dart';
import 'package:pharmacy_online/feature/order/page/upload_bank_transfer_screen.dart';
import 'package:pharmacy_online/feature/order/page/upload_transportation_screen.dart';
import 'package:pharmacy_online/feature/profile/page/change_password_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_profile_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_qr_code_screen.dart';
import 'package:pharmacy_online/feature/store/page/add_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/central_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/comment_screen.dart';
import 'package:pharmacy_online/feature/store/page/drug_detail_screen.dart';
import 'package:pharmacy_online/feature/store/page/edit_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/my_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/review_store_screen.dart';
import 'package:pharmacy_online/feature/store/page/store_detail_screen.dart';

class AppRouter {
  static const initialRouterName = MainScreen.routeName;

  static Route<dynamic>? router(RouteSettings settings) {
    switch (settings.name) {
      case MainScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: MainScreen.routeName,
          builder: (ctx) => const MainScreen(),
          transitionType: RouteTransition.fade,
        );

      case TermAndConditionScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: TermAndConditionScreen.routeName,
          builder: (ctx) => const TermAndConditionScreen(),
          transitionType: RouteTransition.fade,
        );

      case ConsentScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: ConsentScreen.routeName,
          builder: (ctx) => const ConsentScreen(),
          transitionType: RouteTransition.fade,
        );

      case DashboardScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: DashboardScreen.routeName,
          builder: (ctx) => const DashboardScreen(),
          transitionType: RouteTransition.fade,
        );

      case HomeScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: HomeScreen.routeName,
          builder: (ctx) => const HomeScreen(),
          transitionType: RouteTransition.fade,
        );

      case SignInScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: SignInScreen.routeName,
          builder: (ctx) => const SignInScreen(),
          transitionType: RouteTransition.fade,
        );

      case SignUpScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: SignUpScreen.routeName,
          builder: (ctx) => const SignUpScreen(),
          transitionType: RouteTransition.fade,
        );

      case SignUpSuccessfulScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: SignUpSuccessfulScreen.routeName,
          builder: (ctx) => const SignUpSuccessfulScreen(),
          transitionType: RouteTransition.fade,
        );

      case SignInSuccessfulScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: SignInSuccessfulScreen.routeName,
          builder: (ctx) => const SignInSuccessfulScreen(),
          transitionType: RouteTransition.fade,
        );

      case NotificationScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: NotificationScreen.routeName,
          builder: (ctx) => const NotificationScreen(),
          transitionType: RouteTransition.fade,
        );

      case StoreDetailScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: StoreDetailScreen.routeName,
          builder: (ctx) => const StoreDetailScreen(),
          transitionType: RouteTransition.fade,
        );

      case OrderDetailScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: OrderDetailScreen.routeName,
          builder: (ctx) => const OrderDetailScreen(),
          transitionType: RouteTransition.fade,
        );

      case UploadBankTransferScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: UploadBankTransferScreen.routeName,
          builder: (ctx) => const UploadBankTransferScreen(),
          transitionType: RouteTransition.fade,
        );

      case UploadTransportationScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: UploadTransportationScreen.routeName,
          builder: (ctx) => const UploadTransportationScreen(),
          transitionType: RouteTransition.fade,
        );

      case EvidenceTransportationScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: EvidenceTransportationScreen.routeName,
          builder: (ctx) => const EvidenceTransportationScreen(),
          transitionType: RouteTransition.fade,
        );

      case EvidenceBankTransferScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: EvidenceBankTransferScreen.routeName,
          builder: (ctx) => const EvidenceBankTransferScreen(),
          transitionType: RouteTransition.fade,
        );

      case AddReviewScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: AddReviewScreen.routeName,
          builder: (ctx) => const AddReviewScreen(),
          transitionType: RouteTransition.fade,
        );

      case EditQRCodeScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: EditQRCodeScreen.routeName,
          builder: (ctx) => const EditQRCodeScreen(),
          transitionType: RouteTransition.fade,
        );

      case ChangePasswordScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: ChangePasswordScreen.routeName,
          builder: (ctx) => const ChangePasswordScreen(),
          transitionType: RouteTransition.fade,
        );

      case EditProfileScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: EditProfileScreen.routeName,
          builder: (ctx) => const EditProfileScreen(),
          transitionType: RouteTransition.fade,
        );

      case EditPharmacyStoreScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: EditPharmacyStoreScreen.routeName,
          builder: (ctx) => const EditPharmacyStoreScreen(),
          transitionType: RouteTransition.fade,
        );

      case ReviewStoreScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: ReviewStoreScreen.routeName,
          builder: (ctx) => const ReviewStoreScreen(),
          transitionType: RouteTransition.fade,
        );

      case CommentScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: CommentScreen.routeName,
          builder: (ctx) => const CommentScreen(),
          transitionType: RouteTransition.fade,
        );

      case RequestConsultScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: RequestConsultScreen.routeName,
          builder: (ctx) => const RequestConsultScreen(),
          transitionType: RouteTransition.fade,
        );

      case ChatScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: ChatScreen.routeName,
          builder: (ctx) => const ChatScreen(),
          transitionType: RouteTransition.fade,
        );

      case MyMedicineWarehouseScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: MyMedicineWarehouseScreen.routeName,
          builder: (ctx) => const MyMedicineWarehouseScreen(),
          transitionType: RouteTransition.fade,
        );

      case CentralMedicineWarehouseScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: CentralMedicineWarehouseScreen.routeName,
          builder: (ctx) => const CentralMedicineWarehouseScreen(),
          transitionType: RouteTransition.fade,
        );

      case AddMedicineWarehouseScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: AddMedicineWarehouseScreen.routeName,
          builder: (ctx) => const AddMedicineWarehouseScreen(),
          transitionType: RouteTransition.fade,
        );

      case EditMedicineWarehouseScreen.routeName:
        assert(
          settings.arguments is MedicineWarehouseArgs ||
              settings.arguments == null,
          'arguments must be MedicineWarehouseArgs or null',
        );

        final args = settings.arguments as MedicineWarehouseArgs;

        return CustomPageRouteBuilder.route(
          name: EditMedicineWarehouseScreen.routeName,
          builder: (ctx) => EditMedicineWarehouseScreen(args: args),
          transitionType: RouteTransition.fade,
        );

      case MyCartScreen.routeName:
        assert(
          settings.arguments is MyCartArgs || settings.arguments == null,
          'arguments must be MyCartArgs or null',
        );

        final args = settings.arguments as MyCartArgs;

        return CustomPageRouteBuilder.route(
          name: MyCartScreen.routeName,
          builder: (ctx) => MyCartScreen(args: args),
          transitionType: RouteTransition.fade,
        );

      case DrugDetailScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: DrugDetailScreen.routeName,
          builder: (ctx) => const DrugDetailScreen(),
          transitionType: RouteTransition.fade,
        );

      case OrderSummaryScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: OrderSummaryScreen.routeName,
          builder: (ctx) => const OrderSummaryScreen(),
          transitionType: RouteTransition.fade,
        );

      case AddressDeliveryScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: AddressDeliveryScreen.routeName,
          builder: (ctx) => const AddressDeliveryScreen(),
          transitionType: RouteTransition.fade,
        );

      case ForgotPasswordScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: ForgotPasswordScreen.routeName,
          builder: (ctx) => const ForgotPasswordScreen(),
          transitionType: RouteTransition.fade,
        );

      case BannedScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: BannedScreen.routeName,
          builder: (ctx) => const BannedScreen(),
          transitionType: RouteTransition.fade,
        );

      // Admin
      case AdminDashboardScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: AdminDashboardScreen.routeName,
          builder: (ctx) => const AdminDashboardScreen(),
          transitionType: RouteTransition.fade,
        );

      // case RoomAndRateScreen.routeName:
      //   assert(
      //     settings.arguments is RoomAndRateScreenArgs ||
      //         settings.arguments == null,
      //     'arguments must be RoomAndRateScreenArgs or null',
      //   );

      //   final args = settings.arguments as RoomAndRateScreenArgs;

      //   return CustomPageRouteBuilder.route(
      //     name: RoomAndRateScreen.routeName,
      //     builder: (ctx) => RoomAndRateScreen(
      //       args: args,
      //     ),
      //     transitionType: RouteTransition.slideVertically,
      //   );

      default:
        assert(false, 'this should not be reached');
        return null;
    }
  }
}
