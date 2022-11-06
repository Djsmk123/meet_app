import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Networking {
 static String baseUrl = const String.fromEnvironment('url', defaultValue: "http://10.0.2.2:3000");
  static Future<String> getAccessToken() async {
    String accessToken =
    await FirebaseAuth.instance.currentUser!.getIdToken(true);
    log(accessToken);
    return accessToken;
  }

 static  Future postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? customHeaders,
  }) async {
    Uri url = Uri.parse(baseUrl + endpoint);
    log(url.toString());

        Map<String, String> headers = {
          "Content-Type": "application/json"
    };
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 59));

      String data = response.body;

      var jsonDecoded = jsonDecode(data);

      log("jsondecoded - $jsonDecoded");

      if (jsonDecoded.containsKey("error")) {
        var jsonError = jsonDecoded["error"];
        log("error inside is $jsonError");
        throw Exception("Something went wrong");
      }
      return jsonDecoded;
    } catch(e){
      log(e.toString());
    }
  }
}