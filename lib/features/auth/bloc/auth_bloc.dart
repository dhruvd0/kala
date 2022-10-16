import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/features/auth/bloc/auth_state.dart';
import 'package:kala/features/auth/repositories/social_integration/social_integration.dart';

class AuthBloc extends Cubit<AuthState> {
  AuthBloc(this._socialSignIn) : super(AuthInitial()) {
    firebaseConfig.auth.authStateChanges().listen((event) {
      if (event != null) {
        emit(AuthenticatedState(event));
      } else {
        emit(AuthInitial());
      }
    });
  }

  final SocialSignIn _socialSignIn;

  Future<void> authenticateWithSocialAuth(AuthTypes authType) async {
    emit(AuthLoadingState());
    final either = await _socialSignIn.signInWithGoogle();

    await either.fold(
      (l) async => AuthErrorState(l.message!),
      (user) async {
        emit(AuthenticatedState(user));
      },
    );
  }
}
