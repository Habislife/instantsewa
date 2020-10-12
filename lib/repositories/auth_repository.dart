import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:instantsewa/application/InstantSewa_api.dart';
import 'package:instantsewa/application/classes/errors/common_error.dart';
import 'package:instantsewa/application/storage/localstorage.dart';
import 'package:instantsewa/application/storage/storage_keys.dart';

abstract class AuthRepository {
  Future signIn({
    @required String email,
    @required String password,
  });

  Future signUp({
    @required String username,
    @required String email,
    @required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future signIn({
    String email,
    String password,
  }) async {
    try{
      Dio dio = new Dio();
      Response response = await InstantSewaAPI.dio
          .post("/auth/login", data: {"email": email, "password": password});
      String accessToken = response.data['accessToken'];
      String expiresAt = response.data['expiresAt'];
     await LocalStorage.setItem(TOKEN, accessToken);
      await LocalStorage.setItem(TOKEN_EXPIRATION, expiresAt);
      return ;
    }on DioError catch(e)
    {
      showNetworkError(e);
    }

  }

  @override
  Future signUp({
    String username,
    String email,
    String password,
  }) async {
    try {
      Dio dio = new Dio();
      Response response = await InstantSewaAPI.dio
          .post("/auth/register", data: {
        "email": email,
        "password": password,
        "username": username,
        "user_type": 'serviceuser'
      },);
    } on DioError catch(e)
    {
      showNetworkError(e);
    }
  }


}
