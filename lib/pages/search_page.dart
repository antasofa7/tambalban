import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tambal_ban/model/tire_patch_place.dart';
import 'package:tambal_ban/theme.dart';
import 'package:tambal_ban/widgets/tire_pacth_place_grid.dart';
import 'package:tambal_ban/widgets/tire_pacth_place_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  String? filter;
  bool isShowGrid = false;
  Position? position;
  double lat = 0, long = 0;

  void getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    lat = position!.latitude;
    long = position!.longitude;
  }

  @override
  void initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    getLocation();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget listView() {
      return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            TirePatchPlace place = tirePatchPlaceList[index];
            return filter == "" || filter == null
                ? TirePatchPlaceList(
                    place: place,
                    latitude: lat,
                    longitude: long,
                  )
                : place.name.toLowerCase().contains(filter!.toLowerCase())
                    ? TirePatchPlaceList(
                        place: place,
                        latitude: lat,
                        longitude: long,
                      )
                    : const SizedBox();
          }, childCount: tirePatchPlaceList.length)));
    }

    Widget gridView() {
      return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                TirePatchPlace place = tirePatchPlaceList[index];
                return filter == ""
                    ? TirePatchPlaceGrid(
                        place: place,
                        latitude: lat,
                        longitude: long,
                      )
                    : place.name.toLowerCase().contains(filter!.toLowerCase())
                        ? TirePatchPlaceGrid(
                            place: place,
                            latitude: lat,
                            longitude: long,
                          )
                        : const SizedBox();
              }, childCount: tirePatchPlaceList.length)));
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            title: Container(
              height: 50.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: grayColor),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: blackColor,
                      size: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                                color: whiteColor.withOpacity(0.8),
                                offset: const Offset(0, 20),
                                blurRadius: 40.0)
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: searchController,
                            autofocus: true,
                            style: blackTextStyle.copyWith(fontWeight: medium),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Cari tempat tambal ban...',
                              hintStyle:
                                  grayTextStyle.copyWith(fontWeight: light),
                            ),
                          )),
                          Icon(
                            Icons.search_outlined,
                            color: blackColor,
                            size: 28.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: whiteColor,
            elevation: 0,
          ),
          SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hasil pencarian',
                      style: grayTextStyle.copyWith(fontSize: 18.0),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          isShowGrid = !isShowGrid;
                        });
                      },
                      icon: Icon(
                        !isShowGrid ? Icons.grid_view : Icons.list_sharp,
                        color: grayColor,
                      ),
                    )
                  ],
                ),
              )),
          isShowGrid ? gridView() : listView(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 26.0))
        ],
      ),
    );
  }
}
