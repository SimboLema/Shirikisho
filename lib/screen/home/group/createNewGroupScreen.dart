import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../model/drivers_modules.dart';
import '../../../utils/SVColors.dart';
import '../../../utils/SVCommon.dart';
import '../../../utils/WAColors.dart';
import 'completeNewGroup.dart';

class CreteNewGroupScreen extends StatefulWidget {
  static String tag = '/CreteNewGroupScreen';

  @override
  CreteNewGroupScreenState createState() => CreteNewGroupScreenState();
}

class CreteNewGroupScreenState extends State<CreteNewGroupScreen> {
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
        toasty(context, 'Back button');
      },
    );
  }

  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  bool isSearching = false;
  Widget appBarTitle = Text("Chagua madereva", style: boldTextStyle(color: appStore.textPrimaryColor));

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
    // var res = await loadAllOnlineDrivers(_nextPageKey);
    // List<DriverDetailsModule> officers = res[0];
    //
    // log(res[1]);
    //
    // setState(() {
    //   _driversList.clear();
    //   _driversList.addAll(officers);
    //   _pageSize = res[1];
    //   _nextPageKey = res[2];
    // });
    //
    // _filteredDriversList = _driversList;
  }

  void _filterLogListBySearchText(String searchText) {
    setState(() {
      _filteredDriversList = _driversList
          .where((logObj) =>
              logObj.firstName!.toLowerCase().contains(searchText.toLowerCase())).cast<DriverDetailsModule>()
          .toList();
    });

  }

  validate(){

    if(_groupNameController.text.length < 1){
      setState(
            () {
          // _postTextError = true;
        },
      );
      return false;
    }

    if(_selectedDrivers.length <= 0){
      setState(
            () {
          // _postFileError = true;
        },
      );
      return false;
    }

    return true;
  }

  void _onHorizontalLoading1() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: context.scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  16.width,
                  CircularProgressIndicator(
                    backgroundColor: Color(0xffD6D6D6),
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                  16.width,
                  Text(
                    "Please Wait....",
                    style: primaryTextStyle(color: appStore.textPrimaryColor),
                  ),
                ],
              ),
            ),
          );
        },
      );
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
            icon: Icon(actionIcon.icon, color: WAPrimaryColor),
            onPressed: () {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = Icon(Icons.close, color: appStore.textPrimaryColor);
                this.appBarTitle = TextField(
                  controller: _searchTextController,
                  focusNode: focusNode,
                  onChanged: (value) {
                      _updateSearchTerm();
                    setState(() {
                    });
                    _pagingController.refresh();
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
        body: RefreshIndicator(
          onRefresh: () => Future.sync(
                () => _pagingController.refresh(),
          ),
          child: PagedListView<String, DriverDetailsModule>(
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
                                  Text('${item.address.validate()}', style: primaryTextStyle(size: 9)),
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
                        text: 'Add',
                        textStyle: secondaryTextStyle(color: item.in_group.validate() ? Colors.white : SVAppColorPrimary, size: 15),
                        onTap: () {
                          item.in_group = !item.in_group.validate();
                          setState(() {
                            item.in_group.validate() ?_selectedDrivers.add(item) : _selectedDrivers.remove(item);
                          });
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
            ),),
        ).paddingAll(16),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: WAPrimaryColor,
        onPressed: () {
          CompleteNewGroupScreenScreen(selectedDriversList:_selectedDrivers).launch(context);
        },
        child: Icon(Icons.arrow_right_alt_outlined, color: white),
      ),
    )
    ;
  }

  Future<void> refresh()async {
    Timer(const Duration(seconds: 1), () {
      // completer.complete();
    });
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
