import 'package:currencytask/data/api_handling/network_exceptions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_state.freezed.dart';

@freezed
class ExchangeState<T> with _$ExchangeState<T> {
  const factory ExchangeState.idle() = Idle<T>;
  const factory ExchangeState.loading() = Loading<T>;
  const factory ExchangeState.success(T data) = Success<T>;
  const factory ExchangeState.error(NetworkExceptions networkExceptions) =
      Error<T>;
}
