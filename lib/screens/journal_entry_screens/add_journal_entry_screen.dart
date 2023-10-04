import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../../data_manager/journal_data_manager.dart';
import '../../models/journal_entry.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/textfield_widget.dart';

class AddJournalEntryScreen extends StatefulWidget {
  String? journalID;
  final VoidCallback? refreshDataCallback;

  AddJournalEntryScreen(
      {super.key, required this.journalID, this.refreshDataCallback});

  @override
  State<AddJournalEntryScreen> createState() => _AddJournalEntryScreenState();
}

class _AddJournalEntryScreenState extends State<AddJournalEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<XFile> _selectedImages = [];
  var showDateTime; // Variable to hold the selected date and time
  Timestamp? selectedDateTime;
  List<String> selectedImages = [];
  late String? _journalIDVal;
  final _utils = Utils();
  bool imageLoading = false;

  @override
  void initState() {
    super.initState();
    _journalIDVal = widget.journalID;
  }

  // Function to open the image picker dialog
  Future<void> _pickImages(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedImages = await picker.pickMultiImage();

      if (pickedImages != null) {
        setState(() {
          _selectedImages = pickedImages;
        });

        final storage = firebase_storage.FirebaseStorage.instance;
        List<String> photoUrls = [];

        imageLoading = true;

        for (var image in _selectedImages) {
          final firebase_storage.Reference ref =
              storage.ref().child('images/${DateTime.now()}.png');
          await ref.putFile(File(image.path));

          final imageUrl = await ref.getDownloadURL();
          photoUrls.add(imageUrl);
        }

        setState(() {
          selectedImages = photoUrls;
        });

        imageLoading = false;
      } else {
        // Handle the case where the user canceled image selection
        print('No image selected.');
      }
    } catch (e) {
      // Handle any potential exceptions, such as unsupported image formats
      print('Error picking image: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(error),
            content: const Text(imageLoadError),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(okCaps),
              ),
            ],
          );
        },
      );
    }
  }

  void getJournalEntryValues(JournalDataManager journalDataProvider) async {
    // Get the values from the controllers
    String title = _titleController.text;
    String content = _contentController.text;

    // Create a Journal object
    JournalEntry journalEntry = JournalEntry(
      title: title,
      date: selectedDateTime,
      content: content,
      photoUrls: selectedImages,
    );

    // Call the createJournalEntry function with the Journal Entry object
    bool success = await journalDataProvider.sendAddJournalEntryRequest(
      context: context,
      journalEntry: journalEntry,
      journalId: _journalIDVal,
      userId: _utils.getCurrentUserId(),
    );
    if (success) {
      Navigator.of(context).pop();
    }
  }

  void submitJournalEntry(JournalDataManager journalDataProvider) {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty) {
      Fluttertoast.showToast(
        msg: validations['titleEmpty'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (content.isEmpty) {
      Fluttertoast.showToast(
        msg: validations['contentEmpty'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (selectedDateTime == null) {
      Fluttertoast.showToast(
        msg: validations['dateEmpty'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (_selectedImages.isEmpty) {
      Fluttertoast.showToast(
        msg: validations['tripImagesEmpty'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      getJournalEntryValues(journalDataProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final journalDataProvider = Provider.of<JournalDataManager>(context);

    return Scaffold(
        appBar: AppBar(
          title: TextWidget(
            text: addJournalEntry,
            fontSize: 24,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 20.0,
              bottom: 35.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: tripImages,
                      textAlign: TextAlign.left,
                      color: kAppThemeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    CircleAvatar(
                      backgroundColor: kAppThemeColor,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(
                          Icons.photo,
                          color: whiteColor,
                          size: 25,
                        ),
                        onPressed: () {
                          _pickImages(ImageSource.gallery); // Open gallery
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                if (_selectedImages.isNotEmpty)
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    // Disable GridView's scrolling
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 11,
                      mainAxisSpacing: 11,
                    ),
                    itemCount: _selectedImages.length,
                    itemBuilder: (item, index) {
                      if (index < _selectedImages.length) {
                        return Image.file(
                          File(_selectedImages[index].path),
                          width: 15,
                          height: 15,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const SizedBox(); // Return an empty container if the index is out of range.
                      }
                    },
                  ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  hintText: enterTitle,
                  prefixImage: Icons.edit,
                  isPasswordType: false,
                  controller: _titleController,
                  passwordVisible: false,
                  subText: title,
                ),
                const SizedBox(height: 30),
                TextWidget(
                  text: selectDateTime,
                  textAlign: TextAlign.left,
                  color: kAppThemeColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      onConfirm: (date) {
                        // Update the selectedDateTime variable
                        setState(() {
                          //convert date and time to timestamps
                          selectedDateTime = Timestamp.fromDate(date);
                          showDateTime = date;
                        });
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en, // Set the locale
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      color: kAppThemeColor.withOpacity(0.3),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month,
                            color: kAppThemeColor.withOpacity(0.9)),
                        const SizedBox(width: 13),
                        TextWidget(
                          text: selectedDateTime != null
                              ? DateFormat('MM/dd/yyyy').format(showDateTime)
                              : selectDateTime,
                          textAlign: TextAlign.center,
                          color: kAppThemeColor.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFieldWidget(
                  hintText: enterContent,
                  prefixImage: Icons.edit,
                  isPasswordType: false,
                  controller: _contentController,
                  passwordVisible: false,
                  subText: content,
                ),
                const SizedBox(height: 50),
                imageLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: kAppThemeColor),
                          SizedBox(width: 20),
                          TextWidget(text: 'Downloading Image...'),
                        ],
                      )
                    : ButtonWidget(
                        buttonText: addEntry,
                        onTap: () {
                          submitJournalEntry(journalDataProvider);
                        },
                      ),
              ],
            ),
          ),
        ));
  }
}
