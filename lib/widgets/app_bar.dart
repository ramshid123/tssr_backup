import 'package:flutter/material.dart';
import 'package:tssr_ctrl/constants/colors.dart';

PreferredSizeWidget CustomAppBar(String title) {
  return AppBar(
    toolbarHeight: 75,
    backgroundColor: ColorConstants.blachish_clr,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    ),
    actions: [],
  );
}

PreferredSizeWidget CustomAppBarForTstore(String title) {
  return AppBar(
    toolbarHeight: 75,
    backgroundColor: ColorConstants.blachish_clr,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    ),
    actions: [],
  );
}
