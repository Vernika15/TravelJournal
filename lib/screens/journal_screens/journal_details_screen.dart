import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_alert_dialog.dart';
import '../../data_manager/journal_data_manager.dart';
import '../../models/journal_entry.dart';
import '../../screens/journal_entry_screens/add_journal_entry_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/text_widget.dart';

class JournalDetailsScreen extends StatefulWidget {
  String? journalID;

  JournalDetailsScreen({super.key, required this.journalID});

  @override
  State<JournalDetailsScreen> createState() => _JournalDetailsScreenState();
}

class _JournalDetailsScreenState extends State<JournalDetailsScreen> {
  late String? _journalIDVal;
  final _utils = Utils();

  @override
  void initState() {
    super.initState();
    // Accessing the data passed from the constructor
    _journalIDVal = widget.journalID;
    Provider.of<JournalDataManager>(context, listen: false).isLoading = true;
    Future.delayed(Duration.zero, () {
      Provider.of<JournalDataManager>(context, listen: false)
          .getJournalEntriesList(context: context, journalId: _journalIDVal);
    });
  }

  void onDeleteTap(
      JournalDataManager journalDataProvider, JournalEntry journalEntry) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return CustomAlertDialog(
            title: delete,
            content: confirmDelete,
            buttonText1: okCaps,
            onButtonText1Pressed: () {
              journalDataProvider.sendDeleteJournalEntryRequest(
                context: context,
                journalId: _journalIDVal,
                entryId: journalEntry.journalEntryID,
              );
            },
            buttonText2: cancel,
            onButtonText2Pressed: () {},
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final journalDataProvider = Provider.of<JournalDataManager>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: whiteColor,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddJournalEntryScreen(
                    journalID: _journalIDVal,
                    // Pass a callback function that refreshes the data
                    refreshDataCallback: () {
                      // and update the state of the "Details Screen"
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: !journalDataProvider.isLoading
          ? journalDataProvider.journalEntry.length > 0
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    final entries = journalDataProvider.journalEntry[index];
                    return Stack(children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  // will add saturation or opacity over the image
                                  colorFilter: ColorFilter.mode(
                                      blackColor.withOpacity(0.3),
                                      BlendMode.darken),
                                  image: NetworkImage(
                                    entries.photoUrls[0],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  )
                                ]),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: entries.title,
                                color: whiteColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              TextWidget(
                                text: _utils.truncateText(entries.content, 15),
                                color: whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // IconButton(
                              //   icon: const Icon(
                              //     Icons.edit,
                              //     color: whiteColor,
                              //     size: 25,
                              //   ),
                              //   onPressed: () {},
                              // ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: whiteColor,
                                  size: 25,
                                ),
                                onPressed: () {
                                  onDeleteTap(journalDataProvider, entries);
                                },
                              )
                            ]),
                      ),
                    ]);
                  },
                  itemCount: journalDataProvider.journalEntry.length,
                  scrollDirection: Axis.vertical,
                )
              : Container(
                  color: whiteColor,
                  child: Center(
                    child: TextWidget(
                      text: noJournalEntry,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
          : const Center(
              child: CircularProgressIndicator(color: kAppThemeColor),
            ),
    );
  }
}
