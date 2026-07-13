import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../model/drivers_modules.dart';
import '../../../utils/SVColors.dart';
import '../../../utils/SVCommon.dart';
import '../../../utils/WAColors.dart';
import '../../sms/ChattingScreen.dart';

class CreateNewConvScreenScreen extends StatefulWidget {
  static String tag = '/CreateNewConvScreenScreen';

  @override
  CreateNewConvScreenScreenState createState() => CreateNewConvScreenScreenState();
}

class CreateNewConvScreenScreenState extends State<CreateNewConvScreenScreen> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _searchTextController = TextEditingController();


  List<DriverDetailsModule> _driversList = [];
  List<DriverDetailsModule> _filteredDriversList = [];

  List<DriverDetailsModule> _selectedDrivers = [];

  var _pageSize = 30;
  var _nextPageKey = null;

  final PagingController<String, DriverDetailsModule> _pagingController = PagingController(firstPageKey: '');

  void changeStatusColor(Color color) async {
    setStatusBarColor(color);
  }

FocusNode focusNode = FocusNode();

  Widget leadingWidget() {
    return BackButton(
      color: appStore.textPrimaryColor,

      onPressed: () {
        Navigator.of(context).pop();
        // toasty(context, 'Back button');
      },
    );
  }

  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  bool isSearching = false;
  Widget appBarTitle = Text("Chagua dereva", style: boldTextStyle(color: appStore.textPrimaryColor));

  @override
  void initState() {
    changeStatusColor(appStore.scaffoldBackground!);

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
    isSearching = false;
    init();

    refreshData();
  }

  String? _searchTerm;

  Future<void> _fetchPage(String pageKey) async {
    try {
      var res = await loadSearchAllOnlineDrivers(pageKey,_searchTerm);
      final newItems  = res[0];
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = res[2];
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _updateSearchTerm() async {
    await Future.delayed(const Duration(seconds: 2));
    _searchTerm = _searchTextController.text;
    _pagingController.refresh();
  }

  init() async {
    var res = await loadAllOnlineDrivers(_nextPageKey);
    List<DriverDetailsModule> officers = await loadOfficers();
    // List<DriverDetailsModule> officers = res[0];

    log(res[1]);

    setState(() {
      _driversList.clear();
      _driversList.addAll(officers);
      _pageSize = res[1];
      _nextPageKey = res[2];
    });

    _filteredDriversList = _driversList;
  }


  @override
  void dispose() {
    changeStatusColor(appStore.scaffoldBackground!);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        leading: leadingWidget(),
        actions: [
          IconButton(
            icon: Icon(actionIcon.icon, color: appStore.textPrimaryColor),
            onPressed: () {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = Icon(Icons.close, color: appStore.textPrimaryColor);
                this.appBarTitle = TextField(
                  controller: _searchTextController,
                  focusNode: focusNode,
                  onChanged: (value) {
                    _updateSearchTerm();
                  },
                  style: TextStyle(color: appStore.textPrimaryColor, fontSize: 20),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: appStore.textPrimaryColor),
                    hintText: "Tafuta",
                    hintStyle: TextStyle(color: appStore.textPrimaryColor, fontWeight: FontWeight.normal),
                  ),
                );
                setState(() {
                  isSearching = true;
                });
              } else {
                setState(() {
                  this.actionIcon = Icon(Icons.search, color: appStore.textPrimaryColor);
                  this.appBarTitle = Text("Search Toolbar", style: boldTextStyle(color: appStore.textPrimaryColor));
                  isSearching = false;
                });
              }
              FocusScope.of(context).requestFocus(focusNode);
            },
          ),
        ],
        backgroundColor: appStore.appBarColor,
      ),
      body: Scaffold(
        body:
        PagedListView<String, DriverDetailsModule>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<DriverDetailsModule>(
              itemBuilder: (context, item, index) {
                return  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        svCommonCachedNetworkImage(item.imageId.validate(), height: 56, width: 56, fit: BoxFit.cover),
                        10.width,
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${item.firstName.validate()} ${item.middleName.validate()} ${item.lastName.validate()}', style: boldTextStyle(size: 15)),
                                Text('${item.address.validate()}', style: primaryTextStyle(size: 10)),
                              ],
                            ),
                            6.width,
                            item.is_leader.validate() ? Image.asset('assets/socialv/icons/verified.png', height: 14, width: 14, fit: BoxFit.cover) : Offstage(),
                          ],
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                    AppButton(
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                      text: 'Chat',
                      textStyle: secondaryTextStyle(color: item.in_group.validate() ? Colors.white : SVAppColorPrimary, size: 15),
                      onTap: () {
                        ChattingScreen(img: item.imageId, name: item.firstName,last_name: item.lastName,messages: null,id: item.id).launch(context);
                        // item.in_group = !item.in_group.validate();
                        // setState(() {
                        //   _selectedDrivers.add(item);
                        // });
                      },
                      elevation: 0,

                      height: 30,
                      width: 50,
                      color: item.in_group.validate() ? WAPrimaryColor : svGetScaffoldColor(),
                      padding: EdgeInsets.all(0),
                    ),
                  ],
                ).paddingSymmetric(vertical: 8);
              }
          ),


          // Column(
          //        mainAxisSize: MainAxisSize.min,
          //        crossAxisAlignment: CrossAxisAlignment.start,
          //        children: [
          //          Row(
          //            children: [
          //              svCommonCachedNetworkImage('https://test.shirikisho.co.tz/images/logo.jpg', height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(SVAppCommonRadius),
          //              10.width,
          //              Container(
          //                decoration: BoxDecoration(color: svGetScaffoldColor(), borderRadius: radius(SVAppCommonRadius)),
          //                width: context.width() * 0.7,
          //                child: AppTextField(
          //                  textFieldType: TextFieldType.NAME,
          //                  controller: _groupNameController,
          //                  decoration: InputDecoration(
          //                    hintText: '  New group Name',
          //                    hintStyle: secondaryTextStyle(color: svGetBodyColor()),
          //                    border: InputBorder.none,
          //                    focusedBorder: InputBorder.none,
          //                    enabledBorder: InputBorder.none,
          //                  ),
          //                ),
          //              ),
          //            ],
          //          ),
          //          20.height,
          //          Container(
          //            decoration: BoxDecoration(color: svGetScaffoldColor(), borderRadius: radius(SVAppCommonRadius)),
          //            child: AppTextField(
          //              textFieldType: TextFieldType.NAME,
          //              decoration: InputDecoration(
          //                border: InputBorder.none,
          //                hintText: 'Search Here',
          //                hintStyle: secondaryTextStyle(color: svGetBodyColor()),
          //                prefixIcon: Image.asset('assets/socialv/icons/ic_Search.png', height: 15, width: 15, fit: BoxFit.cover, color: svGetBodyColor()).paddingAll(16),
          //              ),
          //              onChanged: (value) => _filterLogListBySearchText(value),
          //            ),
          //          ),
          //          16.height,
          //          Row(
          //            children: [
          //              // svCommonCachedNetworkImage('$OldBaseUrl/images/socialv/faces/face_5.png', height: 48, width: 48, fit: BoxFit.cover).cornerRadiusWithClipRRect(SVAppCommonRadius),
          //              Text('Add group members', style: secondaryTextStyle(color: svGetBodyColor())),
          //              Spacer(),
          //              AppButton(
          //                shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
          //                text: 'Create Group',
          //                textStyle: secondaryTextStyle(color: Colors.white , size: 10),
          //                onTap: () async {
          //                  if(validate() == true) {
          //                    _onHorizontalLoading1();
          //                    final groupResponse = await createNewGroup(_groupNameController.text,_selectedDrivers);
          //
          //                    if (groupResponse[0] == 201 ){
          //                      loadOnlineGroups().ignore();
          //                      Navigator.of(context).pop();
          //                      Navigator.of(context).pop();
          //                    }
          //                  }else{
          //                    showAlert(context, 'Taarifa Hazijakamilika', 'Tafadahali hakikisha umejaza jina na kuchagua madereva.');
          //                  }
          //                  // e.in_group = !e.in_group.validate();
          //                  setState(() {});
          //                },
          //                elevation: 0,
          //                height: 30,
          //                width: 70,
          //                color: WAPrimaryColor,
          //                padding: EdgeInsets.all(0),
          //              ),
          //            ],
          //          ),
          //          Divider(height: 20),
          //
          //
          //          Column(
          //            mainAxisSize: MainAxisSize.min,
          //            children:
          //
          //            _filteredDriversList.map((e) {
          //              return Row(
          //                mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                children: [
          //                  Row(
          //                    children: [
          //                      svCommonCachedNetworkImage(e.imageId.validate(), height: 56, width: 56, fit: BoxFit.cover),
          //                      10.width,
          //                      Row(
          //                        children: [
          //                          Column(
          //                            mainAxisAlignment: MainAxisAlignment.start,
          //                            children: [
          //                              Text('${e.firstName.validate()} ${e.lastName.validate()}', style: boldTextStyle()),
          //                              Text('${e.address.validate()}', style: primaryTextStyle()),
          //                            ],
          //                          ),
          //                          6.width,
          //                          e.is_leader.validate() ? Image.asset('assets/socialv/icons/verified.png', height: 14, width: 14, fit: BoxFit.cover) : Offstage(),
          //                        ],
          //                        mainAxisSize: MainAxisSize.min,
          //                      ),
          //                    ],
          //                    mainAxisSize: MainAxisSize.min,
          //                  ),
          //                  AppButton(
          //                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
          //                    text: 'Add',
          //                    textStyle: secondaryTextStyle(color: e.in_group.validate() ? Colors.white : SVAppColorPrimary, size: 10),
          //                    onTap: () {
          //                      e.in_group = !e.in_group.validate();
          //                      setState(() {
          //                        _selectedDrivers.add(e.id);
          //                      });
          //                    },
          //                    elevation: 0,
          //                    height: 30,
          //                    width: 50,
          //                    color: e.in_group.validate() ? WAPrimaryColor : svGetScaffoldColor(),
          //                    padding: EdgeInsets.all(0),
          //                  ),
          //                ],
          //              ).paddingSymmetric(vertical: 8);
          //            }).toList(),
          //          )
          //        ],
        ).paddingAll(16),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: WAPrimaryColor,
        onPressed: () {
          // SVAddPostFragment().launch(context);
        },
        child: Icon(Icons.arrow_right_alt_outlined, color: white),
      ),
    );
  }

  Future<void> refreshData() async {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      if (refreshIndicatorKey.currentState != null) {
        refreshIndicatorKey.currentState!.show();
      }
    });
  }
}
