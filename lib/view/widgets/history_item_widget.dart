import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:vqa_app/auth_provider/auth_provider.dart';
import 'package:vqa_app/database/history_dao.dart';
import 'package:vqa_app/database/model/history.dart';
import 'package:vqa_app/utils/dialog_utils.dart';

class HistoryItemWidget extends StatefulWidget {
  // Good practice to make fields final when they are initialized in the constructor
  final History history;

  HistoryItemWidget({required this.history});

  @override
  State<HistoryItemWidget> createState() => _HistoryItemWidgetState();
}

class _HistoryItemWidgetState extends State<HistoryItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.3,
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(14),
            onPressed: (context) {
              deleteHistory();
            },
            backgroundColor: Color(0xFFFE4A49),
            //foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container( // Removed Flexible here. It's often better to manage flexible space within the content itself.
        padding: EdgeInsets.all(18),
        margin: EdgeInsets.only(top: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Color(0xff18222E),
        ),
        child: Row(
          // Ensure the content aligns to the start of the row
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use Expanded here to make the Column take all available horizontal space.
            // This is crucial because if the Column doesn't have a bounded width, its children can overflow.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // Align the "Q:" and question text to the start vertically
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                      SizedBox(width: 5),
                      // Wrap the actual question text with Expanded.
                      // This forces the Text widget to take up the remaining space in the Row
                      // and then apply its wrapping rules.
                      Expanded(
                        child: Text(
                          widget.history.question ?? '',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
                          softWrap: true, // Allows the text to wrap to the next line
                          overflow: TextOverflow.visible, // This makes the wrapped text fully visible
                          // If you wanted to cut off the text and add "..." use TextOverflow.ellipsis
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8), // Add some vertical spacing between Q and A for better readability
                  Row(
                    // Align the "A:" and answer text to the start vertically
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                      SizedBox(width: 5),
                      // Wrap the actual answer text with Expanded for the same reasons as the question.
                      Expanded(
                        child: Text(
                          widget.history.answer ?? '',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
                          softWrap: true, // Allows the text to wrap
                          overflow: TextOverflow.visible, // Makes the wrapped text fully visible
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> deleteHistory() async {
    var authProvider = Provider.of<MyAuthProvider>(context,listen: false);
    await historyDao.deleteHistory(authProvider.databaseUser!.id!,widget.history.id!);
    DialogUtils.showMessage(context, 'Task deleted successfully',postiveActionTitle: 'Ok');
  }
}