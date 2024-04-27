part of 'auth_cubit.dart';



abstract class AuthState extends Equatable {
  final String id;

  const AuthState(this.id);
}

class AuthSignedOut extends AuthState {
  const AuthSignedOut(super.id);

  @override
  //added id
  List<Object> get props => [id];
}

class AuthSignedIn extends AuthState {
  const AuthSignedIn(super.id);

  @override
  List<Object> get props => [id];

}