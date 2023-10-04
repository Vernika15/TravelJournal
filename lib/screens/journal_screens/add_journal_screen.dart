import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

import '../../data_manager/home_data_manager.dart';
import '../../data_manager/journal_data_manager.dart';
import '../../models/journal.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/textfield_widget.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({Key? key}) : super(key: key);

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _image;
  String _imageString = '';
  var showDateTime; // Variable to hold the selected date and time
  Timestamp? selectedDateTime;
  bool imageLoading = false;

  // Function to open the image picker dialog
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: source);

      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });

        final firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(pickedImage.path)}');
        final firebase_storage.UploadTask uploadTask =
            storageReference.putFile(File(pickedImage.path));

        imageLoading = true;

        await uploadTask.whenComplete(() async {
          final imageUrl = await storageReference.getDownloadURL();

          setState(() {
            _imageString = imageUrl;
          });

          imageLoading = false;
        });
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

  void getJournalValues(HomeDataManager homeProvider,
      JournalDataManager journalDataProvider) async {
    // Get the values from the controllers
    String title = _titleController.text;
    String location = _locationController.text;
    String coverPhotoUrl = _imageString;

    // Create a Journal object
    Journal journal = Journal(
      title: title,
      date: selectedDateTime,
      location: location,
      coverPhotoUrl: coverPhotoUrl,
    );

    // Call the createJournal function with the Journal object
    bool success = await journalDataProvider.sendAddJournalRequest(
      context: context,
      journal: journal,
    );
    if (success) {
      homeProvider.setIndex(
          0); //will move to dashboard screen after submitting the form
    }
  }

  void submitTrip(
      HomeDataManager homeProvider, JournalDataManager journalDataProvider) {
    String title = _titleController.text.trim();
    String location = _locationController.text.trim();

    if (title.isEmpty) {
      Fluttertoast.showToast(
        msg: validations['titleEmpty'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (location.isEmpty) {
      Fluttertoast.showToast(
        msg: validations['locationEmpty'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (selectedDateTime == null) {
      Fluttertoast.showToast(
        msg: validations['dateEmpty'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (_imageString.isEmpty) {
      Fluttertoast.showToast(
        msg: validations['imageEmpty'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      getJournalValues(homeProvider, journalDataProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeDataManager>(context);
    final journalDataProvider = Provider.of<JournalDataManager>(context);

    return Scaffold(
      appBar: PreferredSize(
        // used to hide app bar
        preferredSize: const Size(0.0, 0.0),
        child: Container(
          color: gradientColors[0],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                _pickImage(ImageSource.gallery); // Open gallery
                // _pickImage(ImageSource.camera); // Open camera
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 120,
                  child: DottedBorder(
                    dashPattern: [8, 8],
                    strokeWidth: 2,
                    color: kAppThemeColor,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(20),
                    child: Center(
                      child: _image == null
                          ? Image.asset(
                              'assets/images/camera.png',
                              width: 60,
                              height: 60,
                              color: kAppThemeColor,
                              fit: BoxFit.contain,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.file(
                                _image!,
                                width: 200,
                                height: 120,
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
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
                child: Row(children: [
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
                ]),
              ),
            ),
            const SizedBox(height: 30),
            TextFieldWidget(
              hintText: enterLocation,
              prefixImage: Icons.location_history,
              isPasswordType: false,
              controller: _locationController,
              passwordVisible: false,
              subText: location,
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
                    buttonText: startTrip,
                    onTap: () {
                      submitTrip(homeProvider, journalDataProvider);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
