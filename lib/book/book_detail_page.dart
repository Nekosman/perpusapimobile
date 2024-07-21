import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perpusapimobile/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetailPage extends StatelessWidget {
  final String bookId;

  BookDetailPage({required this.bookId});

  Future<Map<String, dynamic>> _fetchBookDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return ApiService.fetchBookDetails(token!, bookId);
  }

  Future<void> _borrowBook(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await ApiService.borrowBook(token!, bookId);

    if (response['success'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['success'])),
      );
    } else if (response['error'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchBookDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final book = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the image at the top
                  book['image_url'] != null && book['image_url'].isNotEmpty
                      ? AspectRatio(
                          aspectRatio: 1410 / 2250, // Maintain the aspect ratio
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              book['image_url'],
                              fit: BoxFit
                                  .contain, // Ensure the image is fully visible
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    'assets/images/placeholder.png');
                              },
                            ),
                          ),
                        )
                      : AspectRatio(
                          aspectRatio: 1410 / 2250,
                          child: Image.asset('assets/images/placeholder.png'),
                        ),
                  SizedBox(height: 20), // Space between image and text
                  Text('Title: ${book['judul']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Publisher: ${book['penerbit']['nama_penerbit']}'),
                  SizedBox(height: 10),
                  Text('Author: ${book['pengarang']['nama_penulis']}'),
                  SizedBox(height: 10),
                  Text('Year: ${book['tahun_terbit']}'),
                  SizedBox(height: 10),
                  Text('Category: ${book['kategori']['nama_kategori']}'),
                  SizedBox(height: 10),
                  Text('Stock: ${book['stock']}'),
                  SizedBox(height: 20), // Space between text and button
                  GestureDetector(
                    onTap: () => _borrowBook(context),
                    child: Container(
                      height: 38,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Borrow',
                          style: GoogleFonts.jetBrainsMono(
                          fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
