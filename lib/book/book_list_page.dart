import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perpusapimobile/api_service.dart';
import 'package:perpusapimobile/auth/login_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:perpusapimobile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'book_detail_page.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late Future<List<dynamic>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _fetchBooks();
  }

  Future<List<dynamic>> _fetchBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return ApiService.fetchBooks(token!);
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final books = snapshot.data!;
            return Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 10 / 9,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    viewportFraction: 0.8,
                  ),
                  items: books.map((book) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(book['image_url']),
                              fit: BoxFit.cover,
                             
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 10,),
                Text('BOOK LIST', style:  GoogleFonts.jetBrainsMono(
                            fontSize: 20, fontWeight: FontWeight.w500),),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of columns
                      childAspectRatio: 1410 / 2250, // Maintain the aspect ratio
                      crossAxisSpacing: 10, // Space between columns
                      mainAxisSpacing: 10, // Space between rows
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailPage(bookId: books[index]['id'].toString()),
                            ),
                          );
                        },
                        child: GridTile(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              books[index]['image_url'],
                              fit: BoxFit.cover, // Ensure the image covers the grid item
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/placeholder.png');
                              },
                            ),
                          ),
                          footer: GridTileBar(
                            backgroundColor: Colors.black54,
                            title: Text(
                              books[index]['judul'],
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: Text(
                              'By ${books[index]['pengarang']['nama_penulis']}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}


