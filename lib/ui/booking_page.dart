import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instantsewa/base_url.dart';
import 'package:instantsewa/state/service_provider_state.dart';
import 'package:instantsewa/ui/payment_page.dart';
import 'package:instantsewa/util/hexcode.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class BookingPage extends StatefulWidget {
  final String index, longitude, latitude, address, startTime, endTime;
  final List<String> cartList;
  const BookingPage(
      {this.index,
      this.longitude,
      this.latitude,
      this.address,
      this.startTime,
      this.endTime,
      this.cartList});
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with AutomaticKeepAliveClientMixin {
  Color _purple = HexColor('#603f8b');
  final _serviceProviderStateRM = RM.get<ServiceProviderState>();
  bool _like=false;
  bool _isLoading = false;
  @override
  void initState() {
    _isLoading = false;
    _serviceProviderStateRM.setState((profileState) async {
      profileState.getServiceProviderDetails(widget.index);
      _like = await profileState.getFavouriteServiceProvider(
          service_provider_id: widget.index);
    });
    _isLoading = true;
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Details'),
        backgroundColor: _purple,
      ),
      body: StateBuilder<ServiceProviderState>(
          observe: () => _serviceProviderStateRM,
          builder: (context, model) {
            return SingleChildScrollView(
                child: Column(
              children: <Widget>[
                ...model.state.provider.map((provider) {
                  return Column(
                    children: <Widget>[
                      (!_isLoading)
                          ? new Center(
                              child: new SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: new CircularProgressIndicator(
                                  value: null,
                                  strokeWidth: 7.0,
                                ),
                              ),
                            )
                          : Container(
                              width: width,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Container(
                                      height: height * 0.45,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: provider.avatar==null?ExactAssetImage(
                                              'images/photos/provider.png'):
                                          NetworkImage(
                                              BASE_URL+'/img/'+provider.avatar),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width,
                                    margin: EdgeInsets.only(top: height * 0.45),
                                    padding: EdgeInsets.all(30.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 30,
                                              color: Colors.black26,
                                            ),
                                            Text(
                                              provider.address,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black26),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          provider.fullName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 50,
                                          width: width,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 3,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Icon(
                                                  Icons.star,
                                                  color: Colors.yellow[500],
                                                  size: 30,
                                                );
                                              }),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Details',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          provider.job,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                              letterSpacing: 0.5,
                                              wordSpacing: 1.5),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: RaisedButton(
                                            onPressed: () {
                                              _serviceProviderStateRM.setState(
                                                  (book) =>
                                                      book.bookServiceProvider(
                                                          cartId:
                                                              widget.cartList,
                                                          latitude:
                                                              widget.latitude,
                                                          longitude:
                                                              widget.longitude,
                                                          address:
                                                              widget.address,
                                                          serviceProviderId:
                                                              widget.index,
                                                          startTime:
                                                              widget.startTime,
                                                          endTime:
                                                              widget.endTime));
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            color: _purple,
                                            padding: EdgeInsets.fromLTRB(
                                                35, 12, 35, 12),
                                            child: Text(
                                              'Book Now',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 25,
                                    top: height * 0.40,
                                    child: GestureDetector(
                                      onTap: () {
                                        _serviceProviderStateRM
                                            .setState((favouritestate) async {
                                          await favouritestate
                                              .setFavouriteServiceProvider(
                                                  $service_provider_id:
                                                      provider.id);
                                          _like = await favouritestate
                                              .getFavouriteServiceProvider(
                                                  service_provider_id:
                                                      provider.id);
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            )
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.favorite,
                                          size: 35,
                                          color: (_like)
                                              ? Colors.red[800]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  );
                })
              ],
            ));
          }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
