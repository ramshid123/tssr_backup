import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';

Widget CustomDrawer(
    int index, String name, String email, String atc, bool isAdmin) {
  return Drawer(
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          width: Get.width,
          color: ColorConstants.blachish_clr,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 35,
                  ),
                  radius: 35,
                ),
                SizedBox(height: 20),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  atc,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/profile_bg.jpeg'),
                fit: BoxFit.cover,
                opacity: 0.2
              )
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                DrawerItem('Home', Icons.home, index == 0, index, isAdmin),
                DrawerItem('My profile', Icons.person, index == 1, index, isAdmin),
                DrawerItem('Logout', Icons.logout, false, index, isAdmin),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Widget DrawerItem(
    String title, IconData icon, bool isSelected, int index, bool isAdmin) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        color: isSelected ? ColorConstants.purple_clr.withOpacity(0.4) : null,
        borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        if (title == 'Logout') {
          Get.defaultDialog(
            title: 'Logout',
            middleText: 'Do you want to logout?',
            confirm: ElevatedButton(
              onPressed: () async {
                await AuthService().logout();
              },
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: ColorConstants.purple_clr,
                  side: BorderSide(color: ColorConstants.purple_clr)),
            ),
            cancel:
                ElevatedButton(onPressed: () => Get.back(), child: Text('No')),
          );
        } else if (title == 'My profile') {
          if (index != 1) {
            Get.back();
            Get.toNamed(AppRouteNames.PROFILE);
          }
        } else if (title == 'Home') {
          index == 0
              ? null
              : Get.offAllNamed(
                  isAdmin ? AppRouteNames.HOME : AppRouteNames.HOME_FR);
        }
      },
      selected: isSelected,
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      leading: Icon(
        icon,
        size: 30,
      ),
    ),
  );
}
