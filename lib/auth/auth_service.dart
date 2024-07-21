//Gak kepake

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AuthService {
//   final String baseUrl = 'http://127.0.0.1:8000/api';

//   Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/register'),
//       body: {
//         'name': name,
//         'email': email,
//         'password': password,
//         'password_confirmation': passwordConfirmation,
//       },
//     );

//     return json.decode(response.body);
//   }
// }
