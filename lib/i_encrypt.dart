import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/pkcs1.dart';
import 'package:pointycastle/asymmetric/rsa.dart';

/// 引用 https://www.jianshu.com/p/7945fe3a5789

class IEncrypt {
  // Rsa加密最大长度(密钥长度/8-11)
  static const int _maxEncryptBlock = 245;

  // Rsa解密最大长度(密钥长度/8)
  static const int _maxDecryptBlock = 256;

  /// 公钥分段加密
  /// content 加密内容
  /// keyPath 公钥文件路径
  static Future<String> encodeString({
    required String content,
    required String keyPath,
  }) async {
    //加载公钥字符串
    final publicPem = await rootBundle.loadString(keyPath);
    //创建公钥对象
    RSAPublicKey publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;
    //创建加密器
    final encryptor = Encrypter(RSA(publicKey: publicKey));

    //分段加密
    // 原始字符串转成字节数组
    List<int> sourceBytes = utf8.encode(content);
    //数据长度
    int inputLength = sourceBytes.length;
    // 缓存数组
    List<int> cache = [];
    // 分段加密 步长为MAX_ENCRYPT_BLOCK
    for (int i = 0; i < inputLength; i += _maxEncryptBlock) {
      //剩余长度
      int endLen = inputLength - i;
      List<int> item;
      if (endLen > _maxEncryptBlock) {
        item = sourceBytes.sublist(i, i + _maxEncryptBlock);
      } else {
        item = sourceBytes.sublist(i, i + endLen);
      }
      // 加密后对象转换成数组存放到缓存
      cache.addAll(encryptor.encryptBytes(item).bytes);
    }
    return base64Encode(cache);
  }

  /// 公钥分段解密
  /// content 解密内容
  /// keyPath 公钥文件路径
  static Future<String> decodeString({
    required String content,
    required String keyPath,
  }) async {
    //加载公钥字符串
    final publicPem = await rootBundle.loadString(keyPath);
    //创建公钥对象
    RSAPublicKey publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;

    AsymmetricBlockCipher cipher = PKCS1Encoding(RSAEngine());
    cipher.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));

    //分段解密
    //原始数据
    List<int> sourceBytes = base64Decode(content);
    //数据长度
    int inputLength = sourceBytes.length;
    // 缓存数组
    List<int> cache = [];
    // 分段解密 步长为MAX_DECRYPT_BLOCK
    for (var i = 0; i < inputLength; i += _maxDecryptBlock) {
      //剩余长度
      int endLen = inputLength - i;
      List<int> item;
      if (endLen > _maxDecryptBlock) {
        item = sourceBytes.sublist(i, i + _maxDecryptBlock);
      } else {
        item = sourceBytes.sublist(i, i + endLen);
      }
      //解密后放到数组缓存
      cache.addAll(cipher.process(Uint8List.fromList(item)));
    }
    return utf8.decode(cache);
  }
}
