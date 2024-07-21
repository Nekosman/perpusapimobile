import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<List<dynamic>> fetchBooks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buku'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['bukus'];
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<Map<String, dynamic>> fetchBookDetails(String token, String bookId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buku/$bookId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['buku'];
    } else {
      throw Exception('Failed to load book details');
    }
  }

  static Future<Map<String, dynamic>> borrowBook(String token, String bookId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/peminjaman/$bookId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

     static Future<List<dynamic>> fetchBorrowedBooks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/peminjamanUser'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load borrowed books');
    }
  }

  static Future<Map<String, dynamic>> returnBook(String token, String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/peminjaman/kembali/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> cancelBorrow(String token, String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/peminjaman/$id/batal'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }
}
