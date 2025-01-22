// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginViewModelHash() => r'7bfa485a4952995639dff81a49b5a79b1ead8baa';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$LoginViewModel
    extends BuildlessAutoDisposeNotifier<LoginState> {
  late final LoginUseCase? loginUseCase;

  LoginState build({
    LoginUseCase? loginUseCase,
  });
}

/// See also [LoginViewModel].
@ProviderFor(LoginViewModel)
const loginViewModelProvider = LoginViewModelFamily();

/// See also [LoginViewModel].
class LoginViewModelFamily extends Family<LoginState> {
  /// See also [LoginViewModel].
  const LoginViewModelFamily();

  /// See also [LoginViewModel].
  LoginViewModelProvider call({
    LoginUseCase? loginUseCase,
  }) {
    return LoginViewModelProvider(
      loginUseCase: loginUseCase,
    );
  }

  @override
  LoginViewModelProvider getProviderOverride(
    covariant LoginViewModelProvider provider,
  ) {
    return call(
      loginUseCase: provider.loginUseCase,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'loginViewModelProvider';
}

/// See also [LoginViewModel].
class LoginViewModelProvider
    extends AutoDisposeNotifierProviderImpl<LoginViewModel, LoginState> {
  /// See also [LoginViewModel].
  LoginViewModelProvider({
    LoginUseCase? loginUseCase,
  }) : this._internal(
          () => LoginViewModel()..loginUseCase = loginUseCase,
          from: loginViewModelProvider,
          name: r'loginViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loginViewModelHash,
          dependencies: LoginViewModelFamily._dependencies,
          allTransitiveDependencies:
              LoginViewModelFamily._allTransitiveDependencies,
          loginUseCase: loginUseCase,
        );

  LoginViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.loginUseCase,
  }) : super.internal();

  final LoginUseCase? loginUseCase;

  @override
  LoginState runNotifierBuild(
    covariant LoginViewModel notifier,
  ) {
    return notifier.build(
      loginUseCase: loginUseCase,
    );
  }

  @override
  Override overrideWith(LoginViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: LoginViewModelProvider._internal(
        () => create()..loginUseCase = loginUseCase,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        loginUseCase: loginUseCase,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LoginViewModel, LoginState>
      createElement() {
    return _LoginViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoginViewModelProvider &&
        other.loginUseCase == loginUseCase;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, loginUseCase.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LoginViewModelRef on AutoDisposeNotifierProviderRef<LoginState> {
  /// The parameter `loginUseCase` of this provider.
  LoginUseCase? get loginUseCase;
}

class _LoginViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<LoginViewModel, LoginState>
    with LoginViewModelRef {
  _LoginViewModelProviderElement(super.provider);

  @override
  LoginUseCase? get loginUseCase =>
      (origin as LoginViewModelProvider).loginUseCase;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
