import 'package:flutter_test/flutter_test.dart';
import 'package:i_util/i_util.dart';
import 'package:i_util/i_util_platform_interface.dart';
import 'package:i_util/i_util_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIUtilPlatform
    with MockPlatformInterfaceMixin
    implements IUtilPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IUtilPlatform initialPlatform = IUtilPlatform.instance;

  test('$MethodChannelIUtil is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIUtil>());
  });

  test('getPlatformVersion', () async {
    IUtil iUtilPlugin = IUtil();
    MockIUtilPlatform fakePlatform = MockIUtilPlatform();
    IUtilPlatform.instance = fakePlatform;

    expect(await iUtilPlugin.getPlatformVersion(), '42');
  });
}
