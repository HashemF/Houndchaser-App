import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Pets/auth/cubit/auth_cubit.dart';
import '../Pets/db/cubit/pet_db_cubit.dart';
import '../Routes/route_generator.dart';

class LoginButton extends StatelessWidget {

  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSignedOut) {
            return CupertinoButton(
                child: const Text("Sign In"),
                onPressed: () => Navigator.of(context).pushNamed(RouteGenerator.loginPage)
            );
          }
          else {
            return CupertinoButton(
                child: const Text("Sign Out"),
                onPressed: () => {
                  context.read<PetDBCubit>().emptyList(),
                  context.read<AuthCubit>().signOut(),
                  Navigator.of(context).pushNamed(RouteGenerator.loginPage)
                }
            );
          }
        }
    );
  }

}