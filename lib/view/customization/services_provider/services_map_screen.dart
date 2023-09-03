import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:ui';

import 'package:sixam_mart/view/base/menu_drawer.dart';

class ServicesMapScreen extends StatefulWidget {
  final AddressModel address;
  final bool fromStore;
  ServicesMapScreen({@required this.address, this.fromStore = false});

  @override
  _ServicesMapScreenState createState() => _ServicesMapScreenState();
}

class _ServicesMapScreenState extends State<ServicesMapScreen> {
  LatLng _latLng;
  Set<Marker> _markers = Set.of([]);
  GoogleMapController _mapController;
  

  @override
  void initState() {
    super.initState();

    _latLng = LatLng(double.parse(widget.address.latitude),
        double.parse(widget.address.longitude));
    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'location'.tr),
      endDrawer: MenuDrawer(),
      body: Center(
        child: Container(
          width: Dimensions.WEB_MAX_WIDTH,
          child: Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _latLng, zoom: 16),
              minMaxZoomPreference: MinMaxZoomPreference(0, 16),
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              indoorViewEnabled: true,
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
            ),
          ]),
        ),
      ),
    );
  }

  void _setMarker() async {
    Uint8List destinationImageData = await convertAssetToUnit8List(
      widget.fromStore ? Images.restaurant_marker : Images.location_marker,
      width: 120,
    );

    _markers = Set.of([]);
    _markers.add(Marker(
      markerId: MarkerId('marker'),
      position: _latLng,
      icon: BitmapDescriptor.fromBytes(destinationImageData),
    ));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
