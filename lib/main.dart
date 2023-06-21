import 'package:flutter/material.dart';
import 'package:pdf_download_preview/screens/Pdf_download.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Pdf_download(),
    );
  }
}