import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../pet.dart';
import '../pet_db.dart';
part 'pet_db_state.dart';

/// PetView
/// Edited by Hashem
/// @author Tristan
/// @description Bloc cubit class for the Pet database
///

class PetDBCubit extends Cubit<PetDBState> {
  PetDatabase db;
  late StreamSubscription subscription;

  PetDBCubit(this.db) : super(const PetDBState()) {
    getPetList();
    subscription = db.subscribe(_processEvent);
  }
  // Events related to the db state will be processed here.
  void _processEvent(DatabaseEvent event) {
    final petMap = event.snapshot.value as Map<dynamic, dynamic>;
    final weight = petMap[PetDatabase.weightField];
    //Converts weight to a double if it is stored as an int
    double parsedWeight = weight is int ? weight.toDouble() : weight;
    Pet pet = Pet(
        key: petMap[PetDatabase.keyField],
        name: petMap[PetDatabase.nameField],
        breed: petMap[PetDatabase.breedField],
        weight: parsedWeight,
        age: petMap[PetDatabase.ageField],
        image: petMap[PetDatabase.imageField],
        owner: petMap[PetDatabase.ownerField]);
    addPetToDB(pet);
  }

  //Updates data on the pet, related to how long must distance they have covered.
  void updatePetWalkData(Pet pet, double distance) {
    //This assumes 'state.petList' is always the most current list of pets.
    List<Pet> updatedPets = List.from(state.petList);

    //Find the index of the pet to update.
    int indexToUpdate = updatedPets.indexWhere((currentPet) => pet == currentPet);
    if (indexToUpdate != -1) {
      //Fetch the pet to update.
      Pet petToUpdate = updatedPets[indexToUpdate];

      //Update the pet's information.
      Pet updatedPet = petToUpdate.copyWith(
          distance: petToUpdate.distance + distance,
          walks: petToUpdate.walks + 1);

      db.updateWalk(pet);

      //Update the list with the updated pet.
      updatedPets[indexToUpdate] = updatedPet;
    }

    //Emit a new state with the updated pet list.
    emit(state.copyWith(status: PetStatus.loaded, petList: updatedPets));
    //print(updatedPets[indexToUpdate].walks);
  }

  Future<void> getPetList() async {
    emit(state.copyWith(status:PetStatus.loading));
    List<Pet> pets = await db.get();
    emit(state.copyWith(status:PetStatus.loading, petList: pets));
  }

  // Adds pet to the firebase database.
  void addPetToDatabase(Pet pet) {
    db.put(pet);
  }

  //Adds pet to the local database.
  void addPetToDB(Pet pet) {
    List<Pet> pets = <Pet>[pet];
    pets.addAll(state.petList);
    emit(state.copyWith(status:PetStatus.loaded, petList: pets));
    getValidPets(pet.owner);
  }

  void emptyList() {
    emit(state.copyWith(selectedPets: <Pet>[]));
  }

  void getValidPets(String id) {
    List<Pet> pets = <Pet>[];
    pets.addAll(state.petList.where((element) => element.owner.compareTo(id) == 0));
    emit(state.copyWith(validPets: pets));
  }


  void getPet(int index) {
    emit(state.copyWith(index: index));
  }

  //remove the pet from the database. This will result in permanent deletion and cannot be recovered.
  void deletePet(Pet pet) async {

    db.delete(pet);

    List<Pet> pets = <Pet>[];
    pets.addAll(state.petList);

    pets.remove(pet);

    emit(state.copyWith(petList:pets));
    getValidPets(pet.owner);
  }

  void togglePetSelection(Pet selectedPet) {
    final currentState = state;
    List<Pet> newSelectedPets = List.from(currentState.selectedPets);

    if (newSelectedPets.contains(selectedPet)) {
      newSelectedPets.remove(selectedPet);
    } else {
      newSelectedPets.add(selectedPet);
    }

    emit(currentState.copyWith(selectedPets: newSelectedPets));
  }

}
