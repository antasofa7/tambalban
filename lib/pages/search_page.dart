import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tambal_ban/ad_helper.dart';
import 'package:tambal_ban/cubit/connected_cubit.dart';
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
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  String filter = "";
  bool isShowGrid = false;
  Position? position;
  double lat = 0, long = 0;
  double distanceInMeters = 0.0;
  BannerAd? _bannerAd;

  _initBannerAd() {
    BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, err) {
            print('Failed to load a banner ad: ${err.message}');
            ad.dispose();
          },
        )).load();
  }

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
    _initBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget skeletonList() {
      return Shimmer.fromColors(
          baseColor: grayColor.withOpacity(0.5),
          highlightColor: grayColor.withOpacity(0.1),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 80.0,
                margin: const EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                    color: grayColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ],
          ));
    }

    Widget listView(List<PlaceModel> places) {
      var sort = sortByDistance(places);
      return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          }, childCount: sort.length)));
    }

    Widget skeletonGrid() {
      return Shimmer.fromColors(
          baseColor: grayColor.withOpacity(0.5),
          highlightColor: grayColor.withOpacity(0.1),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 175.0,
                decoration: BoxDecoration(
                    color: grayColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ],
          ));
    }

    Widget gridView(List<PlaceModel> places) {
      var sort = sortByDistance(places);
      return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 0.83,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return isLoading
                    ? skeletonGrid()
                    : filter == ""
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

    Widget searchBar() {
      return Container(
          height: 50.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                    color: greenColor.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 12.0)
              ]),
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
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: searchController,
                        autofocus: true,
                        cursorColor: greenColor,
                        style: blackTextStyle.copyWith(fontWeight: medium),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Cari tempat tambal ban...',
                          hintStyle: grayTextStyle.copyWith(fontWeight: light),
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
          ));
    }

    Widget title() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hasil pencarian',
            style: grayTextStyle.copyWith(fontSize: 18.0),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isShowGrid = !isShowGrid;
              });
            },
            child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(width: 1, color: grayColor)),
                child: Row(
                  children: [
                    AnimatedOpacity(
                      opacity: !isShowGrid ? 1 : 0.1,
                      duration: const Duration(milliseconds: 1500),
                      child: Icon(Icons.list_alt_outlined, color: grayColor),
                    ),
                    AnimatedOpacity(
                      opacity: isShowGrid ? 1 : 0.1,
                      duration: const Duration(milliseconds: 1500),
                      child: Icon(Icons.grid_view_outlined, color: grayColor),
                    ),
                  ],
                )),
          ),
        ],
      );
    }

    return BlocConsumer<ConnectedCubit, ConnectedState>(
        listener: (context, stateConnected) {
      if (stateConnected is ConnectedFailed) {
        Scaffold(
          backgroundColor: whiteColor,
          body: Center(
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
          )),
        );
      }
    }, builder: (context, stateConnected) {
      if ((stateConnected is ConnectedSuccess &&
              stateConnected.connectionType == ConnectionType.wifi) ||
          (stateConnected is ConnectedSuccess &&
              stateConnected.connectionType == ConnectionType.mobile)) {
        return Scaffold(
          backgroundColor: whiteColor,
          body: BlocBuilder<PlaceCubit, PlaceState>(
            builder: (context, statePlace) {
              if (statePlace is PlaceSuccess) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      floating: true,
                      backgroundColor: whiteColor,
                      elevation: 0,
                      toolbarHeight: 70.0,
                      title: searchBar(),
                    ),
                    SliverPadding(
                        padding: const EdgeInsets.all(16.0),
                        sliver: SliverToBoxAdapter(
                          child: title(),
                        )),
                    !isShowGrid
                        ? listView(statePlace.places)
                        : gridView(statePlace.places),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 26.0)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverToBoxAdapter(
                          child: _bannerAd != null
                              ? SizedBox(
                                  width: _bannerAd!.size.width.toDouble(),
                                  height: _bannerAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAd!),
                                )
                              : const SizedBox()),
                    ),
                  ],
                );
              }
              return Padding(
                  padding:
                      const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: searchBar(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: title(),
                      ),
                      skeletonList(),
                      skeletonList(),
                      skeletonList(),
                      skeletonList(),
                    ],
                  ));
            },
          ),
        );
      }

      return Scaffold(
        backgroundColor: whiteColor,
        body: Center(
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
                  context.read<ConnectedCubit>().connectivityStreamSubcription;
                },
                child: Text('Muat Ulang', style: whiteTextStyle),
                style: TextButton.styleFrom(backgroundColor: greenColor)),
          ],
        )),
      );
    });
  }
}
