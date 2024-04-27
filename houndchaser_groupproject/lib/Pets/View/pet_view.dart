import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Widgets/LoginButton.dart';
import '../db/cubit/pet_db_cubit.dart';
import '../pet.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';

/// PetView
///
/// @author Evan and Tristan
/// @edited by Hashem
/// @description Widget class for the Pet View class
class PetView extends StatelessWidget {
  const PetView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetDBCubit, PetDBState>(
      builder: (context, state) {
        if (state.petList.isEmpty || state.index < 0 || state.index >= state.petList.length) {
          //If index is out of range, allow page reload
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoButton(
                //Click the "Schedule your walk" Button to bring a page to select your pet and decide on a time for your walk
                key: const Key('reloadPetViewButton'),
                onPressed: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Error: Please retry accessing your pet's information",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        Pet pet = state.petList[state.index];
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(pet.name),
            backgroundColor: Colors.brown,
            trailing: LoginButton(),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Allows dynamic resizing of images
                Expanded(
                  child: Image.asset('assets/petInfo.png'), //Will appear at the top middle of the screen
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column( //Will display the Breed, Age, Weight, Distance Walked, and Number of Walks taken here.
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        statRow('Breed, ', pet.breed),
                        statRow('Age', pet.ageString),
                        statRow('Weight', '${pet.weight.toStringAsPrecision(4)} lb'),
                        statRow('Distance Walked', '${pet.distance.toStringAsPrecision(5)} km'),
                        statRow('Number of Walks', pet.walks.toString()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Widget to display the our information we have on our pets. Utilizes "statRow" to display the pet information.
  Widget statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}