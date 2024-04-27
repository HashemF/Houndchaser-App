part of 'pet_db_cubit.dart';

/// PetView
/// Edited by Hashem
/// @author Tristan
/// @description Bloc state class for the Pet database
///

enum PetStatus {loading, loaded, failure}

class PetDBState extends Equatable{
  final int index; //Pet position in relation to the other pets inputted
  final List<Pet> petList;
  final List<Pet> selectedPets;
  final List<Pet> validPets;
  final PetStatus status;

  const PetDBState({
    this.index = 0,
    this.status = PetStatus.loading,
    this.selectedPets = const<Pet>[],
    this.validPets = const<Pet>[],
    this.petList = const<Pet>[]
  });
  //Copies the current state of the pet database, including its status and pets.
  PetDBState copyWith( {
    PetStatus? status,
    List<Pet>? petList,
    List<Pet>? validPets,
    List<Pet>? selectedPets,
    int? index,
  })
  {
    return PetDBState(
      petList : petList ?? this.petList,
      status: status ?? this.status,
      selectedPets: selectedPets ?? this.selectedPets,
      validPets: validPets ?? this.validPets,
      index: index ?? this.index
    );
  }
  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [status, petList, validPets, selectedPets, index];
}
