
import 'package:intl/intl.dart';

List<String> extractThreeNames(String input) {
  List<String> names = input.split(' ');

  if (names.length == 3) {
    RegExp nameRegex = RegExp(r"^[a-zA-Z.'-]{3,}$");

    bool isValid = names.every((name) => nameRegex.hasMatch(name));
    if (isValid) {
      return names;
    }
  }

  return [];
}

bool hasThreeNames(String input) {
  List<String> names = input.split(' ');

  if (names.length != 3) {
    return false;
  }

  RegExp nameRegex = RegExp(r"^[a-zA-Z.'-]{3,}$");

  for (String name in names) {
    if (!nameRegex.hasMatch(name)) {
      return false;
    }
  }

  return true;
}

bool isVaziCode(String input) {
  List<String> names = input.split('-');

  if (names.length != 4) {
    return false;
  }

  RegExp nameRegex = RegExp(r"^[a-zA-Z.'-]{3,}$");

  for (String name in names) {
    if (!nameRegex.hasMatch(name)) {
      return false;
    }
  }

  return true;
}

bool isValidPhoneNumber(String input) {
  if (input.length != 13) {
    return false;
  }

  return input.startsWith("+2556") || input.startsWith("+2557");
}

bool isValidEmail(String email) {
  if (email.isEmpty) {
    return false;
  }

  RegExp emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    caseSensitive: false,
  );

  return emailRegex.hasMatch(email);
}

bool isValidPassword(String password) {
  if (password.length < 6) {
    return false;
  }

  RegExp letterRegex = RegExp(r'[a-zA-Z]');
  RegExp digitRegex = RegExp(r'[0-9]');

  bool hasLetter = letterRegex.hasMatch(password);
  bool hasDigit = digitRegex.hasMatch(password);

  return hasLetter && hasDigit;
}

bool hasOnlyNumbersAndLength(String input, int length) {
  RegExp numbersRegex = RegExp(r'^[0-9]+$');

  if (input.length != length) {
    return false;
  }

  return numbersRegex.hasMatch(input);
}

bool checkSelectedInputsFun(
    Map<String, String> selectVals, List<String> testKeys) {
  for (var i = 0; i < testKeys.length; i++) {
    if (!selectVals.containsKey(testKeys[i]) ||
        selectVals[testKeys[i]] == '' ||
        selectVals[testKeys[i]] == 'Chagua') {
      return false;
    }
  }
  return true;
}

bool validatePlateNumber(String plateNumber) {
  RegExp pattern1 = RegExp(r'^[A-Z]\s\d{3}\s[A-Z]{3}$'); // T 123 ABC pattern
  RegExp pattern2 = RegExp(r'^MC\s\d{3}\s[A-Z]{3}$'); // MC 123 ABC pattern

  if (pattern1.hasMatch(plateNumber) || pattern2.hasMatch(plateNumber)) {
    return true;
  } else {
    return false;
  }
}

bool isDateString(String str) {
  try {
    DateTime.parse(str);
    return true;
  } catch (e) {
    return false;
  }
}


String timeAgoSinceDate(time,{bool numericDates = false}) {
      DateTime date = time;
      final date2 = DateTime.now().toLocal();
      final difference = date2.difference(date);

      if (difference.inSeconds < 5) {
        return 'Just now';
      } else if (difference.inSeconds <= 60) {
        return '${difference.inSeconds} seconds ago';
      } else if (difference.inMinutes <= 1) {
        return (numericDates) ? '1 minute ago' : 'A minute ago';
      } else if (difference.inMinutes <= 60) {
        return DateFormat('kk:mm').format(date);
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inHours <= 1) {
        return (numericDates) ? '1 hour ago' : 'An hour ago';
      } else if (difference.inHours <= 24) {
        return DateFormat('kk:mm').format(date);
        return '${difference.inHours} hours ago';

      } else if (difference.inDays <= 1) {
        return (numericDates) ? '1 day ago' : 'Yesterday';
      }
      // else if (difference.inDays <= 6) {
      //   return '${difference.inDays} days ago';
      // } else if ((difference.inDays / 7).ceil() <= 1) {
      //   return (numericDates) ? '1 week ago' : 'Last week';
      // } else if ((difference.inDays / 7).ceil() <= 4) {
      //   return '${(difference.inDays / 7).ceil()} weeks ago';
      // } else if ((difference.inDays / 30).ceil() <= 1) {
      //   return (numericDates) ? '1 month ago' : 'Last month';
      // } else if ((difference.inDays / 30).ceil() <= 30) {
      //   return '${(difference.inDays / 30).ceil()} months ago';
      // }
      else if ((difference.inDays / 365).ceil() <= 1) {
        return DateFormat('dd-MMM-yy').format(date);
        return (numericDates) ? '1 year ago' : 'Last year';
      }
        return DateFormat('dd-MMM-yy').format(date);
      return '${(difference.inDays / 365).floor()} years ago';
    }

// // image id urlProcessor
// String imageProcessorFromID(String imageD) {
//   Map<String, dynamic> logData = DriverPrefences.getLoggedinDetails();
//   String logKey = logData[DriverPrefences.logKey];
//   String logSess = logData[DriverPrefences.logSess];
//   String urlx = '$mediaUrlCore/get/image/$imageD/$logKey/$logSess/drivers';
//   return urlx;
// }
//
// // Network Image
// String networkUserImageUrl(String imageD) {
//   Map<String, dynamic> logData = DriverPrefences.getLoggedinDetails();
//   String logKey = logData[DriverPrefences.logKey];
//   String logSess = logData[DriverPrefences.logSess];
//   String urlx = '$baseUrl/get/image/$imageD/$logKey/$logSess/drivers';
//   return urlx;
// }
