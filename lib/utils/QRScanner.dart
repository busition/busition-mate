import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR코드 스캔"),
      ),
      body: Stack(
        children: [
          QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          Frame(),
          Column(
            children: [
              (result != null) ? Text(result!.code!) : Text("no data")
            ],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  Widget Frame() {
    return Stack(
      children: [

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 200,
          // 조정 가능
          child: Container(color: Colors.black.withOpacity(0.7)),
        ),

        // 아래쪽 어두운 영역
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 200,
          // 조정 가능
          child: Container(color: Colors.black.withOpacity(0.7)),
        ),

        // 왼쪽 어두운 영역
        Positioned(
          top: 200,
          // 조정 가능
          bottom: 200,
          // 조정 가능
          left: 0,
          width: 50,
          // 조정 가능
          child: Container(color: Colors.black.withOpacity(0.7)),
        ),

        // 오른쪽 어두운 영역
        Positioned(
          top: 200,
          // 조정 가능
          bottom: 200,
          // 조정 가능
          right: 0,
          width: 50,
          // 조정 가능
          child: Container(color: Colors.black.withOpacity(0.7)),
        ),

        // 중앙의 테두리 (선택사항)
        Positioned(
          top: 200,
          // 조정 가능
          bottom: 200,
          // 조정 가능
          left: 50,
          // 조정 가능
          right: 50,
          // 조정 가능
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
