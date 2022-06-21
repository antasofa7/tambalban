import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:tambal_ban/cubit/place_cubit.dart';
import 'package:tambal_ban/model/place_model.dart';
import 'package:tambal_ban/theme.dart';

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

  File? image;
  final picker = ImagePicker();

  Future _openCamera() async {
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage.path);
        });
      }
    } catch (e) {
      print('error: $e');
    }
  }

  Future _openGalley() async {
    final imageGallery = await picker.pickImage(source: ImageSource.gallery);
    if (imageGallery != null) {
      setState(() {
        image = File(imageGallery.path);
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
                    child: image != null
                        ? Image.file(
                            image!,
                            height: 170.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            semanticLabel: 'Foto tambal ban',
                          )
                        : Image.asset(
                            'assets/image-default.png',
                            height: 170.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            semanticLabel: 'Foto default',
                          ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 170.0,
                    padding: EdgeInsets.symmetric(
                        vertical: 65.0,
                        horizontal:
                            (MediaQuery.of(context).size.width / 2) - 70.0),
                    decoration: BoxDecoration(
                      color: whiteColor.withOpacity(0.3),
                    ),
                    child: TextButton(
                      child: Text(
                        'Pilih Gambar',
                        style: whiteTextStyle.copyWith(fontSize: 12.0),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: greenColor,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((builder) {
                              return Container(
                                height: 180.0,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Pilih Gambar',
                                      style: grayTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                    const Divider(),
                                    MaterialButton(
                                      onPressed: () {
                                        _openCamera();
                                      },
                                      height: 40.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt_outlined,
                                            color: greenColor,
                                          ),
                                          const SizedBox(
                                            width: 6.0,
                                          ),
                                          Text(
                                            'Buka Kamera',
                                            style: blackTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    MaterialButton(
                                      onPressed: () {
                                        _openGalley();
                                      },
                                      height: 40.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_outlined,
                                            color: greenColor,
                                          ),
                                          const SizedBox(
                                            width: 6.0,
                                          ),
                                          Text(
                                            'Ambil dari Galeri',
                                            style: blackTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
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
                    hintText: 'contoh: Tambal Ban Sentosa',
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
          margin: const EdgeInsets.only(bottom: 24.0),
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
                    CheckboxListTile(
                        title: Text(
                          'Tambal ban',
                          style: blackTextStyle.copyWith(fontSize: 14.0),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: isCheckedTambalBan,
                        activeColor: greenColor,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedTambalBan = value!;
                          });
                        }),
                    CheckboxListTile(
                        title: Text(
                          'Isi angin',
                          style: blackTextStyle.copyWith(fontSize: 14.0),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: isCheckedIsiAngin,
                        activeColor: greenColor,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedIsiAngin = value!;
                          });
                        }),
                    CheckboxListTile(
                        title: Text(
                          'Ganti ban',
                          style: blackTextStyle.copyWith(fontSize: 14.0),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: isCheckedGantiBan,
                        activeColor: greenColor,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedGantiBan = value!;
                          });
                        }),
                  ],
                ),
              ),
            ],
          ));
    }

    Widget buttonSave() {
      return BlocConsumer<PlaceCubit, PlaceState>(
        listener: (context, state) {
          if (state is PlaceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: greenColor,
                content: Text(
                  'Data berhasil disimpan!',
                  style: whiteTextStyle,
                )));
            Navigator.pushNamedAndRemoveUntil(
                context, '/started', (route) => false);
          } else if (state is PlaceFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  state.error,
                  style: whiteTextStyle,
                )));
          }
        },
        builder: (context, state) {
          if (state is PlaceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return MaterialButton(
            color: greenColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 0,
            height: 50.0,
            onPressed: () async {
              DateFormat dateFormat = DateFormat('yyyyMMddHHmmss');
              final String date = dateFormat.format(DateTime.now());
              final String fileName = basename(image!.path);
              try {
                PlaceModel place = PlaceModel(
                  id: date,
                  name: nameController.text,
                  address: addressController.text,
                  openTime: openTimeController.text,
                  latitude: double.parse(latitudeController.text),
                  longitude: double.parse(longitudeController.text),
                  isTambalBan: isCheckedTambalBan,
                  isIsiAngin: isCheckedIsiAngin,
                  isGantiBan: isCheckedGantiBan,
                );
                context.read<PlaceCubit>().createPlace(place, image, fileName);
              } catch (err) {
                print(err);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.save_outlined,
                  color: whiteColor,
                ),
                const SizedBox(
                  width: 6.0,
                ),
                Text(
                  'Tambah Data',
                  style: whiteTextStyle.copyWith(fontSize: 16.0),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              backgroundColor: greenColor,
              elevation: 0,
              floating: true,
              title: Text(
                'Tambah Data Tambal Ban',
                style: whiteTextStyle.copyWith(fontSize: 16.0),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
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
              ),
            ),
          ]),
        ));
  }
}
