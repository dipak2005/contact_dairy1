import 'package:flutter/material.dart';

ThemeData dark = ThemeData.dark().copyWith(
  useMaterial3: true,
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25),
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 30,
    ),
    actionsIconTheme: IconThemeData(
      color: Colors.green,
    ),
  ),
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (context) {
      return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
        ),
      );
    },
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(

      elevation: MaterialStatePropertyAll(2),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
  ),
);
