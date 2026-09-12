import 'package:intl/intl.dart';

extension NumberFormatter on int {
  /// 숫자를 3자리마다 콤마가 포함된 문자열로 변환 (예: 15000 -> "15,000")
  String toCommaString() {
    return NumberFormat('#,###').format(this);
  }

  /// 뒤에 '원'을 붙여주는 금액 포맷 (예: 15000 -> "15,000원")
  String toWon() {
    return '${toCommaString()}원';
  }
}
