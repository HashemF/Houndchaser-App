import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Pets/db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Pets/List/pet_list.dart';
import 'package:houndchaser_groupproject/Pets/List/select_pets_view.dart';
import 'package:houndchaser_groupproject/Pets/auth/cubit/auth_cubit.dart';
import 'dart:async';
import 'package:houndchaser_groupproject/Pets/pet.dart';


///Tests for pet_view page of app
///tests page is properly displayed (NOT WORKING)
///
/// @author Evan

class MockPetDBCubit extends Mock implements PetDBCubit {
  MockPetDBCubit() {
    when(close).thenAnswer((_) async {});
    when(() => getPet(any())).thenAnswer((invocation) async {
      int index = invocation.positionalArguments.first as int;
      // Assuming you have a method to simulate fetching a pet by index
      Pet selectedPet = state.petList[index];
      // Simulate the state change that would happen in a real scenario
      emit(state.copyWith(petList: [selectedPet]));
    });
  }
}
class MockAuthCubit extends Mock implements AuthCubit {
  final StreamController<AuthState> _controller = StreamController<
      AuthState>.broadcast();

  MockAuthCubit() {
    when(close).thenAnswer((_) async {
      _controller.close();
    });
    when(() => stream).thenAnswer((_) => _controller.stream);
    when(() => state).thenReturn(
        const AuthSignedIn("user1")); // Assuming AuthSignedIn has an id
  }

  @override
  void emit(AuthState state) {
    _controller.add(state);
  }
}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockPetDBCubit mockPetDBCubit;
  late MockAuthCubit mockAuthCubit;
  late NavigatorObserver mockObserver;

  setUp(() {
    mockPetDBCubit = MockPetDBCubit();
    mockAuthCubit = MockAuthCubit();
    mockObserver = MockNavigatorObserver();

    //Setup the mocks
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthSignedIn("user1")));
    when(() => mockAuthCubit.state).thenReturn(const AuthSignedIn("user1"));

    when(() => mockPetDBCubit.getPet(any())).thenAnswer((invocation) {
      int index = invocation.positionalArguments.first as int;
      var newState = mockPetDBCubit.state.copyWith(index: index);
      when(() => mockPetDBCubit.state).thenReturn(newState);
    });

    List<Pet> testPetList = [Pet(key: 'key', name: "name", age: 1, breed: "Dog", image: "None", weight: 2)];
    when(() => mockPetDBCubit.stream).thenAnswer((_) => Stream.value(PetDBState(validPets: testPetList, selectedPets: testPetList)));
    when(() => mockPetDBCubit.state).thenReturn(PetDBState(validPets: testPetList, selectedPets: testPetList, petList: testPetList));
  });

  //TODO fix this test, initial tap seems to work but page it goes to is not correct
  testWidgets('pet_view page is properly displayed', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: CupertinoApp(
          home: const PetList(),
          onGenerateRoute: RouteGenerator.generateRoute,
          navigatorObservers: [mockObserver],
        ),
      ),
    );

    // Simulate tapping the button to navigate
    expect(find.text("name"), findsOneWidget);
    await tester.tap(find.text("name"));
    await tester.pumpAndSettle();
    //Check if the page is displayed
    expect(find.text("name"), findsOneWidget);
    expect(find.text('Breed, Dog'), findsOneWidget);
    expect(find.text('Age 0 years 1 months'), findsOneWidget);
    expect(find.text('Weight 2.000 lb'), findsOneWidget);
    expect(find.text('Distance Walked 0.0000 km'), findsOneWidget);
    expect(find.text('Number of Walks 0'), findsOneWidget);
  });

}