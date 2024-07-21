import 'package:flutter/material.dart';
import 'package:perpusapimobile/book/book_list_page.dart';
import 'package:perpusapimobile/borrowing/borrowing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0; // Default selected index
  String? _token; // Token from SharedPreferences
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
    });
  }

  // List of pages corresponding to each bottom navigation item
  final List<Widget> _pages = [
    BookListPage(),
    BorrowedBooksPage()
    // Replace with your actual home page widget
    // Other pages like SearchView, FavoritePage, and NotificationScreen
  ];

  // Function to handle tapping on bottom navigation items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
      _pageController.jumpToPage(index); // Navigate to the corresponding page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Borrowing',
          ),
         
        ],
        currentIndex: _selectedIndex, // Current selected index
        selectedItemColor: Colors.red, // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        onTap: _onItemTapped, // Function to handle item tap
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
