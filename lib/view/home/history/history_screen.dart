import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vqa_app/auth_provider/auth_provider.dart';
import 'package:vqa_app/database/history_dao.dart';
import 'package:vqa_app/database/model/history.dart';
import 'package:vqa_app/view/widgets/history_item_widget.dart';
import 'package:vqa_app/view/widgets/search_item_text_field.dart';

class historyScreen extends StatefulWidget {
  static const String routeName = 'History_Screen';

  @override
  State<historyScreen> createState() => _historyScreenState();
}

class _historyScreenState extends State<historyScreen> {
  TextEditingController searchController = TextEditingController(); // Add search controller
  String searchQuery = ''; // Add search query state

  // Method to handle search changes
  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query.toLowerCase().trim();
    });
  }

  // Method to filter history based on search query
  List<History> _filterHistory(List<History> histories) {
    if (searchQuery.isEmpty) {
      return histories;
    }

    return histories.where((history) {
      // Search in question
      bool questionMatch = history.question?.toLowerCase().contains(searchQuery) ?? false;
      // Search in answer
      bool answerMatch = history.answer?.toLowerCase().contains(searchQuery) ?? false;

      return questionMatch || answerMatch;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<MyAuthProvider>(context);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home_screen_background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'History',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 22),
          child: Column(
            children: [
              // Updated search field with controller and onChanged callback
              searchItemTextField(
                controller: searchController,
                onChanged: _onSearchChanged,
              ),
              SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<History>>(
                  stream: historyDao.listenForHistories(authProvider.databaseUser!.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Something went wrong',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // This will rebuild the widget and retry the stream
                                });
                              },
                              child: Text('Try again'),
                            )
                          ],
                        ),
                      );
                    }

                    var historyList = snapshot.data;

                    if (historyList == null || historyList.isEmpty) {
                      return Center(
                        child: Text(
                          'No history found',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    // Apply search filter
                    List<History> filteredHistory = _filterHistory(historyList);

                    // Show "No results" if search returns empty
                    if (searchQuery.isNotEmpty && filteredHistory.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              color: Colors.white54,
                              size: 64,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No results found for "$searchQuery"',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try searching with different keywords',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemBuilder: (context, index) => HistoryItemWidget(
                        history: filteredHistory[index],
                      ),
                      itemCount: filteredHistory.length,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}