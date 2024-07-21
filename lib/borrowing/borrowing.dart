import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perpusapimobile/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BorrowedBooksPage extends StatefulWidget {
  @override
  _BorrowedBooksPageState createState() => _BorrowedBooksPageState();
}

class _BorrowedBooksPageState extends State<BorrowedBooksPage> {
  late Future<List<dynamic>> _borrowedBooksFuture;

  @override
  void initState() {
    super.initState();
    _borrowedBooksFuture = _fetchBorrowedBooks();
  }

  Future<List<dynamic>> _fetchBorrowedBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }
    return ApiService.fetchBorrowedBooks(token);
  }

  Future<void> _returnBook(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      try {
        var response = await ApiService.returnBook(token, id);
        if (response.containsKey('success')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Buku berhasil dikembalikan')),
          );
          setState(() {
            _borrowedBooksFuture = _fetchBorrowedBooks();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal mengembalikan buku: ${response['error']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  Future<void> _cancelBorrow(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      try {
        var response = await ApiService.cancelBorrow(token, id);
        if (response.containsKey('success')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Peminjaman berhasil dibatalkan')),
          );
          setState(() {
            _borrowedBooksFuture = _fetchBorrowedBooks();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal membatalkan peminjaman: ${response['error']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowed Books'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _borrowedBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No borrowed books found'));
          } else {
            final borrowedBooks = snapshot.data!;
            return ListView.builder(
              itemCount: borrowedBooks.length,
              itemBuilder: (context, index) {
                final book = borrowedBooks[index]['bukus'];
                final user = borrowedBooks[index]['userss'];
                final pengajuan = borrowedBooks[index]['pengajuan'];
                final tanggalPeminjaman =
                    borrowedBooks[index]['tangal_peminjaman'];
                final tanggalPengembalian =
                    borrowedBooks[index]['tanggal_pengembalian'];
                final status = borrowedBooks[index]['status'];
                final bookId = borrowedBooks[index]['id'].toString();

                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                   color: Colors.blueGrey,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Judul buku: ${book['judul']}'),
                        subtitle: Text('Peminjam: ${user['name']}', style: TextStyle(color: Colors.white),),
                      ),
                      SizedBox(height: 8),
                      Text('Pengajuan: $pengajuan'),
                      Text('Tanggal Peminjaman: $tanggalPeminjaman'),
                      Text('Tanggal Pengembalian: $tanggalPengembalian'),
                      Text('Status: $status'),
                      SizedBox(height: 8),
                      if (status == 'disetujui')
                        GestureDetector(
                          onTap: () => _returnBook(bookId),
                          child: Container(
                            height: 38,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Kembalikan',
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      if (status == 'pengajuan')
                        GestureDetector(
                          onTap: () => _cancelBorrow(bookId),
                          child: Container(
                            height: 38,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Batalkan',
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
