import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CertificateViewer extends StatelessWidget {
  final String? url;
  final File? file;
  final Uint8List? bytes;

  const CertificateViewer({super.key, this.url, this.file, this.bytes});

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (file != null) {
      image = Image.file(file!);
    } else if (bytes != null) {
      image = Image.memory(bytes!);
    } else {
      image = Image.network(url!);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Certificate", style: TextStyle(color: Colors.white)),
      ),
      body: Center(child: InteractiveViewer(child: image)),
    );
  }
}
