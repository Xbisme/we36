import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/services/push/push_models.dart';

/// Coarse deep-link target for a tapped push (#013 US2/US5). The backend payload
/// is thin (`{kind, notificationId?}`) and there is no get-by-id, so a cold tap
/// routes coarsely: a DM push (`kind == 'message'`) → Messages; any feed-activity
/// push → the Activity screen. In-app live rows deep-link precisely (the page).
String pushTapRoute(PushTapData tap) =>
    tap.isMessage ? AppRoutes.messages : AppRoutes.notifications;
