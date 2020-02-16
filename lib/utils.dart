import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';

class Utils {
  static double deviceWidth(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Platform.isIOS ? deviceWidth / 2 : deviceWidth;
  }

  static double deviceHeight(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Platform.isIOS ? deviceHeight / 2 : deviceHeight;
  }
}
