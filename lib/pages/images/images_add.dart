import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../shared/loading.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key});

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  List<File>? _files;
  bool _isLoading = false; // Add this line

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _nameController.dispose();
    super.dispose();
  }

  Future<void> uploadPhoto() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        String result = await PhotoService().uploadToStorage(
          name: _nameController.text,
          files: _files!,
        );
        setState(() {
          _isLoading = false;
        });
        if (result == 'File uploaded successfully.') {
          // Show success dialog
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Your photo has been successfully uploaded.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      // Navigate to '/fotos' page when 'Close' is pressed
                      Navigator.pop(context, '/fotos');
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Show error dialog
          // ignore: use_build_context_synchronously
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(result), // Display the error message
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                );
              });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error en el formulario'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error en el formulario'),
        ),
      );
    }
  }

  Future<List<File>?> selectPhoto() async {
    try {
      var files = await PhotoService().pickImageHD();
      return files;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: _isLoading
        ? AppBar(
          title: const Text(
            'loading',
            style: TextStyle(color: Colors.white),
            
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[900],
        ) : AppBar(title: const Text('añardir fotos',style: TextStyle(color: Colors.white),),backgroundColor: Colors.green[700],
        ),
        body: _isLoading
            ? const Loading() // Add this line

            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: _files != null
                            ? Image.file(_files![0])
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: 'Photo Name',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor un nombre para la foto';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        var files = await selectPhoto();
                        if (files != null) {
                          setState(() {
                            _files = files;
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: const Text(
                          'Selecciona Foto',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => uploadPhoto(),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: const Text(
                          'Subir Foto',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
