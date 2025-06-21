// services/api_manager.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vqa_app/database/model/predict_request.dart';
import 'package:vqa_app/database/model/predict_response.dart';

class ApiManager {
  final String baseUrl;

  ApiManager({required this.baseUrl});

  Future<PredictResponse> predict(PredictRequest request) async {
    final url = Uri.parse('$baseUrl/predict');
    try {
      // Create multipart request
      var multipartRequest = http.MultipartRequest('POST', url);

      // Add image file
      multipartRequest.files.add(
        await http.MultipartFile.fromPath('image', request.image.path),
      );

      // Add prompt field
      multipartRequest.fields['prompt'] = request.prompt;

      // Send request with timeout
      final response = await multipartRequest
          .send()
          .timeout(const Duration(seconds: 30));

      // Parse response
      final responseBody = await response.stream.bytesToString();
      final json = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return PredictResponse.fromJson(json);
      } else if (response.statusCode == 400 || response.statusCode == 500) {
        return PredictResponse(
          response: '',
          error: json['error'] ?? 'API error: ${response.statusCode}',
        );
      } else {
        return PredictResponse(
          response: '',
          error: 'Unexpected status code: ${response.statusCode}',
        );
      }
    } on http.ClientException catch (e) {
      return PredictResponse(response: '', error: 'Network error: $e');
    } on FormatException catch (e) {
      return PredictResponse(response: '', error: 'Invalid response: $e');
    } on TimeoutException catch (e) {
      return PredictResponse(response: '', error: 'Request timed out: $e');
    } catch (e) {
      return PredictResponse(response: '', error: 'Unexpected error: $e');
    }
  }
}