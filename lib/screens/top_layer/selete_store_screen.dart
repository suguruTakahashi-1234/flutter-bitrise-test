import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pre_order_flutter_app/entities/store.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:pre_order_flutter_app/screens/order_layer/product_list_screen.dart';
import 'package:provider/provider.dart';

class SelectStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 300.0,
            child: MapScreen(),
          ),
          Expanded(
            child: StoreListScreen(),
          ),
        ],
      ),
    );
  }
}

class StoreListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<AppModel>(builder: (context, model, child) {
        final storeList = model.storeList ?? [];
        final cards = storeList
            .map(
              (store) => Padding(
                padding: const EdgeInsets.all(4),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    leading: Image.network(
                      store.imageUrl,
                      width: 80,
                    ),
                    title: Text(store.name),
                    subtitle: Text(store.isOpenStr()),
                    onTap: () {
                      model.startOrder(store);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListScreen(),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: CrowdStateExt.getCrowdState(
                                store.currentCrowdStateRaw)
                            .color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: 60,
                      height: 48,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            CrowdStateExt.getCrowdState(
                                    store.currentCrowdStateRaw)
                                .title,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList();
        return cards == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 16,
                  left: 12,
                  right: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'どちらの店舗で受け取りますか？',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Column(
                      children: cards,
                    ),
                  ],
                ),
              );
      }),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Location _locationService = Location();
  // 現在位置
  LocationData _deviceLocation;
  // 現在位置の監視状況
  StreamSubscription _locationChangedListen;

  @override
  void initState() {
    super.initState();
    // 現在位置の取得
    _getLocation();
    // 現在位置の変化を監視
    _locationChangedListen =
        _locationService.onLocationChanged.listen((LocationData result) async {
      setState(() {
        _deviceLocation = result;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 監視を終了
    _locationChangedListen?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _makeGoogleMap(),
    );
  }

  Widget _makeGoogleMap() {
    if (_deviceLocation == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Consumer<AppModel>(builder: (context, model, child) {
        model.latitude = _deviceLocation.latitude;
        model.longitude = _deviceLocation.longitude;
        model.sortStoreListByDistance(
          _deviceLocation.latitude,
          _deviceLocation.longitude,
        );
        final storeList = model.storeList ?? [];
        final markers = storeList
            .map(
              (store) => Marker(
                markerId: MarkerId('${store.id.toString()}'),
                infoWindow: InfoWindow(
                  title: '${store.name}',
                  snippet: '${store.isOpenStr()}',
                ),
                position: LatLng(
                  store.latitude,
                  store.longitude,
                ),
              ),
            )
            .toSet();
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(_deviceLocation.latitude, _deviceLocation.longitude),
            zoom: 12.0,
          ),
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          minMaxZoomPreference: MinMaxZoomPreference(8, 18),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        );
      });
    }
  }

  void _getLocation() async {
    _deviceLocation = await _locationService.getLocation();
  }
}
