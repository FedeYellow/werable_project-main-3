import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';

/// A class for handling interaction with the IMPACT backend system.
/// It manages authentication (token and refresh), and fetches data related to steps, calories, etc.
class Impact {
  // Base URL of the IMPACT backend
  static const String baseUrl = 'https://impact.dei.unipd.it/bwthw/';

  // API Endpoints
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';
  static const String distanceEndpoint = 'data/v1/steps/patients/';
  static const String caloriesEndpoint = 'data/v1/calories/patients/';

  // Username for fixed patient (used in demo)
  static const String patientUsername = 'Jpefaq6m58';

  // Credentials for system login (should be secured or injected via env/config in real use)
  static String username = '<YOUR_USERNAME>';
  static String password = '<YOUR_PASSWORD>';

  /// Checks if the IMPACT backend service is online.
  Future<bool> isImpactUp() async {
    final url = Impact.baseUrl + Impact.pingEndpoint;
    print('Calling: $url');
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 200;
  }

  /// Logs in to IMPACT and stores the access/refresh tokens in SharedPreferences.
  Future<int> getAndStoreTokens() async {
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};

    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    }

    return response.statusCode;
  }

  /// Refreshes the JWT access and refresh tokens using the stored refresh token.
  static Future<int> refreshTokens() async {
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');

    final body = {'refresh': refresh};
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    }

    return response.statusCode;
  }

  /// Fetches step (distance) data for the given [day] in `YYYY-MM-DD` format.
  static Future<dynamic> fetchDistanceData(String day) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    // Refresh token if expired
    if (JwtDecoder.isExpired(access!)) {
      await Impact.refreshTokens();
      access = sp.getString('access');
    }

    final url = Impact.baseUrl + distanceEndpoint + patientUsername + '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};
    print('Calling: $url');

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  /// Fetches calorie data for the given [day] in `YYYY-MM-DD` format.
  static Future<dynamic> fetchCaloriesData(String day) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (JwtDecoder.isExpired(access!)) {
      await Impact.refreshTokens();
      access = sp.getString('access');
    }

    final url = Impact.baseUrl + caloriesEndpoint + patientUsername + '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};
    print('Calling: $url');

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  /// Fetches calorie data for a date range: [startDate] to [endDate], both in `YYYY-MM-DD` format.
  static Future<dynamic> fetchCaloriesWeekData(String startDate, String endDate) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (JwtDecoder.isExpired(access!)) {
      await Impact.refreshTokens();
      access = sp.getString('access');
    }

    final url = Impact.baseUrl +
        caloriesEndpoint +
        patientUsername +
        '/daterange/start_date/' +
        startDate +
        '/end_date/' +
        endDate +
        '/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};
    print('Calling: $url');

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Fetch error: ${response.statusCode}');
      return null;
    }
  }
}
