import 'package:flutter/material.dart';
import 'package:belajarflutter/model/lokasi.dart';
import 'package:belajarflutter/viewmodel/weather_viewmodel.dart';
import 'package:belajarflutter/widget/message_view.dart';

class SearchPage extends StatefulWidget {
  final WeatherViewModel viewModel;
  final VoidCallback onLokasiDipilih;

  const SearchPage({
    Key? key,
    required this.viewModel,
    required this.onLokasiDipilih,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  void _cari(String kataKunci) {
    FocusScope.of(context).unfocus();
    widget.viewModel.cariLokasi(kataKunci);
  }

  void _pilih(Lokasi lokasi) {
    FocusScope.of(context).unfocus();
    widget.viewModel.pilihLokasi(lokasi);
    widget.onLokasiDipilih();
  }

  Future<void> _toggleFavorit(Lokasi lokasi) async {
    String nama = lokasi.nama ?? 'Lokasi';
    bool ditambahkan = await widget.viewModel.toggleFavorit(lokasi);
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
      appBar: AppBar(title: const Text('Cari Lokasi')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _cari,
                  onChanged: (value) {
                    if (value.isEmpty) vm.resetPencarian();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama kota...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                              vm.resetPencarian();
                              setState(() {});
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                  ),
                ),
              ),
              Expanded(child: _buildContent(vm)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(WeatherViewModel vm) {
    if (vm.statusCari == StatusData.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.statusCari == StatusData.error) {
      return MessageView(
        icon: Icons.cloud_off,
        pesan: vm.pesanCari,
        labelTombol: 'Coba Lagi',
        onTombol: () {
          _cari(_controller.text);
        },
      );
    }

    if (vm.statusCari == StatusData.empty) {
      return MessageView(
        icon: Icons.location_off,
        pesan: 'Lokasi "${_controller.text.trim()}" tidak ditemukan. Coba kata kunci lain.',
      );
    }

    if (vm.statusCari == StatusData.success) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: vm.hasilPencarian.length,
        itemBuilder: (context, i) {
          return _itemLokasi(vm, vm.hasilPencarian[i]);
        },
      );
    }

    return _buildFavoritRiwayat(vm);
  }

  Widget _buildFavoritRiwayat(WeatherViewModel vm) {
    if (vm.favorit.isEmpty && vm.riwayat.isEmpty) {
      return const MessageView(
        icon: Icons.travel_explore,
        pesan: 'Cari nama kota untuk melihat informasi cuacanya.',
      );
    }

    final TextStyle? styleJudul = Theme.of(context).textTheme.titleMedium;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      children: [
        if (vm.favorit.isNotEmpty) ...[
          Text('Lokasi Favorit', style: styleJudul),
          const SizedBox(height: 8.0),
          for (Lokasi lokasi in vm.favorit) _itemLokasi(vm, lokasi),
          const SizedBox(height: 16.0),
        ],
        if (vm.riwayat.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Riwayat Pencarian', style: styleJudul),
              TextButton(
                onPressed: () {
                  vm.hapusSemuaRiwayat();
                },
                child: const Text('Hapus Semua'),
              ),
            ],
          ),
          for (String kata in vm.riwayat)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history),
              title: Text(kata),
              trailing: IconButton(
                tooltip: 'Hapus',
                icon: const Icon(Icons.close),
                onPressed: () {
                  vm.hapusRiwayat(kata);
                },
              ),
              onTap: () {
                _controller.text = kata;
                _cari(kata);
              },
            ),
        ],
      ],
    );
  }

  Widget _itemLokasi(WeatherViewModel vm, Lokasi lokasi) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined),
        title: Text(lokasi.nama ?? '-'),
        subtitle: lokasi.detail.isEmpty ? null : Text(lokasi.detail),
        trailing: IconButton(
          tooltip: 'Favorit',
          icon: Icon(vm.isFavorit(lokasi) ? Icons.star : Icons.star_border),
          onPressed: () {
            _toggleFavorit(lokasi);
          },
        ),
        onTap: () {
          _pilih(lokasi);
        },
      ),
    );
  }
}