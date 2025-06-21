// models/predict_response.dart
import 'dart:convert';

class PredictResponse {
  final String response;
  final String? error;

  PredictResponse({required this.response, this.error});

  factory PredictResponse.fromJson(Map<String, dynamic> json) {
    return PredictResponse(
      response: json['response'] ?? '',
      error: json['error'],
    );
  }
}