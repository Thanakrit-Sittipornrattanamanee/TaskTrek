import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planery_exclusive_demo_v1/Login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      loadData();
    }
  }

  void loadData() async {
    final DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(currentUser!.uid).get();
    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      _nameController.text = data['name'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _addressController.text = data['address'] ?? '';
      _emailController.text = data['email'] ?? '';
    }
  }

  void saveData() async {
    Map<String, dynamic> data = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'email': _emailController.text,
    };
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .set(data, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/564x/7f/c4/c6/7fc4c6ecc7738247aac61a60958429d4.jpg'),
            ),
            const SizedBox(height: 20),
            itemProfile('Name', _nameController, CupertinoIcons.person, context),
            itemProfile('Phone', _phoneController, CupertinoIcons.phone, context),
            itemProfile('Bio', _addressController, CupertinoIcons.chat_bubble, context),
            itemProfile('Email', _emailController, CupertinoIcons.mail, context),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: saveData,
              color: Color(0xFFFECCA5), // Peachy Rose
              child: const Text(
                'Save Changes',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LogIn()));
              },
              color: Color(0xFF548749), // English Ivy
              child: const Text(
                'Logout',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

Widget itemProfile(
    String title, TextEditingController controller, IconData iconData, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor, // Use the theme background color
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: Color(0xFFC1DFE3).withOpacity(.2), // Clear Skies for shadows
          spreadRadius: 2,
          blurRadius: 10,
        )
      ],
    ),
    child: ListTile(
      title: Text(title),
      subtitle: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Add your $title",
          hintStyle: TextStyle(color: Colors.grey), // Subdued text color
        ),
      ),
      leading: Icon(iconData, color: Color(0xFF548749)), // English Ivy for icons
      trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
    ),
  );
}
