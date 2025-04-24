import 'package:freezed_annotation/freezed_annotation.dart';
part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.network(String message, {int? code}) = NetworkFailure;
  const factory Failure.mapping(String message) = MappingFailure;
  const factory Failure.validation(Map<String, List<String>> errors, {int? code}) = ValidationFailure;
  const factory Failure.unknown(String message) = UnknownFailure;
}
