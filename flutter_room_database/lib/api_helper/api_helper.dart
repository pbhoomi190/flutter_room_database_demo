import 'dart:convert';
import 'package:flutterroomdatabase/constants/common_enums.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class APIHelper {
  Future<dynamic> sendRequest(String url, HttpRequestType httpRequestType,
      {Map<String, String> parameters}) async {

    http.Response httpResponse;
    var responseJSON;

    switch (httpRequestType) {
      case HttpRequestType.get:
        if (parameters != null) {
          var uri = Uri.parse(url);
          uri.replace(queryParameters: parameters);
          // IF HEADER NEEDS TO BE ADDED THEN ADD COMMENTED CODE BELOW
          /*http.get(uri, headers: {
                "Content-Type" : "application/json",
                "Authorization" : "",
              });*/
          // END OF COMMENT
          httpResponse = await http.get(uri);
          responseJSON = json.decode(httpResponse.body);
          return responseJSON;
        } else {
          httpResponse = await http.get(url);
          responseJSON = json.decode(httpResponse.body);
          return responseJSON;
        }
        break;
      case HttpRequestType.post:
        if (parameters != null) {
          httpResponse = await http.post(url, body: json.encode(parameters));
          responseJSON = json.decode(httpResponse.body);
          return responseJSON;
        } else {
          httpResponse = await http.post(url);
          responseJSON = json.decode(httpResponse.body);
        }
        break;
    }
  }
}
