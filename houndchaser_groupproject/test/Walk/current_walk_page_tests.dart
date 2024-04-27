import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:houndchaser_groupproject/Pets/db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Walk/current_walk_page.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:houndchaser_groupproject/Home/home_page.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:houndchaser_groupproject/Pets/auth/cubit/auth_cubit.dart';
import 'package:houndchaser_groupproject/Pets/pet.dart';
import 'package:flutter/material.dart';

///Tests for current_walk_page of app
///tests that start and stop button work properly
///tests the page is displayed properly
///
/// @author Evan

class MockGoogleMapController extends Mock implements GoogleMapController {}
class MockLocation extends Mock implements Location {}
class MockLocationData extends Mock implements LocationData {}
class MockPetDBCubit extends Mock implements PetDBCubit {
  MockPetDBCubit() {
    when(close).thenAnswer((_) async {});
  }}
class MockPetDBState extends Mock implements PetDBState {}
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
  late MockGoogleMapController mockGoogleMapController;
  late MockLocation mockLocation;
  late MockPetDBCubit mockPetDBCubit;
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockGoogleMapController = MockGoogleMapController();
    mockLocation = MockLocation();
    mockPetDBCubit = MockPetDBCubit();

    mockAuthCubit = MockAuthCubit();

    //Setup the mocks
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthSignedIn("user1")));
    when(() => mockAuthCubit.state).thenReturn(const AuthSignedIn("user1"));
    // Setup location mock
    when(() => mockLocation.getLocation()).thenAnswer(
          (_) async => MockLocationData(),
    );

    // Setup stream subscription mock
    when(() => mockLocation.onLocationChanged).thenAnswer(
          (_) => Stream<LocationData>.empty(),
    );

    List<Pet> testPetList = [Pet(key: 'key', name: "name", age: 1, breed: "Dog", image: "None", weight: 2)];
    when(() => mockPetDBCubit.stream).thenAnswer((_) => Stream.value(PetDBState(validPets: testPetList, selectedPets: testPetList)));
    when(() => mockPetDBCubit.state).thenReturn(PetDBState(validPets: testPetList, selectedPets: testPetList));
  });

  testWidgets('Start and Stop Walk Buttons work correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        home: MultiBlocProvider(
          providers: [
            BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
            BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
          ],
          child: CurrentWalkPage(),
        ),
      ),
    );

    // Verify the initial state of the button
    expect(find.text('Start Walk'), findsOneWidget);

    // Tap 'Start Walk' and trigger a frame
    await tester.tap(find.text('Start Walk'));
    await tester.pumpAndSettle();

    // Verify the state changes to 'Stop Walk'
    expect(find.text('Stop Walk'), findsOneWidget);

    // Tap 'Stop Walk' and trigger a frame
    await tester.tap(find.text('Stop Walk'));
    await tester.pumpAndSettle();

    // Verify the summary dialog is shown
    expect(find.text('Walk Summary'), findsOneWidget);
  });
  testWidgets('Displays page correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        home: MultiBlocProvider(
          providers: [
            BlocProvider<PetDBCubit>(create: (context) => mockPetDBCubit),
            BlocProvider<AuthCubit>(create: (context) => mockAuthCubit),
          ],
          child: CurrentWalkPage(),
        ),
      ),
    );

    // Verify the initial state of the button
    expect(find.text('Hound Chaser'), findsOneWidget);
    expect(find.text('Start Walk'), findsOneWidget);
  });
}
