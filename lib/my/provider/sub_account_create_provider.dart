import 'package:Kupool/net/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Manually define the provider to fix the "Undefined name" error.
final subAccountCreateProvider =
    AsyncNotifierProvider<SubAccountCreateNotifier, void>(
  SubAccountCreateNotifier.new,
);

class SubAccountCreateNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial data to load
  }

  Future<void> create(Map<String, dynamic> parm) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // ApiService now re-throws exceptions, so we don't need to check for null.
      // AsyncValue.guard will automatically catch the exception and set the state to AsyncError.
      await ApiService().post('/v1/subaccount/create', data: parm);
    });
  }
}
