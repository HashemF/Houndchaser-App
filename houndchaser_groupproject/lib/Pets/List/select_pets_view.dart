import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Pets/db/pet_db.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:houndchaser_groupproject/Widgets/LoginButton.dart';
import '../auth/cubit/auth_cubit.dart';
import '../db/cubit/pet_db_cubit.dart';
import '../pet.dart';
import '../db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Widgets/CustomCupertinoListTile.dart';

/// SelectPetsPage
/// For choosing which of your pets you wish to walk
/// This screen is the result of clicking "select pets" from schedule walk page
///
/// @author Evan

class SelectPetsForWalkPage extends StatelessWidget {
  const SelectPetsForWalkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Select Pets for a Walk'),
        trailing: LoginButton()
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, aState) {
          if (aState is AuthSignedIn) {
            return BlocBuilder<PetDBCubit, PetDBState>(
              builder: (context, state) {
                context.read<PetDBCubit>().getValidPets(aState.id);
                List<Pet> petList = state.validPets;

                if (petList.isEmpty) {
                  return const Center(child: Text("No pets added yet"));
                }

                return ListView.builder(
                  itemCount: petList.length,
                  itemBuilder: (context, index) {
                    Pet pet = petList[index];
                    bool isSelected = state.selectedPets.contains(pet);

                    return Card(
                        child: ListTile(
                          title: Text(pet.name),
                          //Adds a selected checkmark if a pet is selected
                          trailing: isSelected ? const Icon(CupertinoIcons.check_mark_circled_solid) : Icon(CupertinoIcons.circle),
                          onTap: () => context.read<PetDBCubit>().togglePetSelection(pet),
                        )
                    );
                  },
                );
              },
            );
          }
          else {
            return CupertinoButton(
                child: const Text("Please log in"),
                onPressed: () => Navigator.of(context).pushNamed(RouteGenerator.loginPage)
            );
          }
        },
      )
    );
  }
}

