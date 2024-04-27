import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Pets/auth/cubit/auth_cubit.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:houndchaser_groupproject/Widgets/LoginButton.dart';
import '../db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Widgets/CustomCupertinoListTile.dart';

import '../pet.dart';

/// PetList
///
/// @author Tristan
/// @edited by Hashem and Evan
/// @description Widget class to display a list of pets, contains basic
/// @description CRUD functionality and Cupertino scaffolds and buttons to manage and delete your pets.

class PetList extends StatelessWidget {
  const PetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('My Pets'),
        trailing: LoginButton(),
        backgroundColor: CupertinoColors.systemBrown,
      ),
      child: SafeArea(

        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, aState) {
            if (aState is AuthSignedIn) {
              return Column(
                children: [
                  Expanded(
                    child: BlocBuilder<PetDBCubit, PetDBState>(
                      builder: (context, state) {
                        context.read<PetDBCubit>().getValidPets(aState.id);

                        List<Pet> petList = state.validPets;

                        if (petList.isEmpty) {
                          return const Center(child: Text("No pets added yet"));
                        }
                        else {
                          return ListView.builder(
                            itemCount: petList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: [
                                  Expanded(child: CustomCupertinoListTile(
                                      title: petList[index].name,
                                      onTap: () => {
                                        context.read<PetDBCubit>().getPet(state.petList.indexOf(petList[index])),
                                        Navigator.of(context).pushNamed(
                                            RouteGenerator.petInfoPage),
                                      }
                                  ),
                                  ),
                                  IconButton( //Click the Trashcan Icon in order to delete your pet permanently from the list.
                                      key: const Key('deletePetButton'),
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        //Call the deletePet method
                                        context.read<PetDBCubit>().deletePet(petList[index]);
                                      }
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  CupertinoButton( //Click the button titled "Add Pet" to take you to a page where you can input information on your pet and/or add more
                    color: CupertinoColors.activeBlue,
                    onPressed: () {
                      //Navigate to the Add Pet screen
                      Navigator.of(context).pushNamed(RouteGenerator.petAddPage);
                    },
                    key: const Key('addPetButton'),
                    child: const Text('Add Pet'),
                  ),
                ],
              );
            }
            else {
              return CupertinoButton(
                child: const Text("Please log in"),
                onPressed: () => Navigator.of(context).pushNamed(RouteGenerator.loginPage)
              );
            }
          }
        )
      ),
    );
  }
}