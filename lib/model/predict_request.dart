import 'dart:io';

class PredictRequest {
  final File image;
  final String prompt;

  PredictRequest({required this.image, required this.prompt});
}