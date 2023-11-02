import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/models/user_search_history_model.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/searchScreen';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textSearchBusinessController =
      TextEditingController();

  List<UserSearchHistory> userDataHistoryList = [];
  bool _IsSearching = false;

  List<PostData>? userDataList;

  final searchOnChange = BehaviorSubject<String>();
  int _pageIndex = 1;

  final _scrollController = ScrollController();

  String queryText = "";

  @override
  void initState() {
    super.initState();
    // setAnalytics();

    _getUserHistory();

    searchOnChange
        .debounceTime(const Duration(milliseconds: 1000))
        .listen((queryString) {
      _getTagUser(queryString, _pageIndex);
    });

    _getTagUser("", 1);

    _scrollController.addListener(() {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        if (userDataList != null) {
          if (userDataList!.length >= (10 * _pageIndex)) {
            // todo ask somnath about limit item
            _pageIndex++;
            _getTagUser(queryText, _pageIndex);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GestureDetectorUtil.onScreenTap(context);
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: 100.w,
            padding: EdgeInsets.only(bottom: 0.h.toDouble()),
            child: Column(
              children: [
                SizedBox(height: 4.w),
                searchBar(context),
                if (!_IsSearching) ...[
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: userDataHistoryList
                          .map((e) => InkWell(
                                onTap: () {
                                  _IsSearching = _IsSearching ? false : true;
                                  _getTagUser(e.keys!, _pageIndex);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          e.keys ?? "",
                                          style: TextStyle(
                                            fontFamily: "Inika",
                                            fontSize: 1.8.t,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          deleteSearch(e.id);
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.w, top: 6.w),
                    child: InkWell(
                      onTap: () {
                        deleteSearch();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "clear".tr,
                            style: const TextStyle(
                              fontFamily: "Inika",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Constants.black, width: 1),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (_IsSearching)
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 4.w),
                      color: Colors.white,
                      child: userDataList == null
                          ? Container()
                          : InViewNotifierList(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              initialInViewIds: const ['0'],
                              isInViewPortCondition: (double deltaTop,
                                  double deltaBottom,
                                  double viewPortDimension) {
                                return deltaTop < (0.5 * viewPortDimension) &&
                                    deltaBottom > (0.5 * viewPortDimension);
                              },
                              itemCount: userDataList!.length,
                              builder: (BuildContext context, int index) {
                                final item = userDataList![index];

                                return Container(
                                  padding: EdgeInsets.only(
                                    bottom: 6.w,
                                    left: 4.w,
                                    right: 4.w,
                                  ),
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: LayoutBuilder(
                                    builder: (BuildContext context,
                                        BoxConstraints constraints) {
                                      return InViewNotifierWidget(
                                        id: '$index',
                                        builder: (BuildContext context,
                                            bool isInView, Widget? child) {
                                          return PostCard(postData: item);
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _search(String? queryString) {
    if (queryString!.isNotEmpty) {
      searchOnChange.add(queryString);
      if (_IsSearching != true) {
        queryText = queryString;
        setState(() {
          _IsSearching = true;
        });
      } else {
        _pageIndex = 1;
        userDataList!.clear();
        // selectedList.clear();
        setState(() {});
      }
    } else {
      if (_IsSearching != false) {
        setState(() {
          _IsSearching = false;
        });
        searchOnChange.add("");
      }
      userDataList = null;
      // selectedList.clear();
      setState(() {});
      _getTagUser("", 1);
    }
  }

  Widget searchBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            )),
        Expanded(
          child: TextField(
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: (String value) {
              _search(value);
            },
            cursorColor: Constants.black,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Constants.black,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Constants.black),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Constants.black),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Constants.black),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Constants.black),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Constants.black),
              ),
            ),
            controller: _textSearchBusinessController,
          ),
        ),
      ],
    );
  }

  void _getUserHistory() async {
    debugPrint(
        "userDataHistoryList.length before: ${userDataHistoryList.length}");

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final value = await PostRepo().getUserHistory();

        if (value.status == true && value.data != null) {
          setState(() {
            userDataHistoryList = value.data!;
            userDataHistoryList = userDataHistoryList
                .where((element) => element.keys!.isNotEmpty)
                .toList();
            userDataHistoryList = userDataHistoryList.reversed.toList();
          });

          debugPrint(
              "userDataHistoryList.length after: ${userDataHistoryList.length}");
        }
      } catch (error) {
        SnackBarUtil.showSnackBar('Something went wrong', context: context);
        debugPrint('error: $error');
      }
    } else {
      // SnackBarUtil.showSnackBar('internet_not_available'.tr, context: context);
    }

    debugPrint(
        "userDataHistoryList.length after: ${userDataHistoryList.length}");
  }

  void deleteSearch([String? id]) async {
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        List<String> list = [];

        if (id != null) {
          list = [id];
        } else {
          for (var element in userDataHistoryList) {
            list.add(element.id!);
          }
        }

        Map payload = {
          "id": list,
        };

        final value = await PostRepo().deleteSearchHistoryItem(payload);

        if (value.status == true) {
          _getUserHistory();
        }
      } catch (error) {
        SnackBarUtil.showSnackBar('Something went wrong', context: context);
        debugPrint('error: $error');
      }
    } else {
      // SnackBarUtil.showSnackBar('internet_not_available'.tr, context: context);
    }
  }

  void _getTagUser(String text, int page) {
    PostRepo().getSearchData(text).then((value) {
      if (value.status ?? false) {
        if (userDataList == null) {
          setState(() {
            userDataList = value.data;
          });
        } else {
          if (page == 1) {
            userDataList!.clear();
          }
          setState(() {
            userDataList!.addAll(value.data!);
          });
        }
      }
    });
  }
}
