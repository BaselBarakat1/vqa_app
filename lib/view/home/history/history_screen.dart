import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vqa_app/auth_provider/auth_provider.dart';
import 'package:vqa_app/database/history_dao.dart';
import 'package:vqa_app/view/widgets/history_item_widget.dart';
import 'package:vqa_app/view/widgets/search_item_text_field.dart';

class historyScreen extends StatefulWidget {
static const String routeName = 'History_Screen';

  @override
  State<historyScreen> createState() => _historyScreenState();
}

class _historyScreenState extends State<historyScreen> {
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
          appBar: AppBar(
            title: const Text(
              'History',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
         body:Padding(
           padding: EdgeInsets.symmetric(horizontal: 26,vertical: 22),
           child: Column(
             children: [
               searchItemTextField(),
               Expanded(
                   child: StreamBuilder(
                       stream: historyDao.listenForHistories(authProvider.databaseUser!.id!),
                       builder: (context, snapshot) {
                         if(snapshot.connectionState == ConnectionState.waiting){
                           return Center(child: CircularProgressIndicator());
                         }
                         if(snapshot.hasError){
                           return Center(
                             child: Column(
                               children: [
                                 Text('Something went wrong'),
                                 ElevatedButton(onPressed: () {
                                   setState(() {

                                   });
                                 }, child: Text('Try again'))
                               ],
                             ),
                           );
                         }
                         var historyList = snapshot.data;
                         return ListView.builder(itemBuilder: (context, index) => HistoryItemWidget(history: historyList![index]),itemCount: historyList?.length ?? 0 ,);
                       },))
             ],
           ),
         ),
        )
    );
  }
}
