import 'package:flutter/cupertino.dart';
import '../Home/home_page.dart';
import '../Pets/List/pet_list.dart';
import '../Pets/View/pet_view.dart';
import '../Pets/List/add_pet.dart';
import '../Pets/View/schedule_walk_view.dart';
import '../Pets/List/select_pets_view.dart';
import 'package:houndchaser_groupproject/Walk/current_walk_page.dart';

import '../Pets/auth/auth_login.dart';
import '../Pets/auth/auth_register.dart';
/// RouteGenerator
///
/// @author Tristan
/// @description Navigation class for controlling moving between screens

class RouteGenerator {
  static const String homePage = "/";
  static const String scheduleWalkPage = "/schedulePage";
  static const String petListPage = "/petListPage";
  static const String petInfoPage = "/petInfoPage";
  static const String petAddPage = "/petAddPage";
  static const String recommendPage = "/recommendPage";
  static const String currentWalkPage = "/currentWalkPage";
  static const String selectPetPage = "/selectPetPage";
  static const String loginPage = "/loginPage";
  static const String registerPage = "/registerPage";
  //@TODO possibly add more Strings for screens as needed.

  RouteGenerator._();

  //@TODO add routes as screens are added.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case homePage:
        return CupertinoPageRoute(
            builder: (_) => const HomePage(),
        );
      case petListPage:
        return CupertinoPageRoute(
        builder: (_) => const PetList()
        );
      case petInfoPage:
        return CupertinoPageRoute(
            builder: (_) => const PetView(),
        );
      case petAddPage:
        return CupertinoPageRoute(
            builder: (_) => const AddPetPage(),
        );
      case scheduleWalkPage:
        return CupertinoPageRoute(
          builder: (_) => const ScheduleWalk(),
        );
      case selectPetPage:
        return CupertinoPageRoute(
          builder: (_) => const SelectPetsForWalkPage(),
        );
      case currentWalkPage:
        return CupertinoPageRoute(
          builder: (_) => CurrentWalkPage(),
        );
      case loginPage:
        return CupertinoPageRoute(
          builder: (_) => LoginPage(),
        );
      case registerPage:
        return CupertinoPageRoute(
          builder: (_) => RegisterPage(),
        );
    }
    return CupertinoPageRoute(builder: (context) => const Text("No page found"));
  }
}