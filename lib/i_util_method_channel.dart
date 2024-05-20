import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'i_util_platform_interface.dart';

/// An implementation of [IUtilPlatform] that uses method channels.
class MethodChannelIUtil extends IUtilPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('i_util');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
