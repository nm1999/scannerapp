import 'package:blinkid_flutter/blinkid_flutter.dart';
import 'package:flutter/material.dart';

class BlinkScan extends StatefulWidget {
  const BlinkScan({super.key});

  @override
  State<BlinkScan> createState() => _BlinkScanState();
}

class _BlinkScanState extends State<BlinkScan> {
  Future<void> scanDocument() async {
    // Replace with your actual license keys
    final license = License(
      androidLicense:
          'sRwCABZjb20uZXhhbXBsZS5zY2FubmVyYXBwAGxleUpEY21WaGRHVmtUMjRpT2pFM05UY3dNRGMzTnpJeE1qVXNJa055WldGMFpXUkdiM0lpT2lKa05qRXlOelkwTWkxak5UYzJMVFJrTkdFdE9USXpaUzAxTXpBNU5EbGpaVGczWVdVaWZRPT1aX1PZBlMQlrVX8J/ogFBDnP8lzaDmCyYwfJjujWCAhAim7U4BVUuFfBZymoDMFMlvc1UXOhmXtnzValFZOKD29ESGNSWF3d2c1Yh/M00MfGV5id9tGvFCxnE8d0o=',
    );

    // Create the BlinkID recognizer
    final recognizer = BlinkIdCombinedRecognizer();

    try {
      // Start the scanning session
      final result = await BlinkIdFlutter.scan(recognizer, license);

      // Check the result status
      if (result.resultStatus == BlinkIdResultStatus.success) {
        // Access the extracted data
        final blinkIdResult = result.result;
        print('Scan successful!');
        print('First Name: ${blinkIdResult.firstName}');
        print('Last Name: ${blinkIdResult.lastName}');
        print(
          'Date of Birth: ${blinkIdResult.dateOfBirth.day}/${blinkIdResult.dateOfBirth.month}/${blinkIdResult.dateOfBirth.year}',
        );

        // You can also get face and document images
        final faceImage = blinkIdResult.faceImage;
        // ...
      } else {
        print('Scan was canceled or failed.');
      }
    } on Exception catch (e) {
      print('Scanning error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Scan document')),
        body: ListView(
          children: [
            SizedBox(height: 50),
            Text(
              "To scan the id , consider clicking the scan now button to initialize the sdk",
            ),
            SizedBox(height: 20),
            Text("Scan Now"),
            TextButton(
              onPressed: () {
                scanDocument();
              },
              child: Text("Scan Now"),
            ),
          ],
        ),
      ),
    );
  }
}
