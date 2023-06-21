import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

final pdfUrl = "http://www.pdf995.com/samples/pdf.pdf";

var dio = Dio();

class Pdf_download extends StatefulWidget {
  @override
  _Pdf_downloadState createState() => _Pdf_downloadState();
}

class _Pdf_downloadState extends State<Pdf_download> {
  String pdf_file_path = '';

  Future<String> _findLocalPath() async {
    if (Platform.isAndroid) {
      return "/sdcard/download/PDF_Download_App/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}';
    }
  }

  void openPDF() {
    if (pdf_file_path.isEmpty != true) {
      Future.delayed(const Duration(seconds: 0), () async {
        final result = await OpenFile.open(pdf_file_path);
        print(result.message);
        print(result.type);
      });
    }
  }

  Future download_PDF_from_url(Dio dio, String url, String savePath) async {
    try {
      
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return (status ?? 0) < 500;
            }),
      );
      var finalPath = savePath + "newGeneratedFile.pdf";
      File file = File(finalPath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      print(savePath);
      await raf.close();
      setState(() {
        pdf_file_path = file.path.toString();
      });

      Fluttertoast.showToast(
        msg: "Pdf downloaded successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );


    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future<void> _pdfButtonClicked() async {
    var localPath = (await _findLocalPath());
    download_PDF_from_url(dio, pdfUrl, localPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Download"),
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(56, 56), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.orange, // button color
                  child: InkWell(
                    splashColor: Colors.grey,
                    onTap: () {
                      openPDF();
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.picture_as_pdf_sharp), // icon
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size(56, 56), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.red, // button color
                  child: InkWell(
                    splashColor: Colors.grey,
                    onTap: () {

                      _pdfButtonClicked();

                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.download), // icon
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
