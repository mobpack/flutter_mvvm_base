// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppError {
  bool get isRecoverable;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppErrorCopyWith<AppError> get copyWith =>
      _$AppErrorCopyWithImpl<AppError>(this as AppError, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppError &&
            (identical(other.isRecoverable, isRecoverable) ||
                other.isRecoverable == isRecoverable));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRecoverable);

  @override
  String toString() {
    return 'AppError(isRecoverable: $isRecoverable)';
  }
}

/// @nodoc
abstract mixin class $AppErrorCopyWith<$Res> {
  factory $AppErrorCopyWith(AppError value, $Res Function(AppError) _then) =
      _$AppErrorCopyWithImpl;
  @useResult
  $Res call({bool isRecoverable});
}

/// @nodoc
class _$AppErrorCopyWithImpl<$Res> implements $AppErrorCopyWith<$Res> {
  _$AppErrorCopyWithImpl(this._self, this._then);

  final AppError _self;
  final $Res Function(AppError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRecoverable = null,
  }) {
    return _then(_self.copyWith(
      isRecoverable: null == isRecoverable
          ? _self.isRecoverable
          : isRecoverable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class NetworkError implements AppError {
  const NetworkError(
      {required this.message, this.isRecoverable = true, this.originalError});

  final String message;
  @override
  @JsonKey()
  final bool isRecoverable;
  final Object? originalError;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NetworkErrorCopyWith<NetworkError> get copyWith =>
      _$NetworkErrorCopyWithImpl<NetworkError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NetworkError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isRecoverable, isRecoverable) ||
                other.isRecoverable == isRecoverable) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, isRecoverable,
      const DeepCollectionEquality().hash(originalError));

  @override
  String toString() {
    return 'AppError.network(message: $message, isRecoverable: $isRecoverable, originalError: $originalError)';
  }
}

/// @nodoc
abstract mixin class $NetworkErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $NetworkErrorCopyWith(
          NetworkError value, $Res Function(NetworkError) _then) =
      _$NetworkErrorCopyWithImpl;
  @override
  @useResult
  $Res call({String message, bool isRecoverable, Object? originalError});
}

/// @nodoc
class _$NetworkErrorCopyWithImpl<$Res> implements $NetworkErrorCopyWith<$Res> {
  _$NetworkErrorCopyWithImpl(this._self, this._then);

  final NetworkError _self;
  final $Res Function(NetworkError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? isRecoverable = null,
    Object? originalError = freezed,
  }) {
    return _then(NetworkError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isRecoverable: null == isRecoverable
          ? _self.isRecoverable
          : isRecoverable // ignore: cast_nullable_to_non_nullable
              as bool,
      originalError:
          freezed == originalError ? _self.originalError : originalError,
    ));
  }
}

/// @nodoc

class AuthError implements AppError {
  const AuthError(
      {required this.message,
      this.code,
      this.isRecoverable = true,
      this.originalError});

  final String message;
  final String? code;
  @override
  @JsonKey()
  final bool isRecoverable;
  final Object? originalError;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthErrorCopyWith<AuthError> get copyWith =>
      _$AuthErrorCopyWithImpl<AuthError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.isRecoverable, isRecoverable) ||
                other.isRecoverable == isRecoverable) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code, isRecoverable,
      const DeepCollectionEquality().hash(originalError));

  @override
  String toString() {
    return 'AppError.auth(message: $message, code: $code, isRecoverable: $isRecoverable, originalError: $originalError)';
  }
}

/// @nodoc
abstract mixin class $AuthErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $AuthErrorCopyWith(AuthError value, $Res Function(AuthError) _then) =
      _$AuthErrorCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String message,
      String? code,
      bool isRecoverable,
      Object? originalError});
}

/// @nodoc
class _$AuthErrorCopyWithImpl<$Res> implements $AuthErrorCopyWith<$Res> {
  _$AuthErrorCopyWithImpl(this._self, this._then);

  final AuthError _self;
  final $Res Function(AuthError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? code = freezed,
    Object? isRecoverable = null,
    Object? originalError = freezed,
  }) {
    return _then(AuthError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecoverable: null == isRecoverable
          ? _self.isRecoverable
          : isRecoverable // ignore: cast_nullable_to_non_nullable
              as bool,
      originalError:
          freezed == originalError ? _self.originalError : originalError,
    ));
  }
}

/// @nodoc

class ValidationError implements AppError {
  const ValidationError(
      {required final Map<String, List<String>> errors,
      this.isRecoverable = false})
      : _errors = errors;

