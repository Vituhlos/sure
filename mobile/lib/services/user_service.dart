import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class UserService {
  Future<Map<String, dynamic>> resetAccount({
    required String accessToken,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/users/reset');

      final response = await http.delete(
        url,
        headers: ApiConfig.getAuthHeaders(accessToken),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return {'success': true};
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': 'session_expired',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error': responseData['error'] ?? 'reset_account_failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'network_unavailable',
      };
    }
  }

  Future<Map<String, dynamic>> deleteAccount({
    required String accessToken,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/users/me');

      final response = await http.delete(
        url,
        headers: ApiConfig.getAuthHeaders(accessToken),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return {'success': true};
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': 'session_expired',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error': responseData['error'] ?? 'delete_account_failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'network_unavailable',
      };
    }
  }
}
