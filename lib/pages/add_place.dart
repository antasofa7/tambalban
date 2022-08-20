import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:tambal_ban/cubit/connected_cubit.dart';
import 'package:tambal_ban/cubit/place_cubit.dart';
import 'package:tambal_ban/model/place_model.dart';
import 'package:tambal_ban/theme.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({Key? key}) : super(key: key);

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  bool isLoading = false;
  bool isCheckedTubeless = false;
  bool isCheckedNitrogen = false;
  bool isCheckedGantiBan = false;
  String helperTextImage = '';
  String helperTextName = '';
  String helperTextAddress = '';
  String helperTextOpenTime = '';
  String helperTextPhoneNumber = '';
  String helperTextLatitude = '';
  String helperTextLongitude = '';
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController addressController =
      TextEditingController(text: '');
  final TextEditingController openTimeController =
      TextEditingController(text: '');
  final TextEditingController phoneNumberController =
      TextEditingController(text: '');
  final TextEditingController latitudeController =
      TextEditingController(text: '');
  final TextEditingController longitudeController =
      TextEditingController(text: '');
  Position? position;

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
      helperTextLatitude = '';
      helperTextLongitude = '';
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
          helperTextImage = '';
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
        helperTextImage = '';
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
              Text('Foto Lokasi', style: blackTextStyle),
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
                                        Navigator.pop(context);
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
                                        Navigator.pop(context);
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
              const SizedBox(
                height: 4.0,
              ),
              helperTextImage.isNotEmpty
                  ? Text(helperTextImage,
                      style: blackTextStyle.copyWith(
                          color: Colors.red, fontSize: 12.0))
                  : const SizedBox(),
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
                cursorColor: greenColor,
                textCapitalization: TextCapitalization.words,
                onChanged: (text) => setState(() {
                  helperTextName = '';
                }),
                toolbarOptions: const ToolbarOptions(
                    copy: true, cut: true, paste: true, selectAll: true),
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
              ),
              const SizedBox(
                height: 4.0,
              ),
              helperTextName.isNotEmpty
                  ? Text(helperTextName,
                      style: blackTextStyle.copyWith(
                          color: Colors.red, fontSize: 12.0))
                  : const SizedBox(),
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
                cursorColor: greenColor,
                textCapitalization: TextCapitalization.words,
                onChanged: (text) => setState(() {
                  helperTextAddress = '';
                }),
                toolbarOptions: const ToolbarOptions(
                    copy: true, cut: true, paste: true, selectAll: true),
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
              ),
              const SizedBox(
                height: 4.0,
              ),
              helperTextAddress.isNotEmpty
                  ? Text(helperTextAddress,
                      style: blackTextStyle.copyWith(
                          color: Colors.red, fontSize: 12.0))
                  : const SizedBox(),
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
                cursorColor: greenColor,
                onChanged: (text) => setState(() {
                  helperTextOpenTime = '';
                }),
                toolbarOptions: const ToolbarOptions(
                    copy: true, cut: true, paste: true, selectAll: true),
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
              ),
              const SizedBox(
                height: 4.0,
              ),
              helperTextOpenTime.isNotEmpty
                  ? Text(helperTextOpenTime,
                      style: blackTextStyle.copyWith(
                          color: Colors.red, fontSize: 12.0))
                  : const SizedBox(),
            ],
          ));
    }

    Widget phoneNumberInput() {
      return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nomer WhatsApp', style: blackTextStyle),
              const SizedBox(
                height: 6.0,
              ),
              TextFormField(
                controller: phoneNumberController,
                style: blackTextStyle,
                cursorColor: greenColor,
                onChanged: (text) => setState(() {
                  helperTextPhoneNumber = '';
                }),
                keyboardType: TextInputType.phone,
                toolbarOptions: const ToolbarOptions(
                    copy: true, cut: true, paste: true, selectAll: true),
                decoration: InputDecoration(
                    hintText: 'contoh: +62813xxx',
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
              ),
              const SizedBox(
                height: 4.0,
              ),
              helperTextPhoneNumber.isNotEmpty
                  ? Text(helperTextPhoneNumber,
                      style: blackTextStyle.copyWith(
                          color: Colors.red, fontSize: 12.0))
                  : const SizedBox(),
            ],
          ));
    }

    Widget locationInput() {
      return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lokasi/Koordinat', style: blackTextStyle),
              const SizedBox(
                height: 6.0,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: latitudeController,
                              keyboardType: TextInputType.number,
                              cursorColor: greenColor,
                              onChanged: (text) => setState(() {
                                helperTextLatitude = '';
                              }),
                              toolbarOptions: const ToolbarOptions(
                                  copy: true,
                                  cut: true,
                                  paste: true,
                                  selectAll: true),
                              style: blackTextStyle,
                              decoration: InputDecoration(
                                  hintText: 'Latitude',
                                  hintStyle: grayTextStyle.copyWith(
                                      fontSize: 14.0, fontWeight: light),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          width: 1, color: grayColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          width: 1, color: greenColor)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0)),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            helperTextLatitude.isNotEmpty
                                ? Text(helperTextLatitude,
                                    style: blackTextStyle.copyWith(
                                        color: Colors.red, fontSize: 12.0))
                                : const SizedBox(),
                          ],
                        )),
                    const SizedBox(
                      width: 6.0,
                    ),
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: longitudeController,
                            keyboardType: TextInputType.number,
                            cursorColor: greenColor,
                            onChanged: (text) => setState(() {
                              helperTextLongitude = '';
                            }),
                            toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true),
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
                                    borderSide: BorderSide(
                                        width: 1, color: greenColor)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10.0)),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          helperTextLongitude.isNotEmpty
                              ? Text(helperTextLongitude,
                                  style: blackTextStyle.copyWith(
                                      color: Colors.red, fontSize: 12.0))
                              : const SizedBox(),
                        ],
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
              Text('Layanan lain', style: blackTextStyle),
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
                          'Tubeless',
                          style: blackTextStyle.copyWith(fontSize: 14.0),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: isCheckedTubeless,
                        activeColor: greenColor,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedTubeless = value!;
                          });
                        }),
                    CheckboxListTile(
                        title: Text(
                          'Nitrogen',
                          style: blackTextStyle.copyWith(fontSize: 14.0),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: isCheckedNitrogen,
                        activeColor: greenColor,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedNitrogen = value!;
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
              String imagePath = image?.path ?? '';
              if (imagePath == '') {
                setState(() {
                  helperTextImage = 'Foto lokasi harus diisi!';
                });
              }
              if (nameController.text.isEmpty) {
                setState(() {
                  helperTextName = 'Nama harus diisi!';
                });
              }
              if (addressController.text.isEmpty) {
                setState(() {
                  helperTextAddress = 'Alamat harus diisi!';
                });
              }
              if (openTimeController.text.isEmpty) {
                setState(() {
                  helperTextOpenTime = 'Jam buka harus diisi!';
                });
              }
              if (phoneNumberController.text.isEmpty) {
                setState(() {
                  helperTextPhoneNumber =
                      'Nomer WhatsApp boleh bisa diisi "-"!';
                });
              }
              if (latitudeController.text.isEmpty) {
                setState(() {
                  helperTextLatitude = 'Latitude harus diisi!';
                });
              }
              if (longitudeController.text.isEmpty) {
                setState(() {
                  helperTextLongitude = 'Longitude harus diisi!';
                });
              }
              final String id =
                  DateTime.now().microsecondsSinceEpoch.toString();
              final String fileName = basename(image!.path);
              String fullName = '';
              String prefixName = nameController.text.substring(1, 6);
              if (prefixName.toLowerCase() != 'tambal') {
                fullName = 'Tambal Ban ${nameController.text}';
              }
              try {
                PlaceModel place = PlaceModel(
                  id: id,
                  name: fullName,
                  address: addressController.text,
                  openTime: openTimeController.text,
                  phoneNumber: phoneNumberController.text,
                  latitude: double.parse(latitudeController.text),
                  longitude: double.parse(longitudeController.text),
                  tubeless: isCheckedTubeless,
                  nitrogen: isCheckedNitrogen,
                  gantiBan: isCheckedGantiBan,
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
        body: BlocBuilder<ConnectedCubit, ConnectedState>(
            builder: (context, state) {
          if ((state is ConnectedSuccess &&
                  state.connectionType == ConnectionType.wifi) ||
              (state is ConnectedSuccess &&
                  state.connectionType == ConnectionType.mobile)) {
            return CustomScrollView(slivers: [
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
                      phoneNumberInput(),
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
            ]);
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Internet tidak terhubung',
                style: blackTextStyle,
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextButton(
                  onPressed: () {
                    context
                        .read<ConnectedCubit>()
                        .connectivityStreamSubcription;
                  },
                  child: Text('Muat Ulang', style: whiteTextStyle),
                  style: TextButton.styleFrom(backgroundColor: greenColor)),
            ],
          ));
        }));
  }
}
