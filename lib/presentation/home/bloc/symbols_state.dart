import 'package:currencytask/data/api_handling/network_exceptions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'symbols_state.freezed.dart';

@freezed
class SymbolsState<T> with _$SymbolsState<T> {
  const factory SymbolsState.idle() = Idle<T>;
  const factory SymbolsState.loading() = Loading<T>;
  const factory SymbolsState.success(T data) = Success<T>;
  const factory SymbolsState.error(NetworkExceptions networkExceptions) =
      Error<T>;
}
