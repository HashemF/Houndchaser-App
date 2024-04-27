import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Pets/auth/cubit/auth_cubit.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:houndchaser_groupproject/Widgets/LoginButton.dart';


///Main page of app provides navigation to three screens:
///pet_list screen
///schedule_walk_view
///current_walk_page
///
/// Edited By Hashem
/// @author Evan


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(

      navigationBar: CupertinoNavigationBar(
        trailing: LoginButton(),
        middle: const Text('Hound Chaser'),
        backgroundColor: CupertinoColors.systemBrown,
      ),
      child: Center(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSignedIn) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Allows dynamic resizing of images
                  Expanded(
                    child: Image.asset('assets/walking.png'),
                  ),
                  CupertinoButton(
                    //Click the "Schedule your walk" Button to bring a page to select your pet and decide on a time for your walk
                    key: const Key('scheduleWalkButton'),
                    onPressed: () => Navigator.pushNamed(context, RouteGenerator.scheduleWalkPage),
                    child: const Text('Schedule your walk'),
                  ),
                  //dynamic image resizing
                  Expanded(
                    child: Image.asset('assets/viewPets.png'),
                  ),
                  CupertinoButton(
                    //Click the "Manage Pets" Button to bring a page detailing the pets you have inputted.
                    key: const Key('managePetsButton'),
                    onPressed: () => Navigator.pushNamed(context, RouteGenerator.petListPage),
                    child: const Text('Manage Pets'),
                  ),
                  //dynamic image resizing
                  Expanded(
                    child: Image.asset('assets/startWalk.png'),
                  ),
                  CupertinoButton(
                    //Click the "Start Walk" Button to start a walk
                    key: const Key('walkButton'),
                    onPressed: () => Navigator.pushNamed(context, RouteGenerator.currentWalkPage),
                    child: const Text('Start Walk'),
                  ),
                ],
              );
            }
            else {
              return LoginButton();
            }
          },
        )
      ),
    );
  }
}