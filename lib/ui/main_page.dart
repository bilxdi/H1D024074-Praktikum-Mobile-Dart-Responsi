import 'package:flutter/material.dart';
import 'package:belajarflutter/ui/search_page.dart';
import 'package:belajarflutter/ui/weather_page.dart';
import 'package:belajarflutter/viewmodel/weather_viewmodel.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final WeatherViewModel _viewModel = WeatherViewModel();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          WeatherPage(viewModel: _viewModel),
          SearchPage(
            viewModel: _viewModel,
            onLokasiDipilih: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny),
            label: 'Cuaca',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.saved_search),
            label: 'Lokasi',
          ),
        ],
      ),
    );
  }
}