import 'package:get_it/get_it.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instantsewa/model/provider_model.dart';
import 'package:instantsewa/model/service_model.dart';
import 'package:instantsewa/router/route_constants.dart';
import 'package:instantsewa/services/service_providers_service.dart';
import 'package:instantsewa/ui/bulid_slider.dart';
import 'package:instantsewa/ui/build_grid_categories.dart';
import 'package:instantsewa/ui/categories_list.dart';
import 'package:instantsewa/ui/provider_list.dart';
import 'package:instantsewa/ui/service_search.dart';
import 'package:instantsewa/util/hexcode.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'home_page.dart';
import 'main_drawer.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  Color _purple = HexColor('#603f8b');
  var provider = GetIt.instance<ServiceProvidersService>();
  List<Service> category = [];
  List<Provider> serviceprovider = [];

  @override
  void initState() {
    serviceprovider = provider.addProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: _purple,
        title: Text(
          'Instant Sewa',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch<String>(
                context: context,
                delegate: ServiceSearch(),
              );
              print(result);
            },
          ),

          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () async{
              Navigator.pushNamed(RM.context,notificationRoute);
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.white38,
        child: ListView(
          children: <Widget>[
            BulidSlider(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 14.0),
                  child: Text(
                    'All Services',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            BuildGridCategory(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Text(
                    'Popular Services',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: _purple,
                      ),
                    ),
                  ),
                )
              ],
            ),
            CategoryList(),
          ],
        ),
      ),
    );
  }
}