  final Map<String, List<String>> _errors;
  Map<String, List<String>> get errors {
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_errors);
  }

  @override
  @JsonKey()
  final bool isRecoverable;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ValidationErrorCopyWith<ValidationError> get copyWith =>
      _$ValidationErrorCopyWithImpl<ValidationError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ValidationError &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.isRecoverable, isRecoverable) ||
                other.isRecoverable == isRecoverable));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_errors), isRecoverable);

  @override
  String toString() {
    return 'AppError.validation(errors: $errors, isRecoverable: $isRecoverable)';
  }
}

/// @nodoc
abstract mixin class $ValidationErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $ValidationErrorCopyWith(
          ValidationError value, $Res Function(ValidationError) _then) =
      _$ValidationErrorCopyWithImpl;
  @override
  @useResult
  $Res call({Map<String, List<String>> errors, bool isRecoverable});
}

/// @nodoc
class _$ValidationErrorCopyWithImpl<$Res>
    implements $ValidationErrorCopyWith<$Res> {
  _$ValidationErrorCopyWithImpl(this._self, this._then);

  final ValidationError _self;
  final $Res Function(ValidationError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? errors = null,
    Object? isRecoverable = null,
  }) {
    return _then(ValidationError(
      errors: null == errors
          ? _self._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      isRecoverable: null == isRecoverable
          ? _self.isRecoverable
          : isRecoverable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class ServerError implements AppError {
  const ServerError(
      {required this.message,
      this.code,
      this.isRecoverable = false,
      this.originalError});

  final String message;
  final int? code;
  @override
  @JsonKey()
  final bool isRecoverable;
  final Object? originalError;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ServerErrorCopyWith<ServerError> get copyWith =>
      _$ServerErrorCopyWithImpl<ServerError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ServerError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.isRecoverable, isRecoverable) ||
                other.isRecoverable == isRecoverable) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code, isRecoverable,
      const DeepCollectionEquality().hash(originalError));

  @override
  String toString() {
    return 'AppError.server(message: $message, code: $code, isRecoverable: $isRecoverable, originalError: $originalError)';
  }
}

/// @nodoc
abstract mixin class $ServerErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $ServerErrorCopyWith(
          ServerError value, $Res Function(ServerError) _then) =
      _$ServerErrorCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String message, int? code, bool isRecoverable, Object? originalError});
}

/// @nodoc
class _$ServerErrorCopyWithImpl<$Res> implements $ServerErrorCopyWith<$Res> {
  _$ServerErrorCopyWithImpl(this._self, this._then);

  final ServerError _self;
  final $Res Function(ServerError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? code = freezed,
    Object? isRecoverable = null,
    Object? originalError = freezed,
  }) {
    return _then(ServerError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      isRecoverable: null == isRecoverable
          ? _self.isRecoverable
          : isRecoverable // ignore: cast_nullable_to_non_nullable
              as bool,
      originalError:
          freezed == originalError ? _self.originalError : originalError,
    ));
  }
}

/// @nodoc

class UnexpectedError implements AppError {
  const UnexpectedError(
      {required this.message,
      this.stackTrace,
      this.isRecoverable = false,
      this.originalError});

  final String message;
  final StackTrace? stackTrace;
  @override
  @JsonKey()
  final bool isRecoverable;
  final Object? originalError;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnexpectedErrorCopyWith<UnexpectedError> get copyWith =>
      _$UnexpectedErrorCopyWithImpl<UnexpectedError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnexpectedError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace) &&
            (identical(other.isRecoverable, isRecoverable) ||
                other.isRecoverable == isRecoverable) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, stackTrace,
      isRecoverable, const DeepCollectionEquality().hash(originalError));

  @override
  String toString() {
    return 'AppError.unexpected(message: $message, stackTrace: $stackTrace, isRecoverable: $isRecoverable, originalError: $originalError)';
  }
}

/// @nodoc
abstract mixin class $UnexpectedErrorCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory $UnexpectedErrorCopyWith(
          UnexpectedError value, $Res Function(UnexpectedError) _then) =
      _$UnexpectedErrorCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String message,
      StackTrace? stackTrace,
      bool isRecoverable,
      Object? originalError});
}

/// @nodoc
class _$UnexpectedErrorCopyWithImpl<$Res>
    implements $UnexpectedErrorCopyWith<$Res> {
  _$UnexpectedErrorCopyWithImpl(this._self, this._then);

  final UnexpectedError _self;
  final $Res Function(UnexpectedError) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? stackTrace = freezed,
    Object? isRecoverable = null,
    Object? originalError = freezed,
  }) {
    return _then(UnexpectedError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
      isRecoverable: null == isRecoverable
          ? _self.isRecoverable
          : isRecoverable // ignore: cast_nullable_to_non_nullable
              as bool,
      originalError:
          freezed == originalError ? _self.originalError : originalError,
    ));
  }
}

// dart format on
