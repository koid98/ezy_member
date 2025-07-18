import 'package:encrypt/encrypt.dart';

final key = Key.fromUtf8('thisencryptionworksforezyseries!'); //32 chars
final iv = IV.fromUtf8('justezyseriesuse'); //16 chars

//encrypt
Future<String> encryptMyData(String text) async{
  final e = Encrypter(AES(key, mode: AESMode.cbc));
  final encryptedData = e.encrypt(text, iv: iv);
  return encryptedData.base64;
}

//dycrypt
Future<String> decryptMyData(String text) async{
  final e = Encrypter(AES(key, mode: AESMode.cbc));
  final decryptedData = e.decrypt(Encrypted.fromBase64(text), iv: iv);
  return decryptedData;
}