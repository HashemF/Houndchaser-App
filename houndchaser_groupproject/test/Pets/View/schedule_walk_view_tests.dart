import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Pets/db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Home/home_page.dart';
import 'package:houndchaser_groupproject/Pets/List/select_pets_view.dart';
import 'package:houndchaser_groupproject/Pets/auth/cubit/auth_cubit.dart';
import 'dart:async';
import 'package:houndchaser_groupproject/Pets/pet.dart';

///Tests for schedule walk page of app
///tests navigation to two screens
///Back to home page
///a select pets page
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

  testWidgets('Navigating to select_pets_view from schedule_walk_view', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: SelectPetsForWalkPage(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/schedulePage',
        ),
      ),
    );
    //Find the button that should navigate to the current walk page
    final buttonFinder = find.byKey(const ValueKey('selectPetsButton'));
    //Tap the button to navigate
    await tester.tap(buttonFinder);
    //Rebuild the widget after the state has changed.
    await tester.pumpAndSettle();
    //Check if the page is displayed
    expect(find.byType(SelectPetsForWalkPage), findsOneWidget);
  });

  testWidgets('Navigating to home_page page from schedule_walk_view page', (WidgetTester tester) async {
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
          initialRoute: '/schedulePage',
        ),
      ),
    );

    //Tap the button to navigate to the PetList page
    await tester.tap(find.byKey(const Key('doneButton')));
    await tester.pumpAndSettle(); //Wait for the navigation to complete

    //Check if addPet page is displayed
    expect(find.byType(HomePage), findsOneWidget);
  });
  testWidgets('displays the schedule_walk_view page properly', (WidgetTester tester) async {

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/schedulePage',
        ),
      ),
    );

    //Verify that all expected widgets are found.
    expect(find.text('Schedule a Walk'), findsOneWidget);
    expect(find.byKey(const Key('doneButton')), findsOneWidget);
    expect(find.byKey(const Key('timeSelectButton')), findsOneWidget);
    expect(find.byKey(const Key('selectPetsButton')), findsOneWidget);
  });
}