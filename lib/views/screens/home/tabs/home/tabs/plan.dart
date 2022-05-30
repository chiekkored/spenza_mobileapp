import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/postViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:table_calendar/table_calendar.dart';

class PlanTab extends StatefulWidget {
  const PlanTab({Key? key}) : super(key: key);

  @override
  _PlanTabState createState() => _PlanTabState();
}

class _PlanTabState extends State<PlanTab> with AutomaticKeepAliveClientMixin {
  DateTime _now = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late ValueNotifier<List<List>> _selectedEvents;
  PostViewModel _postVM = PostViewModel();
  Map<String, List<List>> hgha = {};

  late Stream<QuerySnapshot<Object?>> _getPlans;

  List<List> _getEventsForDay(DateTime day) {
    print(day);
    return hgha[day.toString()] ?? [];
  }

  void addPlansToCalendar(QueryDocumentSnapshot plansData) {
    Map<String, dynamic> dynamicMap = plansData["planRecipes"];
    Map<String, List<List<dynamic>>> typedMap =
        dynamicMap.map((key, value) => MapEntry(key, [value]));
    hgha.addAll(typedMap);
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void initState() {
    super.initState();
    var _userProvider = context.read<UserProvider>();
    _getPlans = _postVM.getPlans(_userProvider.userInfo.uid);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot>(
        stream: _getPlans,
        builder: (context, snapshot) {
          var plansData = snapshot.data!.docs.first;
          addPlansToCalendar(plansData);
          return Container(
            color: CColors.White,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TableCalendar(
                      availableGestures: AvailableGestures.horizontalSwipe,
                      availableCalendarFormats: {_calendarFormat: ""},
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _now,
                      calendarStyle: const CalendarStyle(
                        weekendTextStyle:
                            TextStyle(color: CColors.SecondaryColor),
                        todayDecoration: BoxDecoration(
                          color: CColors.Outline,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: CColors.PrimaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        titleTextStyle: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            letterSpacing: 0.5,
                            color: CColors.MainText),
                        formatButtonTextStyle:
                            TextStyle(color: CColors.White, fontSize: 16.0),
                        formatButtonDecoration: BoxDecoration(
                          color: CColors.PrimaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: CColors.MainText,
                          size: 28,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: CColors.MainText,
                          size: 28,
                        ),
                      ),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        _selectedEvents.value = _getEventsForDay(selectedDay);
                        setState(() {
                          _selectedDay = selectedDay;
                          _now = focusedDay;
                        });
                      },
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _now = focusedDay;
                      },
                      eventLoader: (day) {
                        return _getEventsForDay(day);
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ValueListenableBuilder<List<List>>(
                          valueListenable: _selectedEvents,
                          builder: (context, value, _) {
                            return ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: value.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  // return the header
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 16.0),
                                    child: new CustomTextBold(
                                        text: "Plans",
                                        size: 32.0,
                                        color: CColors.PrimaryText),
                                  );
                                }
                                index -= 1;
                                String recipeName = value[index][0];
                                String recipeImage = value[index][1];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  visualDensity:
                                      VisualDensity.adaptivePlatformDensity,
                                  leading: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    child: CachedNetworkImage(
                                      imageUrl: recipeImage,
                                      imageBuilder: (context, image) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Image(
                                            image: image,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  title: CustomTextMedium(
                                      text: recipeName,
                                      size: 16.0,
                                      color: CColors.MainText),
                                  subtitle: CustomTextRegular(
                                      text: recipeName,
                                      size: 14.0,
                                      color: CColors.SecondaryText),
                                  dense: true,
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  @override
  bool get wantKeepAlive => false;
}
