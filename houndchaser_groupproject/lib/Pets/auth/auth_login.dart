import 'package:flutter/cupertino.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Page for adding a pet to list of pets
///creates a pet object based off user input and adds it to the petList
///
/// @author Evan
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _AddLoginState createState() => _AddLoginState();
}

//Ui for add_pet
class _AddLoginState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //Flutter will automatically call this when the widget is disposed
  //to clear the resources used by the controllers to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSignedIn) {
            return CupertinoButton(
                child: const Text('To Homepage'),
                onPressed: () => {
                  Navigator.of(context).pushNamed(RouteGenerator.homePage)
                }
            );
          }
          return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Log In'),
            ),
            child: ListView(
              children: [
                CupertinoTextField(controller: _emailController, placeholder: 'Email'),
                CupertinoTextField(controller: _passwordController, obscureText: true, placeholder: 'Password'),
                CupertinoButton(
                    child: const Text('Log In'),
                    onPressed: () => {
                      context.read<AuthCubit>().signIn(_emailController.text, _passwordController.text),
                      if (state is AuthSignedIn) {
                        Navigator.of(context).pushNamed(RouteGenerator.homePage)
                      }// Go back to the previous screen
                    }
                ),
                CupertinoButton(
                    child: const Text('New? Register here!'),
                    onPressed: () => {
                      Navigator.of(context).pushNamed(RouteGenerator.registerPage)
                    }
                ),
              ],
            ),
          );
        }
    );
  }
}