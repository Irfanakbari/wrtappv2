import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogPage extends StatelessWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Log'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Versi 2.6.1',
                  style: GoogleFonts.roboto(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('- Migrasi ke API', style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Support Android 12',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text('- View More Project & Latest Update',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Perbaikan performa search',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Image Quality (Low, Med, High)',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Perbaikan bug judul hilang di homepage',
                  style: GoogleFonts.roboto(fontSize: 18)),
              const SizedBox(height: 20),
              Text('Versi 2.5',
                  style: GoogleFonts.roboto(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                  '- Penambahan sistem cache gambar untuk menghemat kuota disebabkan load gambar berulang',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Perbaikan performa load data',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Perbaikan fitur history read',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Perbaikan login disqus',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Genre List', style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Zoom Gambar', style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Komik List', style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Fitur Report Chapter',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Fitur Lapor bug/saran',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text('- Prev/next Chapter di halaman baca',
                  style: GoogleFonts.roboto(fontSize: 18)),
              const SizedBox(height: 20),
              Text('Versi 2.0',
                  style: GoogleFonts.roboto(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('- First Rilis versi 2.0',
                  style: GoogleFonts.roboto(fontSize: 18)),
              Text(
                  '- Beberapa tambahan fitur dan tampilan dari versi sebelumnya',
                  style: GoogleFonts.roboto(fontSize: 18)),
            ],
          ),
        ));
  }
}
