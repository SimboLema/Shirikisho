import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/model/drivers_modules.dart';
import 'package:shirikisho/services/officers_service.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/environment.dart';
import '../../main.dart';

class MaafiisaScreen extends StatefulWidget {
  const MaafiisaScreen({Key? key}) : super(key: key);

  @override
  _MaafiisaScreenState createState() => _MaafiisaScreenState();
}

class _MaafiisaScreenState extends State<MaafiisaScreen> {
    bool isExpanded = false;

    late bool _loadingDrivers = true;

    List<DriverDetailsModule> _officersList = [];

    final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

    @override
    void initState() {
      super.initState();
      init();
    }

    final _storage = const FlutterSecureStorage();

    var _district = 'Kituo Changu';

    FocusNode focusNode = FocusNode();
    bool isSearching = false;

    Widget appBarTitle = Text("Madereva kituo changu", style: boldTextStyle(color: appStore.textPrimaryColor));

    Icon actionIcon = Icon(
      Icons.search,
      color: Colors.white,
    );

    Future getDist() async {
      var district = await  _storage.read(key: 'user_parking');
      if(district != null){
        setState((){
          _district = district;
        });
      }
    }

    Future<void> init() async {
      await getDist();
      List<DriverDetailsModule> officers = await loadOfficers();
      setState(() {
        _loadingDrivers = false;
        _officersList.clear();
        _officersList.addAll(officers);
      });
    }



  @override
  Widget build(BuildContext context) {
    Widget leadingWidget() {
      return BackButton(
        color: appStore.textPrimaryColor,
        onPressed: () {
          Navigator.pop(context);
          // toasty(context, 'Back button');
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Madereva $_district", style: boldTextStyle(color: appStore.textPrimaryColor)),
          leading: leadingWidget(),
          actions: [
            IconButton(
              icon: Icon(actionIcon.icon, color: appStore.textPrimaryColor),
              onPressed: () {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(Icons.close, color: appStore.textPrimaryColor);
                  this.appBarTitle = TextField(
                    focusNode: focusNode,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: TextStyle(color: appStore.textPrimaryColor, fontSize: 20),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: appStore.textPrimaryColor),
                      hintText: "Search",
                      hintStyle: TextStyle(color: appStore.textPrimaryColor, fontWeight: FontWeight.normal),
                    ),
                  );
                  setState(() {
                    isSearching = true;
                  });
                } else {
                  setState(() {
                    this.actionIcon = Icon(Icons.search, color: appStore.textPrimaryColor);
                    this.appBarTitle = Text(_district, style: boldTextStyle(color: appStore.textPrimaryColor));
                    isSearching = false;
                  });
                }
                log('Search');
                focusNode.requestFocus();
                // FocusScope.of(context).requestFocus(focusNode);
              },
            ),
          ],
          backgroundColor: appStore.appBarColor,
        ),
        body: Container(
            child: _driverLoader(_loadingDrivers)
        )
    );
  }

    Widget _driverLoader(_dLoader){
      if(_dLoader == true){
        return Container(
          alignment: Alignment.center,
          child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 4,
              margin: EdgeInsets.all(4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              )),
        );
      }else{
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 30, top: 26),
          physics: BouncingScrollPhysics(),
          itemCount: _officersList.length,
          itemBuilder: (context, index)  {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: boxDecorationDefault(borderRadius: radius(32), color: WAPrimaryColor.withOpacity(0.1)),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  backgroundColor: WAPrimaryColor.withOpacity(0.1),
                  title: Text(
                    '${_officersList[index].firstName} ${_officersList[index].middleName} ${_officersList[index].lastName}',
                    style: primaryTextStyle(),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      '${Environment.imageUrl}/${_officersList[index].imageId}',
                    ),
                    radius: 20,
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  childrenPadding: EdgeInsets.only(left: 32, top: 16, bottom: 16),
                  collapsedIconColor: context.iconColor,
                  iconColor: context.iconColor,
                  children: [

                    Text.rich(
                      TextSpan(
                        text: 'Vazi : ',
                        style: primaryTextStyle(),
                        children: <InlineSpan>[
                          TextSpan(text: _officersList[index].uniformId != null ? ' ${_officersList[index].uniformId}' : "Hana", style: secondaryTextStyle()),
                        ],
                      ),
                    ),
                    2.height,
                    Text.rich(
                      TextSpan(
                        text: 'Kujiunga : ',
                        style: primaryTextStyle(),
                        children: <InlineSpan>[
                          TextSpan(text: _dateFormat.format(DateTime.parse(_officersList[index].createdAt!)), style: secondaryTextStyle()),
                        ],
                      ),
                    ),
                    2.height,
                    Text.rich(
                      TextSpan(
                        text: 'Hatua ya Vazi : ',
                        style: primaryTextStyle(),
                        children: <InlineSpan>[
                          TextSpan(text: _officersList[index].uniformId == "Hana Vazi" ? ' Maombi' : "Amepata", style: secondaryTextStyle()),
                        ],
                      ),
                    ),
                    2.height,
                    Divider(
                      endIndent: 32,
                      color: Colors.black54,
                    ),
                    // TODO Make sure kiongozi anaona taarifa za mkopo
                    // Text.rich(
                    //   TextSpan(
                    //     text: 'Msajili : ',
                    //     style: primaryTextStyle(),
                    //     children: <InlineSpan>[
                    //       TextSpan(text: ' Fatma Hamisi', style: secondaryTextStyle()),
                    //     ],
                    //   ),
                    // ),
                    // 2.height,
                    // Text.rich(
                    //   TextSpan(
                    //     text: 'Mkopo : ',
                    //     style: primaryTextStyle(),
                    //     children: <InlineSpan>[
                    //       TextSpan(text: ' TZS 300,000 ', style: secondaryTextStyle()),
                    //     ],
                    //   ),
                    // ),
                    // 4.height,
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.all(4),
                              decoration: boxDecorationDefault(border: Border.all(color: Colors.black26)),
                              child: Icon(
                                Icons.call,
                                color: Colors.black54,
                              )
                          ),
                          onTap:() {_launchUrl(Uri.parse('tel:+${_officersList[index].phoneNumber}'));}
                        ),

                        Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(4),
                          decoration: boxDecorationDefault(border: Border.all(color: Colors.black26)),
                          child: Icon(
                            Icons.chat,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    }

    Future _launchUrl(_url) async {
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }
}
