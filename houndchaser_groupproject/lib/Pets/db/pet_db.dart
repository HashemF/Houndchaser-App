import 'dart:async';
//import 'dart:js_interop_unsafe';

import 'package:firebase_database/firebase_database.dart';
import '../pet.dart';

///pet_db
///Dart class representing a Database of Pet objects
///
/// @author Tristan

class PetDatabase {
  late final DatabaseReference ref;

  static const String _pets = "pets";

  static const String keyField = "key";
  static const String nameField = "name";
  static const String breedField = "breed";
  static const String weightField = "weight";
  static const String ageField = "age";
  static const String imageField = "image";
  static const String ownerField = "owner";
  static const String walkField = "walk";
  static const String distanceField = "distance";

  PetDatabase({ref}) : ref=ref??FirebaseDatabase.instance.ref(_pets);

  void put (Pet pet) {
    DatabaseReference leadersList = ref.push();

    print(leadersList.key!);
    pet.key = leadersList.key!;

    leadersList.set({
      keyField: leadersList.key,
      nameField : pet.name,
      breedField : pet.breed,
      weightField : pet.weight,
      ageField : pet.age,
      imageField : pet.image,
      ownerField : pet.owner,
      walkField : pet.walks,
      distanceField : pet.distance
    });
  }

  Future<List<Pet>> get() async {
    final pets = <Pet>[];

    final petList = await ref.get();

    if (petList.exists) {
      for (final pet in petList.children) {
        final petMap = pet.value as Map<dynamic, dynamic>;
        pets.add(Pet(
            key: petMap[keyField],
            name: petMap[nameField],
            breed: petMap[breedField],
            weight: petMap[weightField],
            age: petMap[ageField],
            image: petMap[imageField],
            owner: petMap[ownerField],
            walks: petMap[walkField],
            distance: petMap[distanceField]
        ));
      }
    }
    return pets;
  }

  void delete(Pet pet) async {
    DataSnapshot snapshot = await ref.orderByChild(keyField).equalTo(pet.key).get();

    for (DataSnapshot dsnap in snapshot.children) {
      dsnap.ref.remove();
    }
  }

  StreamSubscription subscribe(Function(DatabaseEvent event) fn) {
    return ref.onChildAdded.listen(fn);
  }

  void updateWalk(Pet pet) async {
    DataSnapshot snapshot = await ref.orderByChild(keyField).equalTo(pet.key).get();

    for (DataSnapshot dsnap in snapshot.children) {
      dsnap.ref.update({
        walkField: pet.walks,
        distanceField: pet.distance
      });
    }
  }
}