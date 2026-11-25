import 'package:flutter/material.dart';
import 'package:belajarflutter/helpers/weather_helper.dart';
import 'package:belajarflutter/model/cuaca.dart';
import 'package:belajarflutter/viewmodel/weather_viewmodel.dart';
import 'package:belajarflutter/widget/forecast_item.dart';
import 'package:belajarflutter/widget/info_tile.dart';
import 'package:belajarflutter/widget/message_view.dart';

class WeatherPage extends StatefulWidget {
  final WeatherViewModel viewModel;

  const WeatherPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _toggleFavorit() async {
    var vm = widget.viewModel;
    String nama = vm.lokasiTerpilih.nama ?? 'Lokasi';
    bool ditambahkan = await vm.toggleFavorit(vm.lokasiTerpilih);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ditambahkan
            ? '$nama ditambahkan ke favorit'
            : '$nama dihapus dari favorit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var vm = widget.viewModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca'),
        actions: [
          IconButton(
            tooltip: 'Favorit',
            icon: Icon(vm.isFavorit(vm.lokasiTerpilih)
                ? Icons.star
                : Icons.star_border),
            onPressed: () {
              _toggleFavorit();
            },
          ),
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.loadCuaca();
            },
          ),
        ],
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(WeatherViewModel vm) {
    if (vm.statusCuaca == StatusData.initial ||
        vm.statusCuaca == StatusData.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.statusCuaca == StatusData.error) {
      return MessageView(
        icon: Icons.cloud_off,
        pesan: vm.pesanCuaca,
        labelTombol: 'Coba Lagi',
        onTombol: () {
          vm.loadCuaca();
        },
      );
    }

    if (vm.statusCuaca == StatusData.empty || vm.dataCuaca == null) {
      return MessageView(
        icon: Icons.inbox_outlined,
        pesan: 'Data cuaca tidak tersedia untuk lokasi ini.',
        labelTombol: 'Muat Ulang',
        onTombol: () {
          vm.loadCuaca();
        },
      );
    }

    return _buildCuaca(vm);
  }

  Widget _buildCuaca(WeatherViewModel vm) {
    final DataCuaca data = vm.dataCuaca!;
    final CuacaSaatIni sekarang = data.saatIni!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Column(
                children: [
                  Text(
                    vm.lokasiTerpilih.nama ?? '-',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: colorScheme.onPrimaryContainer),
                  ),
                  if (vm.lokasiTerpilih.detail.isNotEmpty)
                    Text(
                      vm.lokasiTerpilih.detail,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onPrimaryContainer),
                    ),
                  const SizedBox(height: 16.0),
                  Icon(
                    WeatherHelper.ikon(sekarang.kodeCuaca),
                    size: 72.0,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  Text(
                    WeatherHelper.suhu(sekarang.suhu),
                    style: theme.textTheme.displayLarge
                        ?.copyWith(color: colorScheme.onPrimaryContainer),
                  ),
                  Text(
                    WeatherHelper.deskripsi(sekarang.kodeCuaca),
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Terasa seperti ${WeatherHelper.suhu(sekarang.suhuTerasa)}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            LayoutBuilder(
              builder: (context, constraints) {
                final double lebar = (constraints.maxWidth - 12.0) / 2;
                return Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: [
                    SizedBox(
                      width: lebar,
                      child: InfoTile(
                        icon: Icons.water_drop_outlined,
                        label: 'Kelembapan',
                        nilai: '${sekarang.kelembapan ?? '-'}%',
                      ),
                    ),
                    SizedBox(
                      width: lebar,
                      child: InfoTile(
                        icon: Icons.air,
                        label: 'Kecepatan Angin',
                        nilai: '${sekarang.kecepatanAngin ?? '-'} km/h',
                      ),
                    ),
                    SizedBox(
                      width: lebar,
                      child: InfoTile(
                        icon: Icons.umbrella,
                        label: 'Peluang Hujan',
                        nilai: '${data.peluangHujanHariIni ?? '-'}%',
                      ),
                    ),
                    SizedBox(
                      width: lebar,
                      child: InfoTile(
                        icon: Icons.opacity,
                        label: 'Curah Hujan',
                        nilai: '${sekarang.curahHujan ?? '-'} mm',
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24.0),
            Text(
              'Prakiraan ${data.harian.length} Hari',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            for (int i = 0; i < data.harian.length; i++)
              ForecastItem(prakiraan: data.harian[i], hariIni: i == 0),
          ],
        ),
      ),
    );
  }
}