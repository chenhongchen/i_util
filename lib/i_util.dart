export 'appBar/i_app_bar_util.dart';
export 'appBar/i_app_bar.dart';
export 'router/i_router.dart';
export 'router/net_status_manager.dart';
export 'i_size.dart';
export 'i_alert.dart';
export 'i_extension.dart';
export 'i_logger.dart';
export 'i_ui.dart';
export 'bottom_sheet/i_bottom_sheet.dart';
export 'bottom_sheet/i_bottom_sheet_view.dart';
import 'i_util_platform_interface.dart';

class IUtil {
  Future<String?> getPlatformVersion() {
    return IUtilPlatform.instance.getPlatformVersion();
  }
}
