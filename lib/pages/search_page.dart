import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tambal_ban/cubit/place_cubit.dart';
import 'package:tambal_ban/model/place_model.dart';
import 'package:tambal_ban/pages/detail.dart';
import 'package:tambal_ban/theme.dart';
import 'package:tambal_ban/widgets/place_grid.dart';
import 'package:tambal_ban/widgets/place_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  String filter = "";
  bool isShowGrid = false;
  Position? position;
  double lat = 0, long = 0;
  double distanceInMeters = 0.0;

  void getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    lat = position!.latitude;
    long = position!.longitude;
  }

  List<Map> sortByDistance(List<PlaceModel> places) {
    List<Map<dynamic, dynamic>> placesWithdistance = [];

    for (var place in places) {
      distanceInMeters = Geolocator.distanceBetween(
              lat, long, place.latitude, place.longitude) /
          1000;

      placesWithdistance.add({
        'items': place,
        'distance': distanceInMeters,
        'lat': lat,
        'long': long
      });
    }

    placesWithdistance.sort((a, b) => a['distance'].compareTo(b['distance']));

    return placesWithdistance;
  }

  @override
  void initState() {
    context.read<PlaceCubit>().fetchPlaces();
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
    Widget listView(List<PlaceModel> places) {
      var sort = sortByDistance(places);
      return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return filter == ""
                ? PlaceList(
                    sort[index],
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              sort[index],
                            ),
                          ));
                    },
                  )
                : sort[index]['items']
                        .name
                        .toLowerCase()
                        .contains(filter.toLowerCase())
                    ? PlaceList(
                        sort[index],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  sort[index],
                                ),
                              ));
                        },
                      )
                    : const SizedBox();
          }, childCount: sort.length < 20 ? sort.length : 20)));
    }

    Widget gridView(List<PlaceModel> places) {
      var sort = sortByDistance(places);
      return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return filter == ""
                    ? PlaceGrid(
                        sort[index],
                      )
                    : sort[index]['items']
                            .name
                            .toLowerCase()
                            .contains(filter.toLowerCase())
                        ? PlaceGrid(
                            sort[index],
                          )
                        : const SizedBox();
              }, childCount: sort.length < 20 ? sort.length : 20)));
    }

    return BlocConsumer<PlaceCubit, PlaceState>(listener: (context, state) {
      if (state is PlaceFailed) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              state.error,
              style: whiteTextStyle,
            )));
      }
    }, builder: (context, state) {
      if (state is PlaceSuccess) {
        return Scaffold(
          backgroundColor: whiteColor,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  title: Container(
                    height: 50.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  style: blackTextStyle.copyWith(
                                      fontWeight: medium),
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Cari tempat tambal ban...',
                                    hintStyle: grayTextStyle.copyWith(
                                        fontWeight: light),
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
                !isShowGrid ? listView(state.places) : gridView(state.places),
                const SliverPadding(padding: EdgeInsets.only(bottom: 26.0))
              ],
            ),
          ),
        );
      }

      return const SizedBox();
    });
  }
}
