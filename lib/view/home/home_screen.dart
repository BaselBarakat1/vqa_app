import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vqa_app/view/home/home_drawer.dart';
import 'package:vqa_app/view/widgets/image_widget.dart';
import 'package:vqa_app/view/widgets/question_text_field.dart';
import 'package:vqa_app/view/widgets/question_widget.dart';

import '../../api_manager/api_manager.dart';
import '../../model/predict_request.dart';
import '../../model/conversation_entry.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'Home_Screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? file;
  TextEditingController questionController = TextEditingController();
  bool isLoading = false;
  String apiError = '';
  List<ConversationEntry> conversationEntries = [];
  final ScrollController _scrollController = ScrollController();

  // Initialize ApiManager
  final apiManager = ApiManager(baseUrl: 'https://3526-34-142-174-17.ngrok-free.app/');

  Future<void> getImage() async {
    // Show a bottom sheet with options for Camera and Gallery
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      file = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      file = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> send() async {
    if (file == null) {
      setState(() {
        apiError = 'Please select an image';
      });
      return;
    }
    if (questionController.text.trim().isEmpty) {
      setState(() {
        apiError = 'Please enter a question';
      });
      return;
    }

    final currentImage = file!;
    final currentQuestion = questionController.text.trim();
    final sentTime = DateTime.now();

    setState(() {
      isLoading = true;
      apiError = '';
    });

    final request = PredictRequest(
      image: currentImage,
      prompt: currentQuestion,
    );

    final response = await apiManager.predict(request);

    setState(() {
      isLoading = false;
      if (response.error != null) {
        apiError = response.error!;
      } else {
        conversationEntries.add(
          ConversationEntry(
            image: currentImage,
            question: currentQuestion,
            answer: response.response,
            timestamp: sentTime,
          ),
        );
        file = null;
        questionController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  void clearChat() {
    setState(() {
      conversationEntries.clear();
      file = null;
      questionController.clear();
      apiError = '';
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home_screen_background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'VQA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.menu_outlined,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              if (scaffoldKey.currentState?.isDrawerOpen == false) {
                scaffoldKey.currentState?.openDrawer();
              } else {
                scaffoldKey.currentState?.closeDrawer();
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
                size: 24,
              ),
              onPressed: clearChat,
            ),
          ],
        ),
        body: Scaffold(
          key: scaffoldKey,
          drawer: HomeDrawer(),
          body: Container(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                      child: Column(
                        children: [
                          // Chat history
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: conversationEntries.length,
                            itemBuilder: (context, index) {
                              final entry = conversationEntries[index];
                              return Column(
                                children: [
                                  // Centered Timestamp
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      entry.formatTimestamp(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  // User Message (Question and Image) - Right Aligned
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        // Question
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: questionWidget(
                                            Question: entry.question,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Image
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            topLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                            topRight: Radius.circular(0),
                                          ),
                                          child: Image.file(
                                            entry.image,
                                            width: 250,
                                            height: 250,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // VQA Response - Left Aligned
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset('assets/images/vqa_mini_logo.png'),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff18222E),
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                topLeft: Radius.circular(12),
                                                bottomRight: Radius.circular(12),
                                                bottomLeft: Radius.circular(0),
                                              ),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              entry.answer,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          if (isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: CircularProgressIndicator(),
                            ),
                          if (apiError.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Error: $apiError',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Image and Question Preview (Cache Section)
                if (file != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900]!.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Preview
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            topRight: Radius.circular(0),
                          ),
                          child: Image.file(
                            file!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Image Name and Question Preview
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image Name
                              Text(
                                file!.path.split('/').last,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Live Question Preview
                              if (questionController.text.trim().isNotEmpty)
                                Text(
                                  questionController.text.trim(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Clear Image Button
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              file = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                // TextFormField for Question Input
                TextFormField(
                  controller: questionController,
                  maxLines: 3,
                  minLines: 1,
                  textAlign: TextAlign.start,
                  cursorColor: Colors.white,
                  scrollPadding: const EdgeInsets.only(bottom: 100),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color(0xff18222E),
                    filled: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: IconButton(
                        onPressed: getImage,
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                      ),
                    ),
                    prefixIconColor: Colors.white,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: IconButton(
                        onPressed: send,
                        icon: const Icon(Icons.send),
                      ),
                    ),
                    suffixIconColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: const BorderSide(style: BorderStyle.none),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: const BorderSide(style: BorderStyle.none),
                    ),
                    hintText: 'Enter your Question',
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}