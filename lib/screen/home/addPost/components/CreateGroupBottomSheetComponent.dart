import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../global/environment.dart';
import '../../../../main.dart';
import '../../../../model/SVSearchModel.dart';
import '../../../../model/drivers_modules.dart';
import '../../../../model/social/message_model.dart';
import '../../../../services/show_alert.dart';
import '../../../../utils/SVColors.dart';
import '../../../../utils/SVCommon.dart';
import '../../../../utils/SVConstants.dart';

class CreateGroupBottomSheetComponent extends StatefulWidget {

  final List<DriverDetailsModule> officers;

  const CreateGroupBottomSheetComponent ( this.officers,  {Key? key }) : super(key: key);


  @override
  State<CreateGroupBottomSheetComponent> createState() => _CreateGroupBottomSheetComponentState();
}

class _CreateGroupBottomSheetComponentState extends State<CreateGroupBottomSheetComponent> {
  List<SVSearchModel> list = getSharePostList();

  TextEditingController _groupNameController = TextEditingController();

  List<DriverDetailsModule> _filteredGroupsList = [];

  var _selectedDrivers = [];

  void _filterLogListBySearchText(String searchText) {
    setState(() {
      _filteredGroupsList = widget.officers
          .where((logObj) =>
              logObj.firstName!.toLowerCase().contains(searchText.toLowerCase())).cast<DriverDetailsModule>()
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetching the data from firestore
    _filteredGroupsList = widget.officers;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        30.height,
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
        Container(
          decoration: BoxDecoration(color: svGetScaffoldColor(), borderRadius: radius(SVAppCommonRadius)),
          child: AppTextField(
            textFieldType: TextFieldType.NAME,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search Here',
              hintStyle: secondaryTextStyle(color: svGetBodyColor()),
              prefixIcon: Image.asset('assets/socialv/icons/ic_Search.png', height: 15, width: 15, fit: BoxFit.cover, color: svGetBodyColor()).paddingAll(16),
            ),
            onChanged: (value) => _filterLogListBySearchText(value),
          ),
        ),
        16.height,
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
                      log('Creating Group');
                      loadOnlineGroups().ignore();
                      _onHorizontalLoading1();
                      final groupResponse = await createNewGroup(_groupNameController.text,_selectedDrivers);

                      if (groupResponse[0] == 201 ){
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    }else{
                      showAlert(context, 'Taarifa Hazijakamilika',
                          'Tafadahali hakikisha umejaza jina na kuchagua madereva.');
                    }
                    // e.in_group = !e.in_group.validate();
                    setState(() {});
                  },
                  elevation: 0,
                  height: 30,
                  width: 70,
                  color: SVAppColorPrimary,
                  padding: EdgeInsets.all(0),
                ),
          ],
        ),
        Divider(height: 40),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: _filteredGroupsList.map((e) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    svCommonCachedNetworkImage(e.imageId.validate(), height: 56, width: 56, fit: BoxFit.cover),
                    10.width,
                    Row(
                      children: [
                        Column(
                          children: [
                            Text('${e.firstName.validate()} ${e.lastName.validate()}', style: boldTextStyle()),
                            Text('${e.firstName.validate()} ${e.lastName.validate()}', style: primaryTextStyle()),
                          ],
                        ),
                        6.width,
                        e.is_leader.validate() ? Image.asset('assets/socialv/icons/ic_TickSquare.png', height: 14, width: 14, fit: BoxFit.cover) : Offstage(),
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
                AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                  text: 'Add',
                  textStyle: secondaryTextStyle(color: e.in_group.validate() ? Colors.white : SVAppColorPrimary, size: 10),
                  onTap: () {
                    e.in_group = !e.in_group.validate();
                    setState(() {
                      _selectedDrivers.add(e.id);
                    });
                  },
                  elevation: 0,
                  height: 30,
                  width: 50,
                  color: e.in_group.validate() ? SVAppColorPrimary : svGetScaffoldColor(),
                  padding: EdgeInsets.all(0),
                ),
              ],
            ).paddingSymmetric(vertical: 8);
          }).toList(),
        )
      ],
    ).paddingAll(16),);
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
}
