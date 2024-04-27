import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:houndchaser_groupproject/Pets/View/schedule_walk_view.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:houndchaser_groupproject/Pets/List/pet_list.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Pets/db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Home/home_page.dart';
import 'package:houndchaser_groupproject/Walk/current_walk_page.dart';
import 'package:houndchaser_groupproject/Pets/auth/cubit/auth_cubit.dart';
import 'dart:async';
import 'package:houndchaser_groupproject/Pets/pet.dart';

///Tests for home page of app
///tests page is properly displayed
///provides testing for navigation to three screens
///Manage/view pets screen
///a schedule walk screen
///The "walking" screen
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

  testWidgets('Navigating to schedule_walk_view from home_page', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
    //Find the button that should navigate to the schedule walk page
    final buttonFinder = find.byKey(const ValueKey('scheduleWalkButton'));
    //Tap the button to navigate
    await tester.tap(buttonFinder);
    //Rebuild the widget after the state has changed.
    await tester.pumpAndSettle();
    //Check if the page is displayed
    expect(find.byType(ScheduleWalk), findsOneWidget);
  });
  testWidgets('Navigating to pet_list page from home_page', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );

    //Tap the button to navigate to the PetList page
    await tester.tap(find.byKey(const Key('managePetsButton')));
    await tester.pumpAndSettle(); //Wait for the navigation to complete

    //Check if PetList page is displayed
    expect(find.byType(PetList), findsOneWidget);
  });
  testWidgets('Navigating to the current_walk_page from home_page', (WidgetTester tester) async{
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
    //Find the button that should navigate to the current walk page
    final buttonFinder = find.byKey(const ValueKey('walkButton'));
    //Tap the button to navigate
    await tester.tap(buttonFinder);
    //Rebuild the widget after the state has changed.
    await tester.pumpAndSettle();
    //Check if the page is displayed
    expect(find.byType(CurrentWalkPage), findsOneWidget);
  });
  testWidgets('displays home_page properly', (WidgetTester tester) async {

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
          BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
        ],
        child: const CupertinoApp(
          home: HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );

    //Verify that all expected widgets are found.
    expect(find.text('Hound Chaser'), findsOneWidget);
    expect(find.byKey(const Key('walkButton')), findsOneWidget);
    expect(find.byKey(const Key('managePetsButton')), findsOneWidget);
    expect(find.byKey(const Key('scheduleWalkButton')), findsOneWidget);
  });
}