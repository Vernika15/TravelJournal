import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/journal_data_manager.dart';
import '../models/journal.dart';
import '../screens/journal_screens/journal_details_screen.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/text_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Journal> allJournals;
  List<Journal> displayedJournals = [];
  TextEditingController searchController = TextEditingController();
  String filterQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<JournalDataManager>(context, listen: false).isLoading = true;
    Future.delayed(Duration.zero, () {
      Provider.of<JournalDataManager>(context, listen: false)
          .getJournalsList(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final journalDataProvider = Provider.of<JournalDataManager>(context);

    return Scaffold(
      appBar: PreferredSize(
        // used to hide app bar
        preferredSize: const Size(0.0, 0.0),
        child: Container(
          color: primaryColor,
        ),
      ),
      body: !journalDataProvider.isLoading
          ? journalDataProvider.journal.length > 0
              ? Container(
                  height: double.infinity,
                  child: CarouselSlider(
                    items: journalDataProvider.journal.map((item) {
                      return journalItem(item);
                    }).toList(),
                    options: CarouselOptions(
                      height: 550.0,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                    ),
                  ),
                )
              : Container(
                  color: whiteColor,
                  child: Center(
                    child: TextWidget(
                      text: noJournals,
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

  Widget journalItem(Journal journal) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JournalDetailsScreen(
                  journalID: journal.journalID,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                  blackColor.withOpacity(0.3),
                  BlendMode.darken,
                ), // will add saturation or opacity over the image
                image: NetworkImage(
                  journal.coverPhotoUrl,
                ),
                fit: BoxFit.cover,
              ),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: journal.title,
                  color: whiteColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextWidget(
                  text: journal.location,
                  color: whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
