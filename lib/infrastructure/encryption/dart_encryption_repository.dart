import '../../domain/repository/encryption_repository.dart';
import '../../main.dart';

class DartEncryptionRepository implements EncryptionRepository {

  @override
  String encrypt(String stringToEncrypt) {
    StringBuffer result = StringBuffer();

    for (int i = 0; i < stringToEncrypt.length; i++) {
      int charCode = stringToEncrypt.codeUnitAt(i);
      int xorResult = charCode ^ key;
      result.writeCharCode(xorResult);
    }

    return result.toString();
  }

  @override
  String decrypt(String stringToDecrypt) {
    return encrypt(stringToDecrypt);
  }
}