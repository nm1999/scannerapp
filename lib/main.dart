import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const NamePickerPage(),
    );
  }
}

class NamePickerPage extends StatefulWidget {
  const NamePickerPage({super.key});

  @override
  State<NamePickerPage> createState() => _NamePickerPageState();
}

class _NamePickerPageState extends State<NamePickerPage> {
  // State variables to hold the selected image and the extracted name.
  File? _pickedImage;
  String _extractedName = 'No name extracted yet.';
  bool _isProcessing = false;

  // Function to handle picking an image from the gallery or camera and processing it.
  Future<void> _pickImageAndProcess() async {
    setState(() {
      _isProcessing = true;
      _extractedName = 'Processing...';
    });

    try {
      // Step 1: Pick an image using ImagePicker.
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        _pickedImage = File(pickedFile.path);
      
      // Step 2: Use Google ML Kit for Text Recognition (OCR).
        final inputImage = InputImage.fromFile(_pickedImage!);
        final textRecognizer = TextRecognizer();
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
  
        String extractedText = '';
        for (TextBlock block in recognizedText.blocks) {
          for (TextLine line in block.lines) {
            extractedText += '${line.text} ';
          }
        }

      _extractedName = extractedText.trim().isNotEmpty
            ? 'Extracted Text:\n$extractedText'
             : 'No text found.';
      //
       await textRecognizer.close();
      } else {
        _extractedName = 'No image selected.';
      }
      
      // Placeholder logic for demonstration
      await Future.delayed(const Duration(seconds: 2));
      _extractedName = 'Jane Doe';
      
    } catch (e) {
      _extractedName = 'Error: $e';
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passport/ID Name Picker'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isProcessing ? null : _pickImageAndProcess,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 5,
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Pick Image from Gallery',
                      style: TextStyle(fontSize: 18.0),
                    ),
            ),
            const SizedBox(height: 20.0),
            if (_pickedImage != null)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _pickedImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            if (_pickedImage == null)
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Your image will appear here.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            const SizedBox(height: 20.0),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Extracted Name:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _extractedName,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
