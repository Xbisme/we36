// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'We36';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navExplore => 'Khám phá';

  @override
  String get navReels => 'Reels';

  @override
  String get navMessages => 'Tin nhắn';

  @override
  String get navProfile => 'Trang cá nhân';

  @override
  String get navNotifications => 'Thông báo';

  @override
  String get navCreate => 'Tạo';

  @override
  String get yourStory => 'Tin của bạn';

  @override
  String get actionFollow => 'Theo dõi';

  @override
  String get actionFollowing => 'Đang theo dõi';

  @override
  String get actionMessage => 'Nhắn tin';

  @override
  String get actionShare => 'Chia sẻ';

  @override
  String get actionRetry => 'Thử lại';

  @override
  String get actionCancel => 'Hủy';

  @override
  String viewAllComments(String count) {
    return 'Xem tất cả $count bình luận';
  }

  @override
  String get suggestionsTitle => 'Gợi ý cho bạn';

  @override
  String get searchHint => 'Tìm kiếm';

  @override
  String get devGalleryTitle => 'Thư viện thành phần';

  @override
  String get devStatesTitle => 'Demo bốn trạng thái';

  @override
  String get devTwoPaneTitle => 'Demo hai khung';

  @override
  String get stateInitial => 'Ban đầu';

  @override
  String get stateLoading => 'Đang tải';

  @override
  String get stateLoaded => 'Đã tải';

  @override
  String get stateError => 'Lỗi';

  @override
  String get selectAnItem => 'Chọn một mục';

  @override
  String get errUnauthenticated => 'Vui lòng đăng nhập để tiếp tục.';

  @override
  String get errSessionExpired => 'Phiên đã hết hạn. Vui lòng đăng nhập lại.';

  @override
  String get errInvalidCredentials => 'Email hoặc mật khẩu không đúng.';

  @override
  String get errOauthCancelled => 'Đã hủy đăng nhập.';

  @override
  String get errOauthFailed => 'Đăng nhập thất bại. Vui lòng thử lại.';

  @override
  String get errForbidden => 'Bạn không có quyền truy cập nội dung này.';

  @override
  String get errNotFound => 'Nội dung này không khả dụng.';

  @override
  String get errAccountSuspended => 'Tài khoản này đã bị khóa.';

  @override
  String get errValidation => 'Vui lòng kiểm tra các trường được đánh dấu.';

  @override
  String get errConflict => 'Đã có người sử dụng.';

  @override
  String get errRateLimited => 'Quá nhiều lần thử. Vui lòng chờ một lát.';

  @override
  String get errUploadFailed => 'Tải lên thất bại. Vui lòng thử lại.';

  @override
  String get errMediaTooLarge => 'Tệp quá lớn.';

  @override
  String get errUnsupportedMedia => 'Loại tệp này không được hỗ trợ.';

  @override
  String get errCameraUnavailable => 'Máy ảnh không khả dụng.';

  @override
  String get errPermissionDenied => 'Cần cấp quyền để thực hiện việc này.';

  @override
  String get errRealtimeDisconnected =>
      'Bạn đang ngoại tuyến với cập nhật trực tiếp.';

  @override
  String get errMessageFailed => 'Gửi tin nhắn thất bại.';

  @override
  String get errNetwork => 'Sự cố mạng. Vui lòng kiểm tra kết nối.';

  @override
  String get errServer => 'Đã xảy ra lỗi từ phía chúng tôi.';

  @override
  String get errTimeout => 'Quá thời gian chờ. Vui lòng thử lại.';

  @override
  String get errOffline => 'Bạn đang ngoại tuyến.';

  @override
  String get errUnknown => 'Đã xảy ra lỗi.';
}
