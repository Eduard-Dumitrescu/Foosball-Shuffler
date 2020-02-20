import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {
  static double deviceWidth(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Platform.isIOS ? deviceWidth / 2 : deviceWidth;
  }

  static double deviceHeight(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Platform.isIOS ? deviceHeight / 2 : deviceHeight;
  }

  static bool isKeyboardHidden(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom == 0;
  }

  static void dismissKeyboard(BuildContext context) {
    if (!Utils.isKeyboardHidden(context)) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }
}
