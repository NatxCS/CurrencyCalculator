import 'package:flutter/material.dart';
import 'screens/converter_screen.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 3, right: 3),
              color: Colors.grey[400],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TopButton(
                      pageController: _pageController,
                      currentIndex: _currentIndex,
                      pageNumber: 0,
                      title: 'Converter',
                    ),
                  ),
                  Expanded(
                    child: TopButton(
                      pageController: _pageController,
                      currentIndex: _currentIndex,
                      pageNumber: 1,
                      title: 'Calculator',
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: const [
                  Converter(),
                  Calculator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopButton extends StatelessWidget {
  const TopButton({
    super.key,
    required PageController pageController,
    required int currentIndex,
    required int pageNumber,
    required String title,
  })  : _pageController = pageController,
        _currentIndex = currentIndex,
        _pageNumber = pageNumber,
        _title = title;

  final PageController _pageController;
  final int _currentIndex;
  final int _pageNumber;
  final String _title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _pageController.animateToPage(_pageNumber,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      },
      style: ButtonStyle(
        overlayColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.green.withOpacity(
                0.2);
          }
          return Colors.transparent;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                5),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return _currentIndex == _pageNumber ? Colors.green : Colors.white;
          },
        ),

      ),
      child: Text(
        _title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: _currentIndex == _pageNumber
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }
}
