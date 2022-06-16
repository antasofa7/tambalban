import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tambal_ban/theme.dart';
import 'package:image_picker/image_picker.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({Key? key}) : super(key: key);

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  Position? position;
  bool isLoading = false;
  bool isCheckedTambalBan = false;
  bool isCheckedIsiAngin = false;
  bool isCheckedGantiBan = false;
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController addressController =
      TextEditingController(text: '');
  final TextEditingController openTimeController =
      TextEditingController(text: '');
  final TextEditingController latitudeController =
      TextEditingController(text: '');
  final TextEditingController longitudeController =
      TextEditingController(text: '');

  void getLocation() async {
    setState(() {
      isLoading = true;
    });
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitudeController.text = position!.latitude.toString();
      longitudeController.text = position!.longitude.toString();
      isLoading = false;
    });
  }

  File? _image;
  final _picker = ImagePicker();

  Future _openCamera() async {
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    } catch (e) {
      print('error: $e');
    }
  }

  Future _openGalley() async {
    final imageGallery = await _picker.pickImage(source: ImageSource.gallery);
    if (imageGallery != null) {
      setState(() {
        _image = File(imageGallery.path);
        print('image: $_image');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget chooseImage() {
      return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Foto', style: blackTextStyle),
              const SizedBox(
                height: 6.0,
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            height: 150.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/image-default.png',
                            height: 150.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 150.0,
                    padding: EdgeInsets.symmetric(
                        vertical: 55.0,
                        horizontal:
                            (MediaQuery.of(context).size.width / 2) - 50.0),
                    decoration: BoxDecoration(
                      color: whiteColor.withOpacity(0.3),
                    ),
                    child: TextButton(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: whiteColor,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: greenColor,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((builder) {
                              return Container(
                                height: 140.0,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        _openCamera();
                                      },
                                      icon:
                                          const Icon(Icons.camera_alt_outlined),
                                      label: Text(
                                        'Buka Kamera',
                                        style: blackTextStyle,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        _openGalley();
                                      },
                                      icon: const Icon(Icons.image_outlined),
                                      label: Text(
                                        'Buka Galeri',
                                        style: blackTextStyle,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ));
    }

    Widget nameInput() {
      return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama', style: blackTextStyle),
              const SizedBox(
                height: 6.0,
              ),
              TextFormField(
                controller: nameController,
                style: blackTextStyle,
                decoration: InputDecoration(
                    hintText: 'contoh: Tambal Ban Tip-Top',
                    hintStyle: grayTextStyle.copyWith(
                        fontSize: 14.0, fontWeight: light),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(width: 1, color: grayColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(width: 1, color: greenColor)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0)),
              )
            ],
          ));
    }

    Widget addressInput() {
      return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alamat', style: blackTextStyle),
              const SizedBox(
                height: 6.0,
              ),
              TextFormField(
                controller: addressController,
                style: blackTextStyle,
                decoration: InputDecoration(
                    hintText: 'contoh: Jalan Jend. Sudirman',
                    hintStyle: grayTextStyle.copyWith(
                        fontSize: 14.0, fontWeight: light),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(width: 1, color: grayColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(width: 1, color: greenColor)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0)),
              )
            ],
          ));
    }

    Widget openTimeInput() {
      return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buka', style: blackTextStyle),
              const SizedBox(
                height: 6.0,
              ),
              TextFormField(
                controller: openTimeController,
                style: blackTextStyle,
                decoration: InputDecoration(
                    hintText: 'contoh: 09:00 - 17:00',
                    hintStyle: grayTextStyle.copyWith(
                        fontSize: 14.0, fontWeight: light),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(width: 1, color: grayColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(width: 1, color: greenColor)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0)),
              )
            ],
          ));
    }

    Widget locationInput() {
      return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lokasi', style: blackTextStyle),
              const SizedBox(
                height: 6.0,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Flexible(
                        flex: 3,
                        child: TextFormField(
                          controller: latitudeController,
                          keyboardType: TextInputType.number,
                          style: blackTextStyle,
                          decoration: InputDecoration(
                              hintText: 'Latitude',
                              hintStyle: grayTextStyle.copyWith(
                                  fontSize: 14.0, fontWeight: light),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      BorderSide(width: 1, color: grayColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      BorderSide(width: 1, color: greenColor)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0)),
                        )),
                    const SizedBox(
                      width: 6.0,
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        controller: longitudeController,
                        keyboardType: TextInputType.number,
                        style: blackTextStyle,
                        decoration: InputDecoration(
                            hintText: 'Longitude',
                            hintStyle: grayTextStyle.copyWith(
                                fontSize: 14.0, fontWeight: light),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(width: 1, color: grayColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(width: 1, color: greenColor)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0)),
                      ),
                    ),
                    const SizedBox(
                      width: 6.0,
                    ),
                    Flexible(
                        child: Container(
                      padding: isLoading
                          ? const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 6.0)
                          : const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: whiteColor,
                              strokeWidth: 2,
                            )
                          : IconButton(
                              onPressed: () {
                                getLocation();
                              },
                              icon: const Icon(Icons.location_on_outlined),
                              color: whiteColor),
                    ))
                  ],
                ),
              ),
            ],
          ));
    }

    Widget serviceInput() {
      return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Layanan', style: blackTextStyle),
              const SizedBox(
                height: 6.0,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: grayColor),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: isCheckedTambalBan,
                            activeColor: greenColor,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedTambalBan = value!;
                              });
                            }),
                        Text(
                          'Tambal ban',
                          style: blackTextStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: isCheckedIsiAngin,
                            activeColor: greenColor,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedIsiAngin = value!;
                              });
                            }),
                        Text(
                          'Isi angin',
                          style: blackTextStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: isCheckedGantiBan,
                            activeColor: greenColor,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedGantiBan = value!;
                              });
                            }),
                        Text(
                          'Ganti ban',
                          style: blackTextStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ));
    }

    Widget buttonSave() {
      return MaterialButton(
        color: greenColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 0,
        height: 50.0,
        onPressed: () {},
        child: Text(
          'Tambah Data',
          style: whiteTextStyle.copyWith(fontSize: 16.0),
        ),
      );
    }

    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: greenColor,
          elevation: 0,
          title: Text(
            'Tambah Tempat Tambal Ban',
            style: whiteTextStyle.copyWith(fontSize: 16.0),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: ListView(
            children: [
              const SizedBox(
                height: 24.0,
              ),
              chooseImage(),
              nameInput(),
              addressInput(),
              openTimeInput(),
              locationInput(),
              serviceInput(),
              buttonSave(),
              const SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ));
  }
}
