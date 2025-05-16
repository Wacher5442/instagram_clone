import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) {
    emit(AuthLoading());

    final username = event.username;
    final password = event.password;

    if (username == 'muser3' && password == AppConstants.mockUsers['muser3']) {
      emit(AuthFailure('Ce compte a été bloqué.'));
    } else if (AppConstants.mockUsers.containsKey(username) &&
        AppConstants.mockUsers[username] == password) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailure('Informations de connexion invalides.'));
    }
  }
}
