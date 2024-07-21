//gak kepake

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class BukuService {
//   final String baseUrl = "http://127.0.0.1:8000/api";

//   Future<List<Buku>> fetchBukus(String token) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/buku'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body)['buku'];
//       return jsonResponse.map((data) => Buku.fromJson(data)).toList();
//     } else {
//       throw Exception('Failed to load bukus');
//     }
//   }

//   Future<Buku> fetchBukuById(String id, String token) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/buku/$id'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       return Buku.fromJson(json.decode(response.body)['buku']);
//     } else {
//       throw Exception('Failed to load buku');
//     }
//   }
// }

// class Buku {
//   final int id;
//   final String judul;
//   final String pengarang;
//   final String penerbit;
//   final String tahunTerbit;

//   Buku({required this.id, required this.judul, required this.pengarang, required this.penerbit, required this.tahunTerbit});

//   factory Buku.fromJson(Map<String, dynamic> json) {
//     return Buku(
//       id: json['id'],
//       judul: json['judul'],
//       pengarang: json['pengarang'],
//       penerbit: json['penerbit'],
//       tahunTerbit: json['tahun_terbit'],
//     );
//   }
// }
