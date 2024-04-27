import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Pets/db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Home/home_page.dart';
import 'package:houndchaser_groupproject/Pets/List/add_pet.dart';
import 'package:houndchaser_groupproject/Pets/pet.dart';
import 'package:houndchaser_groupproject/Pets/View/pet_view.dart';
import 'package:houndchaser_groupproject/Pets/auth/cubit/auth_cubit.dart';
import 'dart:async';

///Tests for pet_list page of app
///provides testing for navigation to add_pet page
///Tests if page is properly displayed when there are no pets
///tests if page properly displays when there is a pet
///tests if page properly updates when pet delete button clicked (NOT WORKING)
///
/// @author Evan

class MockPetDBCubit extends Mock implements PetDBCubit {
  MockPetDBCubit() {
    when(close).thenAnswer((_) async {});
  }}
class MockAuthCubit extends Mock implements AuthCubit {
  final StreamController<AuthState> _controller = StreamController<
      AuthState>.broadcast();

  MockAuthCubit() {
    when(close).thenAnswer((_) async {
      _controller.close();
    });
    when(() => stream).thenAnswer((_) => _controller.stream);
    when(() => state).thenReturn(
        const AuthSignedIn("user1"));
  }

  @override
  void emit(AuthState state) {
    _controller.add(state);
  }
}

void main() {
  late MockPetDBCubit mockPetDBCubit;
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockPetDBCubit = MockPetDBCubit();
    mockAuthCubit = MockAuthCubit();

    //Setup the mocks
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthSignedIn("user1")));
    when(() => mockAuthCubit.state).thenReturn(const AuthSignedIn("user1"));

    List<Pet> testPetList = [Pet(key: 'key', name: "name", age: 1, breed: "Dog", image: "None", weight: 2)];
    when(() => mockPetDBCubit.stream).thenAnswer((_) => Stream.value(PetDBState(validPets: testPetList, selectedPets: testPetList)));
    when(() => mockPetDBCubit.state).thenReturn(PetDBState(validPets: testPetList, selectedPets: testPetList));
  });

  testWidgets('Navigating to add_pet page from pet_list page', (WidgetTester tester) async {
    //Setup the mock to return an empty list state when listened
    when(() => mockPetDBCubit.stream).thenAnswer(
          (_) => Stream.fromIterable([const PetDBState(petList: [])]),
    );
    when(() => mockPetDBCubit.state).thenReturn(const PetDBState(petList: []));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/petListPage',
        ),
      ),
    );

    //Tap the button to navigate to the add_pet page
    await tester.tap(find.byKey(const Key('addPetButton')));
    await tester.pumpAndSettle(); //Wait for the navigation to complete

    //Check if addPet page is displayed
    expect(find.byType(AddPetPage), findsOneWidget);
  });
  testWidgets('Displays "No pets added yet" when pet list is empty', (WidgetTester tester) async {
    //Setup the mock to return an empty list state when listened
    when(() => mockPetDBCubit.stream).thenAnswer(
          (_) => Stream.fromIterable([const PetDBState(petList: [])]),
    );
    when(() => mockPetDBCubit.state).thenReturn(const PetDBState(petList: []));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/petListPage',
        ),
      ),
    );

    //Check if addPet page shows no pets added yet
    expect(find.text("No pets added yet"), findsOneWidget);
  });
  testWidgets('Displays pet when pet list has a pet', (WidgetTester tester) async {

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/petListPage',
        ),
      ),
    );

    await tester.pumpAndSettle();
    //Check if pet name is listed
    expect(find.text("name"), findsOneWidget);
  });
  //TODO fix this test (delete pet button)
  testWidgets('Pet is removed from list after deletion', (WidgetTester tester) async {
    //Setup the mock
    Pet testPet = Pet(key: 'key', name: "name", age: 1, breed: "Dog", image: "None", weight: 2);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/petListPage',
        ),
      ),
    );

    await tester.pumpAndSettle();
    //Confirm the pet is initially displayed (Working)
    expect(find.text('name'), findsOneWidget);

    //Trigger the deletion
    when(() => mockPetDBCubit.deletePet(testPet)).thenAnswer((_) async {
      //Update the state to simulate pet being deleted
      when(() => mockPetDBCubit.state).thenReturn(const PetDBState(petList: []));
      when(() => mockPetDBCubit.stream).thenAnswer(
              (_) => Stream.fromIterable([const PetDBState(petList: [])])
      );
    });
    await tester.pump();
    //Find the button that deletes a pet
    final buttonFinder = find.byKey(const ValueKey('deletePetButton'));
    //Tap the button
    await tester.tap(buttonFinder);
    //Rebuild the widget after the state has changed.
    await tester.pumpAndSettle();

    //Check that the pet is no longer displayed (not working)
    expect(find.text('name'), findsNothing);
  });
  testWidgets('properly navigates to pet_view.dart when a pet is clicked', (WidgetTester tester) async {

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/petListPage',
        ),
      ),
    );
    //Check if pet name is listed
    expect(find.text("name"), findsOneWidget);
    await tester.tap(find.text('name'));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();
    //check if navigation successfully completed
    expect(find.byType(PetView), findsOneWidget);
  });
  testWidgets('displays the pet_list page properly', (WidgetTester tester) async {

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/petListPage',
        ),
      ),
    );

    //Verify that all expected widgets are found.
    expect(find.text('My Pets'), findsOneWidget);
    expect(find.text('Add Pet'), findsOneWidget);
    expect(find.byKey(const Key('addPetButton')), findsOneWidget);
  });
}