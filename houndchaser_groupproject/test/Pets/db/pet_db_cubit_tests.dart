import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:houndchaser_groupproject/Pets/db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Pets/db/pet_db.dart';
import 'package:houndchaser_groupproject/Pets/pet.dart';
import 'dart:async';

///Tests for pet database cubit
///Wanted to test list initilization and deletion
///Currently not working, had to move onto other things as it was taking too long
///
/// @author Evan

//TODO fix subscribe override method

//mock DatabaseEvent for testing
class DatabaseEvent {
  final dynamic snapshot;

  DatabaseEvent({this.snapshot});
}

class MockPetDatabase extends Mock implements PetDatabase {
 /* @override
  StreamSubscription subscribe(Function(DatabaseEvent event) onData) {
    var controller = StreamController<DatabaseEvent>.broadcast();
    // Trigger onData immediately with a dummy event if needed
    Future.microtask(() => onData(DatabaseEvent(snapshot: {})));
    return controller.stream.listen(onData);
  }*/
}

@override
Future<List<Pet>> get() async {
  return <Pet>[];
}

void main() {
  group('PetDBCubit', () {
    late MockPetDatabase mockDatabase;
    late PetDBCubit cubit;

    setUp(() {
      mockDatabase = MockPetDatabase();
      cubit = PetDBCubit(mockDatabase);
    });

    test('Initialization', () {
      expect(cubit.state.petList, isEmpty);
    });
  });
}
