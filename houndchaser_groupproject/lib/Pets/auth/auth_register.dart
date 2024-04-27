import 'package:flutter/cupertino.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Page for adding a pet to list of pets
///creates a pet object based off user input and adds it to the petList
///
/// @author Evan
class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _AddRegisterState createState() => _AddRegisterState();
}

//Ui for add_pet
class _AddRegisterState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  //Flutter will automatically call this when the widget is disposed
  //to clear the resources used by the controllers to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSignedIn) {
            return CupertinoButton(
                child: const Text('New? Register here!'),
                onPressed: () => {
                  Navigator.of(context).pushNamed(RouteGenerator.homePage)
                }
            );
          }
          else {
            return CupertinoPageScaffold(
              navigationBar: const CupertinoNavigationBar(
                middle: Text('Register New Account'),
              ),
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("A valid email and six or more characters in your password are required to create an account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  CupertinoTextField(
                      controller: _emailController, placeholder: 'Email'),
                  CupertinoTextField(
                      controller: _passwordController, obscureText: true, placeholder: 'Password'),
                  CupertinoTextField(
                      controller: _nameController, placeholder: 'Name'),
                  CupertinoButton(
                      child: const Text('Register'),
                      onPressed: () =>
                      {
                        context.read<AuthCubit>().createAccount(
                            _emailController.text, _passwordController.text,
                            _nameController.text),
                        //Check if account was successfully created and if so:
                        if (state is AuthSignedIn) {
                          Navigator.of(context).pushNamed(RouteGenerator.homePage)
                        } // Go back to the previous screen
                      }
                  ),
                  CupertinoButton(
                      child: const Text('Have an account? Log in here!'),
                      onPressed: () =>
                      {
                        Navigator.of(context).pop()
                      }
                  ),
                ],
              ),
            );
          }
        }
    );
  }

}