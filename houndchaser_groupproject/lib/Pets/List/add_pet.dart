import 'package:flutter/cupertino.dart';
import 'package:houndchaser_groupproject/Widgets/LoginButton.dart';
import '../../Routes/route_generator.dart';
import '../auth/cubit/auth_cubit.dart';
import '../db/cubit/pet_db_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pet.dart';

///Page for adding a pet to list of pets
///creates a pet object based off user input and adds it to the petList
///
/// @author Evan and Tristan

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  _AddPetPageState createState() => _AddPetPageState();
}

//Gets pet object info from user
class _AddPetPageState extends State<AddPetPage> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _imageController = TextEditingController();

  //Flutter will automatically call this when the widget is disposed
  //to clear the resources used by the controllers to prevent memory leaks
  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _imageController.dispose();
    super.dispose();
  }
  //Adds the pet to the DB
  void _addPet(String id) {
    final pet = Pet(
      //required a key for updating pet statistics
      //Unlikely someone has two pets with the same name so should be fine to use name
      name: _nameController.text,
      breed: _breedController.text,
      weight: double.tryParse(_weightController.text) ?? 0,
      age: int.tryParse(_ageController.text) ?? 0,
      image: _imageController.text,
      owner: id
    );
    context.read<PetDBCubit>().addPetToDatabase(pet);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Add your Pet'),
        trailing: LoginButton(),
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSignedIn) {
              return ListView(
                  children: [
                    CupertinoTextField(controller: _nameController, placeholder: 'Name'),
                    CupertinoTextField(controller: _breedController, placeholder: 'Breed'),
                    CupertinoTextField(controller: _weightController, placeholder: 'Weight (lb)', keyboardType: TextInputType.number),
                    CupertinoTextField(controller: _ageController, placeholder: 'Age (months)', keyboardType: TextInputType.number),
                    //TODO: Replace with a widget to send an image into the app if possible (otherwise might drop images entirely [Flutter image_picker?])
                    CupertinoTextField(controller: _imageController, placeholder: 'Image URL'),
                    CupertinoButton(
                        key: const Key('addPetButton2'),
                        child: const Text('Add Pet'),
                        onPressed: () => {
                          _addPet(state.id),
                          Navigator.of(context).pop() // Go back to the previous screen
                        }
                    ),
                  ],
                );
            }
            else {
              return CupertinoButton(
                  child: const Text('Please log in'),
                  onPressed: () => {
                    Navigator.of(context).pushNamed(RouteGenerator.loginPage) // Go back to the previous screen
                  }
              );
            }
          }
      )
    );

  }
}