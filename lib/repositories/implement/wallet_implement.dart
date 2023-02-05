import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/wallet_response.dart';
import 'package:it_job_mobile/repositories/interface/wallet_interface.dart';

import '../../models/entity/paging.dart';

class WalletImplement implements WalletInterface {
  @override
  Future<WalletResponse> wallet(String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "?applicantId=" + id);
      if (response.statusCode == 200) {
        result =
            WalletResponse.walletResponseFromJson(jsonEncode(response.data));
      } else {
        result = WalletResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error wallet: $e');
      result = WalletResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }
}
