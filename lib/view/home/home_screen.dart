import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vqa_app/auth_provider/auth_provider.dart';
import 'package:vqa_app/database/history_dao.dart';
import 'package:vqa_app/database/model/conversation_entry.dart';
import 'package:vqa_app/database/model/history.dart';
import 'package:vqa_app/database/model/predict_request.dart';
import 'package:vqa_app/view/home/home_drawer.dart';
import 'package:vqa_app/view/widgets/question_text_field.dart';
import 'package:vqa_app/view/widgets/question_widget.dart';

import '../../api_manager/api_manager.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'Home_Screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? file;
  File? currentContextImage;
  TextEditingController questionController = TextEditingController();
  bool isLoading = false;
  String apiError = '';
  List<ConversationEntry> conversationEntries = [];
  final ScrollController _scrollController = ScrollController();

  void _showFullScreenImage(File imageFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Initialize ApiManager
  final apiManager = ApiManager(baseUrl: 'https://flowing-locust-coherent.ngrok-free.app');

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
                      // When new image is selected, update context
                      currentContextImage = File(image.path);
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
                      // When new image is selected, update context
                      currentContextImage = File(image.path);
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
    var authProvider = Provider.of<MyAuthProvider>(context,listen: false);
    final currentQuestion = questionController.text.trim();
    final sentTime = DateTime.now();

    // Case 1: Only image, no question
    if (currentQuestion.isEmpty && file != null) {
      setState(() {
        conversationEntries.add(
          ConversationEntry(
            image: File(file!.path),
            question: '', // Empty question
            answer: 'Please add a question about this image.',
            timestamp: sentTime,
          ),
        );
        // Update context but don't clear the image yet
        currentContextImage = file!;
        file = null; // Clear staged image
        apiError = ''; // Clear any existing errors
      });

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
      return;
    }

    // Case 2: Only question, no image and no context
    if (currentQuestion.isNotEmpty && file == null && currentContextImage == null) {
      setState(() {
        conversationEntries.add(
          ConversationEntry(
            image: File(''), // Empty file path since no image
            question: currentQuestion,
            answer: 'Please select an image first to ask questions about it.',
            timestamp: sentTime,
          ),
        );
        questionController.clear();
        apiError = ''; // Clear any existing errors
      });

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
      return;
    }

// Case 3: No question and no image - do nothing (silent return)
    if (currentQuestion.isEmpty && file == null && currentContextImage == null) {
      return; // Simply return without doing anything
    }

// Case 4: No question but has context image - create a chat response
    if (currentQuestion.isEmpty && currentContextImage != null) {
      setState(() {
        conversationEntries.add(
          ConversationEntry(
            image: File(''), // No image to show since it's just a reminder
            question: '', // Empty question
            answer: 'Please enter a question about the image.',
            timestamp: sentTime,
          ),
        );
        apiError = ''; // Clear any existing errors
      });

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
      return;
    }

    // Determine which image to use for the API call
    File? imageToSend;

    if (file != null) {
      // New image uploaded, use it and update context
      imageToSend = file!;
      currentContextImage = file!;
    } else if (currentContextImage != null) {
      // No new image, but we have context image, use context image
      imageToSend = currentContextImage!;
    }

    // Create a copy of the image file for the conversation entry
    final imageForEntry = File(imageToSend!.path);

    setState(() {
      isLoading = true;
      apiError = '';
    });

    final request = PredictRequest(
      image: imageToSend,
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
            image: imageForEntry,
            question: currentQuestion,
            answer: response.response,
            timestamp: sentTime,
          ),
        );
        // Clear the staged image after sending (but keep context)
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
    if (response.response != null && response.response!.isNotEmpty) {
      History history = History(
        question: currentQuestion,
        answer: response.response!,
      );
      await historyDao.addHistory(authProvider.databaseUser!.id!, history, imageFile: imageForEntry);
    }
  }

  void clearChat() {
    setState(() {
      currentContextImage = null;
      conversationEntries.clear();
      file = null;
      questionController.clear();
      apiError = '';
    });
  }

  // Added welcome message widget
  Widget _buildWelcomeMessage() {
    var authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    String getFirstName() {
      String? displayName = authProvider.databaseUser?.userName;
      if (displayName != null && displayName.isNotEmpty) {
        return displayName.trim().split(' ').first;
      }
      return 'there';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Text(
          'Welcome ${getFirstName()}!\nWhat do you want to ask today?',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
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
                          // Welcome Message - Show only when no conversations
                          if (conversationEntries.isEmpty && !isLoading) ...[
                            _buildWelcomeMessage(),
                            SizedBox(height: 24),
                          ],

                          // Chat history
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: conversationEntries.length,
                            itemBuilder: (context, index) {
                              final entry = conversationEntries[index];
                              final showImage = entry.image.path.isNotEmpty && (index == 0 ||
                                  (index > 0 && entry.image.path != conversationEntries[index - 1].image.path));
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
                                        // Question (only show if question exists)
                                        if (entry.question.isNotEmpty) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: questionWidget(
                                              Question: entry.question,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                        ],

                                        // Image (only show if it's a new image or first message)
                                        if (showImage)
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: GestureDetector(
                                                onTap: () => _showFullScreenImage(entry.image),
                                                child: ClipRRect(
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
                                              ),
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