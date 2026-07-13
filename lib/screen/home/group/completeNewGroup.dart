import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/global/environment.dart';

import '../../../main.dart';
import '../../../model/drivers_modules.dart';
import '../../../model/social/message_model.dart';
import '../../../model/socialv/models/SVStoryModel.dart';
import '../../../services/show_alert.dart';
import '../../../utils/SVColors.dart';
import '../../../utils/SVCommon.dart';
import '../../../utils/SVConstants.dart';
import '../../../utils/WAColors.dart';
import '../../../utils/widgets/widgets.dart';
import '../../../utils/Lipsum.dart' as lipsum;
import 'liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class CompleteNewGroupScreenScreen extends StatefulWidget {
  static String tag = '/CompleteNewGroupScreenScreen';

  final List<DriverDetailsModule> selectedDriversList;

  const CompleteNewGroupScreenScreen({Key? key,required this.selectedDriversList}): super(key: key);

  @override
  CompleteNewGroupScreenScreenState createState() => CompleteNewGroupScreenScreenState();
}

class CompleteNewGroupScreenScreenState extends State<CompleteNewGroupScreenScreen> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController _groupNameController = TextEditingController();


  List<DriverDetailsModule> _driversList = [];
  List<DriverDetailsModule> _filteredDriversList = [];

  List<SVStoryModel> storyList = getStories();


  var _selectedDrivers = [];

  void changeStatusColor(Color color) async {
  setStatusBarColor(color);
}

  @override
  void initState() {
    changeStatusColor(appStore.scaffoldBackground!);
    super.initState();
    init();

    refreshData();
  }

  init() async {
    List<DriverDetailsModule> officers = await loadOfficers();

      _selectedDrivers.clear();
      for(var _id in widget.selectedDriversList){
        _selectedDrivers.add(_id.id);
      }

    setState(() {
      _driversList.clear();
      _driversList.addAll(officers);
    });

    _filteredDriversList = _driversList;
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

    log('Validating');
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
      appBar: appBar(context, 'Tengeneza kundi'),
      body: SingleChildScrollView(
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                svCommonCachedNetworkImage('https://test.shirikisho.co.tz/images/logo.jpg', height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(SVAppCommonRadius),
                10.width,
                Container(
                  decoration: BoxDecoration(color: svGetScaffoldColor(), borderRadius: radius(SVAppCommonRadius)),
                  width: context.width() * 0.7,
                  child: AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      hintText: '  New group Name',
                      hintStyle: secondaryTextStyle(color: svGetBodyColor()),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            20.height,

            Row(
              children: [
                // svCommonCachedNetworkImage('$OldBaseUrl/images/socialv/faces/face_5.png', height: 48, width: 48, fit: BoxFit.cover).cornerRadiusWithClipRRect(SVAppCommonRadius),
                Text('Add group members', style: secondaryTextStyle(color: svGetBodyColor())),
                Spacer(),
                AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                  text: 'Create Group',
                  textStyle: secondaryTextStyle(color: Colors.white , size: 10),
                  onTap: () async {
                    if(validate() == true) {
                      _onHorizontalLoading1();
                      final groupResponse = await createNewGroup(_groupNameController.text,_selectedDrivers);

                      if (groupResponse[0] == 201 ){
                        loadOnlineGroups().ignore();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    }else{
                      showAlert(context, 'Taarifa Hazijakamilika', 'Tafadahali hakikisha umejaza jina na kuchagua madereva.');
                    }
                    // e.in_group = !e.in_group.validate();
                    setState(() {});
                  },
                  elevation: 0,
                  height: 30,
                  width: 70,
                  color: WAPrimaryColor,
                  padding: EdgeInsets.all(0),
                ),
              ],
            ),
            Divider(height: 40),
            GridView.builder(
              itemCount: widget.selectedDriversList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                // _selectedDrivers.add(widget.selectedDriversList[index].id);
                return Column(
                  children: [
                    Container(
                      child: svCommonCachedNetworkImage(widget.selectedDriversList[index].imageId, height: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                      decoration: BoxDecoration(
                        border: Border.all(color: WAPrimaryColor, width: 2),
                        borderRadius: radius(100),
                      ),
                    ),
                    5.height,
                    Text(widget.selectedDriversList[index].firstName.validate(), style: secondaryTextStyle(size: 12, color: context.iconColor, weight: FontWeight.w500)),
                  ],
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
            ),
          ],
        ).paddingAll(16),),
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

List<SVStoryModel> getStories() {
  List<SVStoryModel> list = [];

  list.add(SVStoryModel(name: 'Iana', profileImage: '$OldBaseUrl/images/socialv/faces/face_1.png', time: '4m', like: false));
  list.add(SVStoryModel(name: 'Allie', profileImage: '$OldBaseUrl/images/socialv/faces/face_2.png', time: '4m', like: false));
  list.add(SVStoryModel(name: 'Manny', profileImage: '$OldBaseUrl/images/socialv/faces/face_3.png', time: '4m', like: false));
  list.add(SVStoryModel(name: 'Isabelle', profileImage: '$OldBaseUrl/images/socialv/faces/face_4.png', time: '4m', like: false));
  list.add(SVStoryModel(name: 'Jenny Wilson', profileImage: '$OldBaseUrl/images/socialv/faces/face_5.png', time: '4m', like: false));

  return list;
}