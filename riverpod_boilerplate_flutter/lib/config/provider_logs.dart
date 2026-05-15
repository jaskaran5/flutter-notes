import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'helper.dart';

class MyObserver extends ProviderObserver {
  @override
  void didAddProvider(
      ProviderBase<Object?> provider,
      Object? value,
      ProviderContainer container,
      ) {
    printLog('$provider was initialized with $value');
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider,
      ProviderContainer container,
      ) {
    printLog('$provider Disposed');
  }

  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue, Object? newValue, ProviderContainer container,) {
    printLog('$provider updated from $previousValue to $newValue');
  }

  @override
  void providerDidFail(
      ProviderBase<Object?> provider,
      Object error,
      StackTrace stackTrace,
      ProviderContainer container,
      ) {
    printLog('$provider threw $error at $stackTrace');
  }
}