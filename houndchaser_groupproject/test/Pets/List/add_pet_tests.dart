import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Pets/db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Pets/List/pet_list.dart';
import 'package:houndchaser_groupproject/Pets/pet.dart';
import 'package:houndchaser_groupproject/Pets/auth/cubit/auth_cubit.dart';
import 'dart:async';

///Tests for add_pet page of app
///provides testing for navigation back to pet_list page
///Tests if page is properly displayed
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
        AuthSignedIn("user1")); // Assuming AuthSignedIn has an id
  }

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

    // Setup the mocks
    when(() => mockAuthCubit.stream).thenAnswer((_) =>
        Stream.value(AuthSignedIn("user1")));
    when(() => mockAuthCubit.state).thenReturn(AuthSignedIn("user1"));

    List<Pet> testPetList = [
      Pet(key: 'key',
          name: "name",
          age: 1,
          breed: "Dog",
          image: "None",
          weight: 2)
    ];
    when(() => mockPetDBCubit.stream).thenAnswer((_) =>
        Stream.value(
            PetDBState(validPets: testPetList, selectedPets: testPetList)));
    when(() => mockPetDBCubit.state).thenReturn(
        PetDBState(validPets: testPetList, selectedPets: testPetList));
  });
  testWidgets('Navigating to pet_list page from add_pet page', (WidgetTester tester) async {
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
          home: PetList(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/petAddPage',
        ),
      ),
    );

    //Tap the button to navigate to the PetList page
    await tester.tap(find.byKey(const Key('addPetButton2')));
    await tester.pumpAndSettle(); //Wait for the navigation to complete

    //Check if addPet page is displayed
    expect(find.byType(PetList), findsOneWidget);
  });
  testWidgets('displays the add_pet page properly', (WidgetTester tester) async {

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: PetList(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/petAddPage',
        ),
      ),
    );

    //Verify that all expected widgets are found.
    expect(find.text('Add your Pet'), findsOneWidget);
    expect(find.byType(CupertinoTextField), findsNWidgets(5));
    expect(find.byKey(const Key('addPetButton2')), findsOneWidget);

  });
}