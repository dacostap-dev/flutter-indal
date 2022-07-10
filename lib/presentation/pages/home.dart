import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/presentation/pages/promotions/promotions.dart';
import 'package:indal/presentation/pages/students/students.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final _pages = const [
    PromotionPage(),
    StudentsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectPage = ref.watch(currentPageProvider);

    return Scaffold(
      body: _pages[selectPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectPage,
        onTap: (index) {
          ref.read(currentPageProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Promociones',
            icon: Icon(Icons.school_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Alumnos',
            icon: Icon(Icons.people_alt_outlined),
          )
        ],
      ),
    );
  }
}
