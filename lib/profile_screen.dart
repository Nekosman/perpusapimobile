import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? userId = prefs.getInt('user_id'); // Assuming you save user_id in SharedPreferences

    if (token != null && userId != null) {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _name = data['user']['name'];
          _email = data['user']['email'];
        });
      } else {
        setState(() {
          _name = 'Unknown';
          _email = 'Unknown';
        });
      }
    } else {
      setState(() {
        _name = 'Unknown';
        _email = 'Unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/profile_placeholder.png') // Ganti dengan path gambar profil Anda
              ),
              SizedBox(height: 20),
              Text(
                'HAI! $_name',
                style: GoogleFonts.jetBrainsMono(
                            fontSize: 15, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Text(
                '$_email',
                style: GoogleFonts.jetBrainsMono(
                            fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
