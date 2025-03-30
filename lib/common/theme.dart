import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.whiteColor,
    ),
    tabBarTheme: const TabBarTheme(
        indicatorColor: AppColors.whiteColor,
        labelColor: AppColors.whiteColor,
        unselectedLabelColor: AppColors.greyColor),
    useMaterial3: true,
  );
}
