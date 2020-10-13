import 'package:instantsewa/application/classes/errors/common_error.dart';
import 'package:instantsewa/state/auth_state.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class LogInFormModel {
  final AuthState _authState = Injector.get<AuthState>();
  String email;
  String password;

  void setEmail(String email) {
    if (!validateEmail(email)) {
        throw CommonError(message: "Invalide Email");
    }
    this.email = email;
  }

  void setPassword(String password) {
    if (password.length < 6) {
      throw CommonError(message: "Password length should more than 6 chars");
    }
    this.password = password;
  }

  bool validateData() {
    return this.email != null &&
        this.password != null &&
        this.password.length > 6 &&
        this.validateEmail(this.email);
  }

  bool validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
   Future<void>submitSignIn() async
  {
   await _authState.signIn(email: this.email, password: this.password);
  }
}