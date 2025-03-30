import 'package:flutter/cupertino.dart';

import 'colors.dart';

class Global {
  static verticalSpace(BuildContext context, double size) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * size,
    );
  }

  static horizontalSpace(BuildContext context, double size) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * size,
    );
  }

  static customFonts({Color color = AppColors.blackColor, double size = 12, FontWeight weight = FontWeight.normal, family = 'Poppins1'}) {
    return TextStyle(color: color, fontFamily: family, fontSize: size, fontWeight: weight);
  }
}
