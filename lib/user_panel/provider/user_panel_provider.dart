import 'package:Kupool/net/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/subAccount_panel_entity.dart';

// For clarity, we can define a type alias for the arguments record.
typedef UserPanelArguments = ({int subaccountId, String coin});

// By using .family, this provider now explicitly depends on the arguments passed to it.
final userPanelProvider = FutureProvider.autoDispose
    .family<SubAccountPanelEntity?, UserPanelArguments>((ref, args) async {

  final params = {
    'subaccount_id': args.subaccountId,
    'coin': args.coin,
  };

  final response = await ApiService().get(
    '/v1/dashboard/info',
    queryParameters: params,
  );

  if (response != null) {
    return SubAccountPanelEntity.fromJson(response);
  }

  return null;
});
