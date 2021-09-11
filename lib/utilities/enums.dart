import 'package:logger/logger.dart';

// enum EStatus { unknown, loading, succeed }

class Enums {
  static String toText(dynamic element) => element.toString().split('.').last;

  static toEnum(String value, List<dynamic> enumValues) {
    try {
      return enumValues.singleWhere((element) => toText(element) == value);
    } on StateError catch (_) {
      Logger().wtf('enum error!!!');
      return null;
    }
  }
}
