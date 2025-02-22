import 'package:bloc/bloc.dart';
import 'package:jitd_client/src/blocs/authentication/authen_event.dart';
import 'package:jitd_client/src/blocs/authentication/authen_state.dart';
import 'package:jitd_client/src/data/respository/auth_provider.dart';

import '../../data/models/auth_model.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(InitialState()) {
    /// inject Repository
    AuthRepository authRepository = new AuthRepository();

    /// SignIn event
    on<SignUpEvent>((event, emit) async {
      // convert data to model
      var authModel = AuthModel.fromJson(event.dataSignUp);

      emit(SignUpCheckingState());

      // Password confirm incorrect
      if (authModel.passworld.toString().trim() !=
          authModel.passworldConfirm.toString().trim()) {
        String err = "Password confirm incorrect";
        String desc = "กดเพื่อลองใหม่อีกครั้ง";
        emit(SignUpError(err, desc));
      } else {
        String? temp;

        temp = await authRepository.signIn(authModel.email.toString().trim(),
            authModel.passworld.toString().trim());

        if (temp == "The email address is already in use by another account.") {
          String err = "Email already existing";
          String desc = "กดเพื่อลองใหม่อีกครั้ง";
          emit(SignUpError(err, desc));
        } else {
          emit(SignUpLoadedState());
        }
      }
    });
  }
}
