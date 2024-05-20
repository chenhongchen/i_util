import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'i_util_method_channel.dart';

abstract class IUtilPlatform extends PlatformInterface {
  /// Constructs a IUtilPlatform.
  IUtilPlatform() : super(token: _token);

  static final Object _token = Object();

  static IUtilPlatform _instance = MethodChannelIUtil();

  /// The default instance of [IUtilPlatform] to use.
  ///
  /// Defaults to [MethodChannelIUtil].
  static IUtilPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IUtilPlatform] when
  /// they register themselves.
  static set instance(IUtilPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
