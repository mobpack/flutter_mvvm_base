import 'package:flutter/foundation.dart';
import 'package:flutter_mvvm_base/features/auth/data/providers.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/auth_state.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:flutter_mvvm_base/shared/router/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier implements Listenable {
  VoidCallback? _routerListener;
  
  @override
  AuthState build() {
    ref.listen(authStateProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            state = AuthState.authenticated(UserEntity.fromSupabaseUser(user));
          } else {
            state = const AuthState.unauthenticated();
          }
          _routerListener?.call();
        },
        error: (_, __) {
          state = const AuthState.unauthenticated();
          _routerListener?.call();
        },
      );
    });
    
    return const AuthState.initial();
  }

  Future<void> checkAuthState() async {
    state = const AuthState.authenticating();
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.getCurrentUser().run();
    
    result.fold(
      (error) {
        state = const AuthState.unauthenticated();
        _routerListener?.call();
      },
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
        _routerListener?.call();
      },
    );
  }

  Future<void> signOut() async {
    state = const AuthState.authenticating();
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signOut().run();
    
    result.fold(
      (error) {
        // Even if there's an error, we should consider the user logged out
        state = const AuthState.unauthenticated();
        _routerListener?.call();
      },
      (_) {
        state = const AuthState.unauthenticated();
        _routerListener?.call();
      },
    );
  }

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }
}
