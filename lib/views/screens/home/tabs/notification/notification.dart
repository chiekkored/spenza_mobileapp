import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/notificationViewModels.dart';
import 'package:spenza/core/viewmodels/profileViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/list.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/recipeDetail/recipeDetail.dart';
import 'package:spenza/views/screens/home/userProfile/userProfile.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key? key}) : super(key: key);

  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  NotificationViewModel _notificationVM = NotificationViewModel();
  ProfileViewModel _profileVM = ProfileViewModel();

  late Future<List> _loadNotification;

  @override
  void initState() {
    var _userProvider = context.read<UserProvider>();
    // _getIsFollowing =
    //     _profileVM.getIsFollowing(_userProvider.userInfo.uid, widget.uid);
    _loadNotification = _notificationVM.getNotificationPosts(
        _userProvider.userInfo.uid); // only create the future once.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _userProvider = context.read<UserProvider>();
    return Container(
      color: CColors.White,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<List>(
          future: _loadNotification,
          builder: (context, snapshot) {
            DateTime now = new DateTime.now();
            DateTime date = new DateTime(now.year, now.month, now.day, 0, 0, 0);
            if (!snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: CustomNotificationListShimmer(),
              );
            } else {
              if (snapshot.data!.isNotEmpty) {
                bool isTodayDone = false;
                bool isYesterdayDone = false;
                return RefreshIndicator(
                  onRefresh: () async {
                    var _userProvider = context.read<UserProvider>();
                    setState(() {
                      _loadNotification = _notificationVM
                          .getNotificationPosts(_userProvider.userInfo.uid);
                    });
                  },
                  child: ListView.builder(
                      padding: const EdgeInsets.all(24.0),
                      // shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // Notification data
                        var _notifData = snapshot.data![index][0];
                        // Notification data
                        var _postDataId = snapshot.data![index][0]["postDocId"];
                        // Post liker's data
                        var _authorData = snapshot.data![index][1];
                        // Format date to readable time
                        var _dateCreated = timeago.format(
                            _notifData["dateCreated"].toDate(),
                            locale: 'en_short');
                        // Formart timestamp to date
                        DateTime _dateCreatedFormatted = DateTime.parse(
                            _notifData["dateCreated"].toDate().toString());
                        //Datetime

                        if (_dateCreatedFormatted.isBefore(date)) {
                          // If data timestamp is before the day
                          if (!isYesterdayDone) {
                            isYesterdayDone = true;
                            if (_notifData["type"] == "follow") {
                              // If notif type is follow

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 24.0),
                                      child: CustomTextBold(
                                          text: "Earlier",
                                          size: 17.0,
                                          color: CColors.PrimaryText),
                                    ),
                                    GestureDetector(
                                      onTap: () => pushNewScreen(context,
                                          screen: UserProfileScreen(
                                              uid: _authorData["uid"],
                                              name: _authorData["name"],
                                              dpUrl: _authorData["dpUrl"]),
                                          withNavBar: false),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      _authorData["dpUrl"],
                                                  imageBuilder:
                                                      (context, image) {
                                                    return CircleAvatar(
                                                      radius: 24.0,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      foregroundImage: image,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomTextBold(
                                                      text: _authorData["name"],
                                                      size: 15.0,
                                                      color:
                                                          CColors.PrimaryText),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomTextMedium(
                                                            text:
                                                                "now following you",
                                                            size: 12.0,
                                                            color: CColors
                                                                .SecondaryText),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          child: CustomTextMedium(
                                                              text: "•",
                                                              size: 12.0,
                                                              color: CColors
                                                                  .SecondaryText),
                                                        ),
                                                        CustomTextMedium(
                                                            text: _dateCreated
                                                                .toString(),
                                                            size: 12.0,
                                                            color: CColors
                                                                .SecondaryText),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: _profileVM.getIsFollowing(
                                                  _userProvider.userInfo.uid,
                                                  _authorData["uid"]),
                                              builder: (context, snapshot) {
                                                // switch (snapshot.connectionState) {
                                                //   case ConnectionState.done:
                                                if (!snapshot.hasData) {
                                                  debugPrint(
                                                      "-Is Following- has Error");
                                                  return Container(
                                                    width: 100.0,
                                                    height: 55.0,
                                                    child: CustomPrimaryButton(
                                                        text: "Follow",
                                                        doOnPressed: () {}),
                                                  );
                                                } else {
                                                  if (snapshot
                                                          .data!.docs.length >
                                                      0) {
                                                    debugPrint(
                                                        "-Is Following- has Data");
                                                    return Container(
                                                      width: 110.0,
                                                      height: 55.0,
                                                      child:
                                                          CustomSecondaryButton(
                                                              text: "Followed",
                                                              doOnPressed:
                                                                  () async {
                                                                await _profileVM
                                                                    .setUnfollow(
                                                                        _userProvider
                                                                            .userInfo
                                                                            .uid,
                                                                        _authorData[
                                                                            "uid"],
                                                                        snapshot
                                                                            .data!
                                                                            .docs[
                                                                                0]
                                                                            .id)
                                                                    .then(
                                                                        (value) {
                                                                  return null;
                                                                });
                                                              }),
                                                    );
                                                  } else {
                                                    debugPrint(
                                                        "-Is Following- has No Data: Not Following");
                                                    return Container(
                                                      width: 100.0,
                                                      height: 55.0,
                                                      child:
                                                          CustomPrimaryButton(
                                                              text: "Follow",
                                                              doOnPressed:
                                                                  () async {
                                                                await _profileVM
                                                                    .setFollow(
                                                                      _userProvider
                                                                          .userInfo
                                                                          .uid,
                                                                      _authorData[
                                                                          "uid"],
                                                                      _authorData[
                                                                          "name"],
                                                                      _authorData[
                                                                          "dpUrl"],
                                                                      _userProvider
                                                                          .userInfo
                                                                          .name,
                                                                      _userProvider
                                                                          .userInfo
                                                                          .dpUrl,
                                                                    )
                                                                    .then((value) =>
                                                                        null);
                                                              }),
                                                    );
                                                  }
                                                }
                                                // default:
                                                //   return CustomPrimaryButton(
                                                //       text: "Follow", doOnPressed: () {});
                                                // }
                                              })
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (_notifData["type"] == "like") {
                              // If notif type is like
                              // Post data
                              var _postData = snapshot.data![index][2];
                              // Likes count
                              int _likesLength = snapshot.data![index][3];
                              if (_likesLength > 1) {
                                // If likes more than one
                                // Name and dpUrl for 2nd liked user
                                var _author2Data = snapshot.data![index][4];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 24.0),
                                        child: CustomTextBold(
                                            text: "Earlier",
                                            size: 17.0,
                                            color: CColors.PrimaryText),
                                      ),
                                      manyLikesRow(
                                          _author2Data,
                                          _authorData,
                                          context,
                                          _likesLength,
                                          _dateCreated,
                                          _postData,
                                          _postDataId),
                                    ],
                                  ),
                                );
                              } else {
                                // If likes is only one
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 24.0),
                                        child: CustomTextBold(
                                            text: "Earlier",
                                            size: 17.0,
                                            color: CColors.PrimaryText),
                                      ),
                                      oneLikeRow(_authorData, _dateCreated,
                                          _postData, _postDataId),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              // If notif type is unknown
                              return Container();
                            }
                          } else {
                            if (_notifData["type"] == "follow") {
                              // If notif type is follow
                              return GestureDetector(
                                onTap: () => pushNewScreen(context,
                                    screen: UserProfileScreen(
                                        uid: _authorData["uid"],
                                        name: _authorData["name"],
                                        dpUrl: _authorData["dpUrl"]),
                                    withNavBar: false),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0),
                                            child: CachedNetworkImage(
                                              imageUrl: _authorData["dpUrl"],
                                              imageBuilder: (context, image) {
                                                return CircleAvatar(
                                                  radius: 24.0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  foregroundImage: image,
                                                );
                                              },
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomTextBold(
                                                  text: _authorData["name"],
                                                  size: 15.0,
                                                  color: CColors.PrimaryText),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    CustomTextMedium(
                                                        text:
                                                            "now following you",
                                                        size: 12.0,
                                                        color: CColors
                                                            .SecondaryText),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4.0),
                                                      child: CustomTextMedium(
                                                          text: "•",
                                                          size: 12.0,
                                                          color: CColors
                                                              .SecondaryText),
                                                    ),
                                                    CustomTextMedium(
                                                        text: _dateCreated
                                                            .toString(),
                                                        size: 12.0,
                                                        color: CColors
                                                            .SecondaryText),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: _profileVM.getIsFollowing(
                                              _userProvider.userInfo.uid,
                                              _authorData["uid"]),
                                          builder: (context, snapshot) {
                                            // switch (snapshot.connectionState) {
                                            //   case ConnectionState.done:
                                            if (!snapshot.hasData) {
                                              debugPrint(
                                                  "🚫 -Is Following- has Error");
                                              return Container(
                                                width: 100.0,
                                                height: 55.0,
                                                child: CustomPrimaryButton(
                                                    text: "Follow",
                                                    doOnPressed: () {}),
                                              );
                                            } else {
                                              if (snapshot.data!.docs.length >
                                                  0) {
                                                debugPrint(
                                                    "🟢 -Is Following- has Data");
                                                return Container(
                                                  width: 110.0,
                                                  height: 55.0,
                                                  child: CustomSecondaryButton(
                                                      text: "Followed",
                                                      doOnPressed: () async {
                                                        await _profileVM
                                                            .setUnfollow(
                                                                _userProvider
                                                                    .userInfo
                                                                    .uid,
                                                                _authorData[
                                                                    "uid"],
                                                                snapshot.data!
                                                                    .docs[0].id)
                                                            .then((value) {
                                                          return null;
                                                        });
                                                      }),
                                                );
                                              } else {
                                                debugPrint(
                                                    "🟢 -Is Following- has No Data: Not Following");
                                                return Container(
                                                  width: 100.0,
                                                  height: 55.0,
                                                  child: CustomPrimaryButton(
                                                      text: "Follow",
                                                      doOnPressed: () async {
                                                        await _profileVM
                                                            .setFollow(
                                                              _userProvider
                                                                  .userInfo.uid,
                                                              _authorData[
                                                                  "uid"],
                                                              _authorData[
                                                                  "name"],
                                                              _authorData[
                                                                  "dpUrl"],
                                                              _userProvider
                                                                  .userInfo
                                                                  .name,
                                                              _userProvider
                                                                  .userInfo
                                                                  .dpUrl,
                                                            )
                                                            .then((value) =>
                                                                null);
                                                      }),
                                                );
                                              }
                                            }
                                            // default:
                                            //   return CustomPrimaryButton(
                                            //       text: "Follow", doOnPressed: () {});
                                            // }
                                          })
                                    ],
                                  ),
                                ),
                              );
                            } else if (_notifData["type"] == "like") {
                              // If notif type is like
                              // Post data
                              var _postData = snapshot.data![index][2];
                              // Likes count
                              int _likesLength = snapshot.data![index][3];

                              if (_likesLength > 1) {
                                // If likes more than one
                                // Name and dpUrl for 2nd liked user
                                var _author2Data = snapshot.data![index][4];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: manyLikesRow(
                                      _author2Data,
                                      _authorData,
                                      context,
                                      _likesLength,
                                      _dateCreated,
                                      _postData,
                                      _postDataId),
                                );
                              } else {
                                // If likes is only one
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: oneLikeRow(_authorData, _dateCreated,
                                      _postData, _postDataId),
                                );
                              }
                            } else {
                              // If notif type is unknown
                              return Container();
                            }
                          }
                        } else {
                          if (!isTodayDone) {
                            isTodayDone = true;
                            if (_notifData["type"] == "follow") {
                              // If notif type is follow
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 24.0),
                                      child: CustomTextBold(
                                          text: "Today",
                                          size: 17.0,
                                          color: CColors.PrimaryText),
                                    ),
                                    GestureDetector(
                                      onTap: () => pushNewScreen(context,
                                          screen: UserProfileScreen(
                                              uid: _authorData["uid"],
                                              name: _authorData["name"],
                                              dpUrl: _authorData["dpUrl"]),
                                          withNavBar: false),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      _authorData["dpUrl"],
                                                  imageBuilder:
                                                      (context, image) {
                                                    return CircleAvatar(
                                                      radius: 24.0,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      foregroundImage: image,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomTextBold(
                                                      text: _authorData["name"],
                                                      size: 15.0,
                                                      color:
                                                          CColors.PrimaryText),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomTextMedium(
                                                            text:
                                                                "now following you",
                                                            size: 12.0,
                                                            color: CColors
                                                                .SecondaryText),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          child: CustomTextMedium(
                                                              text: "•",
                                                              size: 12.0,
                                                              color: CColors
                                                                  .SecondaryText),
                                                        ),
                                                        CustomTextMedium(
                                                            text: _dateCreated
                                                                .toString(),
                                                            size: 12.0,
                                                            color: CColors
                                                                .SecondaryText),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: _profileVM.getIsFollowing(
                                                  _userProvider.userInfo.uid,
                                                  _authorData["uid"]),
                                              builder: (context, snapshot) {
                                                // switch (snapshot.connectionState) {
                                                //   case ConnectionState.done:
                                                if (!snapshot.hasData) {
                                                  debugPrint(
                                                      "-Is Following- has Error");
                                                  return Container(
                                                    width: 100.0,
                                                    height: 55.0,
                                                    child: CustomPrimaryButton(
                                                        text: "Follow",
                                                        doOnPressed: () {}),
                                                  );
                                                } else {
                                                  if (snapshot
                                                          .data!.docs.length >
                                                      0) {
                                                    debugPrint(
                                                        "-Is Following- has Data");
                                                    return Container(
                                                      width: 110.0,
                                                      height: 55.0,
                                                      child:
                                                          CustomSecondaryButton(
                                                              text: "Followed",
                                                              doOnPressed:
                                                                  () async {
                                                                await _profileVM
                                                                    .setUnfollow(
                                                                        _userProvider
                                                                            .userInfo
                                                                            .uid,
                                                                        _authorData[
                                                                            "uid"],
                                                                        snapshot
                                                                            .data!
                                                                            .docs[
                                                                                0]
                                                                            .id)
                                                                    .then(
                                                                        (value) {
                                                                  return null;
                                                                });
                                                              }),
                                                    );
                                                  } else {
                                                    debugPrint(
                                                        "-Is Following- has No Data: Not Following");
                                                    return Container(
                                                      width: 100.0,
                                                      height: 55.0,
                                                      child:
                                                          CustomPrimaryButton(
                                                              text: "Follow",
                                                              doOnPressed:
                                                                  () async {
                                                                await _profileVM
                                                                    .setFollow(
                                                                      _userProvider
                                                                          .userInfo
                                                                          .uid,
                                                                      _authorData[
                                                                          "uid"],
                                                                      _authorData[
                                                                          "name"],
                                                                      _authorData[
                                                                          "dpUrl"],
                                                                      _userProvider
                                                                          .userInfo
                                                                          .name,
                                                                      _userProvider
                                                                          .userInfo
                                                                          .dpUrl,
                                                                    )
                                                                    .then((value) =>
                                                                        null);
                                                              }),
                                                    );
                                                  }
                                                }
                                                // default:
                                                //   return CustomPrimaryButton(
                                                //       text: "Follow", doOnPressed: () {});
                                                // }
                                              })
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (_notifData["type"] == "like") {
                              // If notif type is like
                              // Post data
                              var _postData = snapshot.data![index][2];
                              // Likes count
                              int _likesLength = snapshot.data![index][3];

                              if (_likesLength > 1) {
                                // If likes more than one
                                // Name and dpUrl for 2nd liked user
                                var _author2Data = snapshot.data![index][4];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 24.0),
                                        child: CustomTextBold(
                                            text: "Today",
                                            size: 17.0,
                                            color: CColors.PrimaryText),
                                      ),
                                      manyLikesRow(
                                          _author2Data,
                                          _authorData,
                                          context,
                                          _likesLength,
                                          _dateCreated,
                                          _postData,
                                          _postDataId),
                                    ],
                                  ),
                                );
                              } else {
                                // If likes is only one
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 24.0),
                                        child: CustomTextBold(
                                            text: "Today",
                                            size: 17.0,
                                            color: CColors.PrimaryText),
                                      ),
                                      oneLikeRow(_authorData, _dateCreated,
                                          _postData, _postDataId),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              // If notif type is unknown
                              return Container();
                            }
                          } else {
                            if (_notifData["type"] == "follow") {
                              // If notif type is follow
                              return GestureDetector(
                                onTap: () => pushNewScreen(context,
                                    screen: UserProfileScreen(
                                        uid: _authorData["uid"],
                                        name: _authorData["name"],
                                        dpUrl: _authorData["dpUrl"]),
                                    withNavBar: false),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0),
                                            child: CachedNetworkImage(
                                              imageUrl: _authorData["dpUrl"],
                                              imageBuilder: (context, image) {
                                                return CircleAvatar(
                                                  radius: 24.0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  foregroundImage: image,
                                                );
                                              },
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomTextBold(
                                                  text: _authorData["name"],
                                                  size: 15.0,
                                                  color: CColors.PrimaryText),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    CustomTextMedium(
                                                        text:
                                                            "now following you",
                                                        size: 12.0,
                                                        color: CColors
                                                            .SecondaryText),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4.0),
                                                      child: CustomTextMedium(
                                                          text: "•",
                                                          size: 12.0,
                                                          color: CColors
                                                              .SecondaryText),
                                                    ),
                                                    CustomTextMedium(
                                                        text: _dateCreated
                                                            .toString(),
                                                        size: 12.0,
                                                        color: CColors
                                                            .SecondaryText),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: _profileVM.getIsFollowing(
                                              _userProvider.userInfo.uid,
                                              _authorData["uid"]),
                                          builder: (context, snapshot) {
                                            // switch (snapshot.connectionState) {
                                            //   case ConnectionState.done:
                                            if (!snapshot.hasData) {
                                              debugPrint(
                                                  "🚫 -Is Following- has Error");
                                              return Container(
                                                width: 100.0,
                                                height: 55.0,
                                                child: CustomPrimaryButton(
                                                    text: "Follow",
                                                    doOnPressed: () {}),
                                              );
                                            } else {
                                              if (snapshot.data!.docs.length >
                                                  0) {
                                                debugPrint(
                                                    "🟢 -Is Following- has Data");
                                                return Container(
                                                  width: 110.0,
                                                  height: 55.0,
                                                  child: CustomSecondaryButton(
                                                      text: "Followed",
                                                      doOnPressed: () async {
                                                        await _profileVM
                                                            .setUnfollow(
                                                                _userProvider
                                                                    .userInfo
                                                                    .uid,
                                                                _authorData[
                                                                    "uid"],
                                                                snapshot.data!
                                                                    .docs[0].id)
                                                            .then((value) {
                                                          return null;
                                                        });
                                                      }),
                                                );
                                              } else {
                                                debugPrint(
                                                    "🚫 -Is Following- has No Data: Not Following");
                                                return Container(
                                                  width: 100.0,
                                                  height: 55.0,
                                                  child: CustomPrimaryButton(
                                                      text: "Follow",
                                                      doOnPressed: () async {
                                                        await _profileVM
                                                            .setFollow(
                                                              _userProvider
                                                                  .userInfo.uid,
                                                              _authorData[
                                                                  "uid"],
                                                              _authorData[
                                                                  "name"],
                                                              _authorData[
                                                                  "dpUrl"],
                                                              _userProvider
                                                                  .userInfo
                                                                  .name,
                                                              _userProvider
                                                                  .userInfo
                                                                  .dpUrl,
                                                            )
                                                            .then((value) =>
                                                                null);
                                                      }),
                                                );
                                              }
                                            }
                                            // default:
                                            //   return CustomPrimaryButton(
                                            //       text: "Follow", doOnPressed: () {});
                                            // }
                                          })
                                    ],
                                  ),
                                ),
                              );
                            } else if (_notifData["type"] == "like") {
                              // If notif type is like
                              // Post data
                              var _postData = snapshot.data![index][2];
                              // Likes count
                              int _likesLength = snapshot.data![index][3];

                              if (_likesLength > 1) {
                                // If likes more than one
                                // Name and dpUrl for 2nd liked user
                                var _author2Data = snapshot.data![index][4];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: manyLikesRow(
                                      _author2Data,
                                      _authorData,
                                      context,
                                      _likesLength,
                                      _dateCreated,
                                      _postData,
                                      _postDataId),
                                );
                              } else {
                                // If likes is only one
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: oneLikeRow(_authorData, _dateCreated,
                                      _postData, _postDataId),
                                );
                              }
                            } else {
                              // If notif type is unknown
                              return Container();
                            }
                          }
                        }
                      }),
                );
              } else {
                debugPrint("🚫 -Notification Tab- has No Data");
                return RefreshIndicator(
                    onRefresh: () async {
                      var _userProvider = context.read<UserProvider>();
                      setState(() {
                        _loadNotification = _notificationVM
                            .getNotificationPosts(_userProvider.userInfo.uid);
                      });
                    },
                    child:
                        ListView(padding: const EdgeInsets.only(bottom: 24.0),
                            // shrinkWrap: true,
                            children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: CustomTextMedium(
                                  text: "No notifications.",
                                  size: 18.0,
                                  color: CColors.PrimaryText),
                            ),
                          ),
                        ]));
              }
            }
          }),
    );
  }

  GestureDetector oneLikeRow(
      _authorData, String _dateCreated, _postData, String _postDocId) {
    var _userProvider = context.read<UserProvider>();
    return GestureDetector(
      onTap: () => pushNewScreen(context,
          screen: RecipeDetailScreen(
            imgUrl: _postData["postImageUrl"],
            postRecipeTitle: _postData["postRecipeTitle"],
            postPercent: _postData["postPercent"],
            postDuration: _postData["postDuration"],
            dpUrl: _userProvider.userInfo.dpUrl,
            name: _userProvider.userInfo.name,
            postDocId: _postDocId,
            fromScreen: "Notification",
            profileUid: _postData["authorUid"],
          ),
          withNavBar: false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CachedNetworkImage(
                  imageUrl: _authorData["dpUrl"],
                  imageBuilder: (context, image) {
                    return CircleAvatar(
                      radius: 24.0,
                      backgroundColor: Colors.transparent,
                      foregroundImage: image,
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextBold(
                      text: _authorData["name"],
                      size: 15.0,
                      color: CColors.PrimaryText),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomTextMedium(
                            text: "has liked your recipe",
                            size: 12.0,
                            color: CColors.SecondaryText),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: CustomTextMedium(
                              text: "•",
                              size: 12.0,
                              color: CColors.SecondaryText),
                        ),
                        CustomTextMedium(
                            text: _dateCreated.toString(),
                            size: 12.0,
                            color: CColors.SecondaryText),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            child: CachedNetworkImage(
              imageUrl: _postData["postImageUrl"],
              imageBuilder: (context, image) {
                return Image(
                  image: image,
                  fit: BoxFit.cover,
                  height: 64,
                  width: 64,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector manyLikesRow(_author2Data, _authorData, BuildContext context,
      int _likesLength, String _dateCreated, _postData, String _postDocId) {
    var _userProvider = context.read<UserProvider>();
    return GestureDetector(
      onTap: () => pushNewScreen(context,
          screen: RecipeDetailScreen(
            imgUrl: _postData["postImageUrl"],
            postRecipeTitle: _postData["postRecipeTitle"],
            postPercent: _postData["postPercent"],
            postDuration: _postData["postDuration"],
            dpUrl: _userProvider.userInfo.dpUrl,
            name: _userProvider.userInfo.name,
            postDocId: _postDocId,
            fromScreen: "Notification",
            profileUid: _postData["authorUid"],
          ),
          withNavBar: false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: CachedNetworkImage(
                          imageUrl: _author2Data["dpUrl"],
                          imageBuilder: (context, image) {
                            return CircleAvatar(
                              radius: 18.0,
                              backgroundColor: Colors.transparent,
                              foregroundImage: image,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        child: CachedNetworkImage(
                          imageUrl: _authorData["dpUrl"],
                          imageBuilder: (context, image) {
                            return CircleAvatar(
                              radius: 18.0,
                              backgroundColor: Colors.transparent,
                              foregroundImage: image,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: (_likesLength == 2)
                        ? RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: _authorData["name"],
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.0,
                                      letterSpacing: 0.5,
                                      color: CColors.PrimaryText),
                                ),
                                TextSpan(
                                  text: " and ",
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                      letterSpacing: 0.5,
                                      color: CColors.PrimaryText),
                                ),
                                TextSpan(
                                  text: _author2Data["name"],
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.0,
                                      letterSpacing: 0.5,
                                      color: CColors.PrimaryText),
                                ),
                              ],
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: _authorData["name"],
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.0,
                                      letterSpacing: 0.5,
                                      color: CColors.PrimaryText),
                                ),
                                TextSpan(
                                  text: " and ",
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                      letterSpacing: 0.5,
                                      color: CColors.PrimaryText),
                                ),
                                TextSpan(
                                  text: "${_likesLength - 1} others",
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.0,
                                      letterSpacing: 0.5,
                                      color: CColors.PrimaryText),
                                ),
                              ],
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomTextMedium(
                            text: "has liked your recipe",
                            size: 12.0,
                            color: CColors.SecondaryText),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: CustomTextMedium(
                              text: "•",
                              size: 12.0,
                              color: CColors.SecondaryText),
                        ),
                        CustomTextMedium(
                            text: _dateCreated.toString(),
                            size: 12.0,
                            color: CColors.SecondaryText),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            child: CachedNetworkImage(
              imageUrl: _postData["postImageUrl"],
              imageBuilder: (context, image) {
                return Image(
                  image: image,
                  fit: BoxFit.cover,
                  height: 64,
                  width: 64,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
