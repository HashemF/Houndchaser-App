import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:houndchaser_groupproject/Pets/db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Pets/auth/cubit/auth_cubit.dart';
import 'package:houndchaser_groupproject/Home/home_page.dart';
import 'package:houndchaser_groupproject/Pets/pet.dart';
import 'package:houndchaser_groupproject/Pets/List/select_pets_view.dart';
import 'dart:async';

///Tests for select_pets_view page of app
///provides testing for display of select_pets_view
///Tests if page is properly displayed when there are no pets
///tests if page properly displays when there is a pet
///tests if page properly displays in general
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
        const AuthSignedIn("user1")); // Assuming AuthSignedIn has an id
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
  testWidgets('Displays pet when selected pet list has a pet', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: SelectPetsForWalkPage(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/selectPetPage',
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("name"), findsOneWidget);
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
          initialRoute: '/selectPetPage',
        ),
      ),
    );

    //Check if addPet page shows no pets added yet
    expect(find.text("No pets added yet"), findsOneWidget);
  });
  testWidgets('displays the selected_pets_view page properly with a pet', (WidgetTester tester) async {

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/selectPetPage',
        ),
      ),
    );
    //method to check if check mark Icon is displayed
    final checkMarkIconFinder = find.byWidgetPredicate(
          (Widget widget) =>
      widget is Icon &&
          widget.icon == CupertinoIcons.check_mark_circled_solid,
    );

    //Verify that all expected widgets are found.
    expect(find.text('Select Pets for a Walk'), findsOneWidget);
    expect(checkMarkIconFinder, findsOneWidget);
  });
}