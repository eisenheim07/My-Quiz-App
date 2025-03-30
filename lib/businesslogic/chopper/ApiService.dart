

import 'package:chopper/chopper.dart';

import '../../common/config.dart';

part 'ApiService.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService {
  @POST(path: Config.GET_CONVERSATION)
  Future<Response> getHome(@Body() String json, @Header("Authorization") String auth);

  static ApiService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse(Config.BASE_URL),
      interceptors: [
        HttpLoggingInterceptor(),
        const HeadersInterceptor({
          'Cache-Control': 'no-cache',
          'Content-Type': 'application/json',
        }),
      ],
      services: [_$ApiService()],
    );
    return _$ApiService(client);
  }
}
