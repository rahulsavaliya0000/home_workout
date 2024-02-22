import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/garbage/temp.dart';
import 'package:home_workout/utils/provider/auth_provider.dart';
import 'package:home_workout/utils/provider/theme_provider.dart';
import 'package:home_workout/utils/utils.dart';
import 'package:home_workout/view/auth_ui/create_account.dart';
import 'package:home_workout/view/home_screen/profile_screen/caleroies.dart';
import 'package:home_workout/view/home_screen/profile_screen/faq_screen.dart';
import 'package:home_workout/view/home_screen/profile_screen/invite_friend.dart';
import 'package:home_workout/view/home_screen/profile_screen/notifications.dart';
import 'package:home_workout/view/setting_ui/privacy.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:super_circle/super_circle.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;
  File? _image;
  String _imageUrl = '';
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  String _displayName =
      FirebaseAuth.instance.currentUser!.displayName ?? "User";

  void _updateDisplayNameFirebase(String newName) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.updateDisplayName(newName).then((_) {
        setState(() {
          _displayName = newName;
        });
        Utils.toastMessage('Display name updated successfully.');
      }).catchError((Error) {
        // Handle any error that occurs during the display name update
        Utils.toastMessage('Error updating display name: $Error');
      });
    }
  }

  Future<void> _showEditDisplayNameDialog() async {
    var newName = _displayName;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.blackColor,
          title: const Text(
            'Edit Your Name',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: AppColor.whiteColor,
            ),
          ),
          content: TextFormField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white),
              ),
              fillColor: const Color(0xfffffffff),
              focusColor: const Color(0xffffffff),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            initialValue: _displayName,
            style: const TextStyle(
              color: Color(0xffffffff),
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
            ),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: AppColor.redColor,
                    fontSize: 17),
              ),
            ),
            TextButton(
              onPressed: () {
                _updateDisplayNameFirebase(newName);
                Navigator.pop(context);
              },
              child: const Text(
                'Save',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: AppColor.whiteColor,
                    fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'photoUrl': '',
          });
          userDoc = await _firestore.collection('users').doc(user.uid).get();
        }
        _imageUrl = userDoc.get('photoUrl') ?? '';
      } catch (error) {
        _errorMessage = 'Error fetching user profile: $error';
      }
    } else {
      _errorMessage = 'User is not authenticated';
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CreateAccountPage()),
        (route) => false,
      );
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  Future<void> _uploadImage() async {
    try {
      final picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Use image cropper
        ImageCropper imageCropper = ImageCropper();
        CroppedFile? croppedFile = await imageCropper.cropImage(
          sourcePath: pickedFile.path,
        );

        if (croppedFile != null) {
          // Convert CroppedFile to File
          _image = File(croppedFile.path);

          setState(() {
            _isLoading = true;
            _errorMessage = '';
          });

          String uid = _auth.currentUser!.uid;
          Reference storageReference =
              _storage.ref().child('user_photos/$uid.jpg');
          UploadTask uploadTask = storageReference.putFile(_image!);

          await uploadTask.whenComplete(() async {
            String url = await storageReference.getDownloadURL();

            // Update the image URL in Firestore
            await _firestore
                .collection('users')
                .doc(uid)
                .update({'photoUrl': url});

            await Auth_Provider().updateUserProfileImageUrl(url);

            setState(() {
              _imageUrl = url;
              _isLoading = false;
            });
          });
        } else {}
      }
    } catch (error) {
      _errorMessage = 'Error uploading image: $error';
      print('Error: $error');
      setState(() {
        _isLoading = false;
      });
    }
  } bool refreshing = false;

  // Simulating some data fetching
  Future<void> _refreshData() async {
    setState(() {
      refreshing = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      refreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    User? user = _auth.currentUser;
    bool isDarkMode = themeProvider.isDarkMode;

    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
               
                    child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColor.blueColor,
                          size: 33,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return Stack(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  color:
                                      (context.read<ThemeProvider>().isDarkMode)
                                          ? Colors.grey[800]!
                                          : Colors.grey[300]!,
                                  child: const Center(),
                                ),
                                ScaleTransition(
                                  scale: animation,
                                  child: RotationTransition(
                                    turns: Tween<double>(begin: 0.0, end: 0.5)
                                        .animate(animation),
                                    child: child,
                                  ),
                                ),
                              ],
                            );
                          },
                          child: Builder(
                            builder: (context) {
                              final themeMode =
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? ThemeMode.dark
                                      : ThemeMode.light;
            
                              return TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                onPressed: () {
                                  context.read<ThemeProvider>().toggleTheme();
                                },
                                child: Icon(themeProvider.isDarkMode? Icons.wb_sunny:Icons.nightlight_round_outlined,
                                                           
                                    color: themeProvider.isDarkMode ?Colors.white:Colors.black.withOpacity(0.9),
                                      key: ValueKey<ThemeMode>(
                                      themeMode),                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              border: Border.all(
                                color: AppColor.blueColor,
                                width: 1.2,
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : _errorMessage.isNotEmpty
                                    ? Center(
                                        child: Text(
                                          _errorMessage,
                                          style:
                                              const TextStyle(color: Colors.red),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 80,
                                        backgroundImage: (_image != null)
                                            ? FileImage(_image!)
                                            : (_imageUrl.isNotEmpty)
                                                ? NetworkImage(_imageUrl)
                                                : const AssetImage(
                                                        'assets/edit_imageicon.png')
                                                    as ImageProvider,
                                      ),
                          ),
                        ),
                        Positioned(
                          right: 3,
                          bottom: 8,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColor.blueColor,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: _uploadImage,
                                  child: Image.asset(
                                    'assets/edit_imageicon.png',
                                    width: 27,
                                    height: 27,
                                    color: AppColor.blueColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 45),
                    Text(
                      _displayName,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 19),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: AppColor.blueColor,
                        size: 22,
                      ),
                      onPressed: _showEditDisplayNameDialog,
                    ),
                  ],
                ),
                Text(
                  user?.email ?? 'user@email.com',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title:  Text(
                          'Privacy',
                          style: TextStyle(
                              color: themeProvider.isDarkMode? Colors.black:AppColor.blueColor,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: 19),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyScreen()),
                          );
                        },
                      ),
                      const Divider(color: Colors.black),
                      ListTile(
                        title: Text(
                          'Calorie Calculator',
                          style: TextStyle(
                             color: themeProvider.isDarkMode? Colors.black:AppColor.blueColor,

                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: 19),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                // builder: (context) => StepDashboard()),
                                builder: (context) => CalorieCalculatorScreen()),
                          );
                        },
                      ),
                      const Divider(color: Colors.black),
                      ListTile(
                        title: Text(
                          'FAQ',
                          style: TextStyle(
color: themeProvider.isDarkMode? Colors.black:AppColor.blueColor,                     fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: 19),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FAQScreen()),
                          );
                        },
                      ),
                      const Divider(color: Colors.black),
                      ListTile(
                        title:  Text(
                          'Notifications',
                          style: TextStyle(
                              color: themeProvider.isDarkMode? Colors.black:AppColor.blueColor,fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: 19),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationsPage()),
                          );
                        },
                      ),
                      const Divider(color: Colors.black),
                      ListTile(
                        title:  Text(
                          'Invite a Friend',
                          style: TextStyle(
                             color: themeProvider.isDarkMode? Colors.black:AppColor.blueColor,

                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: 19),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InviteFriendScreen(),
                              ));
                        },
                      ),
                      const Divider(color: Colors.black),
                      ListTile(
                          title: Text(
                            'Logout',
                            style: TextStyle(
                                                              color: themeProvider.isDarkMode? Colors.black:AppColor.blueColor,

                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                                fontSize: 19),
                          ),
                          onTap: () {
                            _signOut(context);
                          }),
                    ],
                  ),
                ),
              ],
            ),
                    ),
                  ),
          )),
    );
  }
}
