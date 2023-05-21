import 'package:flutter/material.dart';
import 'package:tssr_ctrl/constants/colors.dart';

PreferredSizeWidget CustomAppBar(String title) {
  return AppBar(
    toolbarHeight: 75,
    backgroundColor: ColorConstants.blachish_clr,
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_basket_sharp,
          size: 30,
          color: ColorConstants.greenish_clr,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    ),
    actions: [
      CircleAvatar(
        backgroundColor: Colors.white,
      ),
    ],
  );
}

PreferredSizeWidget CustomAppBarForTstore(String title) {
  return AppBar(
    toolbarHeight: 75,
    backgroundColor: ColorConstants.blachish_clr,
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_basket_sharp,
          size: 30,
          color: ColorConstants.greenish_clr,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    ),
    actions: [
      CircleAvatar(
        backgroundColor: Colors.white,
      ),
    ],
  );
}
