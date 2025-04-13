import 'dart:io';
import 'package:intl/intl.dart'; // For formatting timestamps

class ConversationEntry {
  final File image;
  final String question;
  final String answer;
  final DateTime timestamp; // Single timestamp for when the message is sent

  ConversationEntry({
    required this.image,
    required this.question,
    required this.answer,
    required this.timestamp,
  });

  // Helper to format timestamps (e.g., "12:02 am")
  String formatTimestamp() {
    return DateFormat('h:mm a').format(timestamp).toLowerCase();
  }
}