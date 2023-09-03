import 'package:sixam_mart/service/component/back_widget.dart';
import 'package:sixam_mart/service/component/background_component.dart';
import 'package:sixam_mart/service/component/loader_widget.dart';
import 'package:sixam_mart/service/main.dart';
import 'package:sixam_mart/service/model/category_model.dart';
import 'package:sixam_mart/service/network/rest_apis.dart';
import 'package:sixam_mart/service/screens/dashboard/component/category_widget.dart';
import 'package:sixam_mart/service/screens/service/search_list_screen.dart';
import 'package:sixam_mart/service/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Future<List<CategoryData>> future;
  List<CategoryData> categoryList = [];

  int page = 1;
  bool isLastPage = false;
  bool isApiCalled = false;

  UniqueKey key = UniqueKey();

  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getCategoryListWithPagination(page, categoryList: categoryList,
        lastPageCallBack: (val) {
      isLastPage = val;
    });
    if (page == 1) {
      key = UniqueKey();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log('calleddddd');
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: appBarWidget(
          language.lblCategory,
          textColor: Colors.white,
          color: primaryColor,
          systemUiOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness:
                  appStore.isDarkMode ? Brightness.light : Brightness.light,
              statusBarColor: context.primaryColor),
          showBack: Navigator.canPop(context),
          backWidget: BackWidget(),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedScrollView(
              onSwipeRefresh: () async {
                page = 1;
                setState(() {});
                init();
                return await 2.seconds.delay;
              },
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              onNextPage: () {
                if (!isLastPage) {
                  page++;
                  setState(() {});
                  init();
                }
              },
              children: [
                SnapHelperWidget<List<CategoryData>>(
                  future: future,
                  onSuccess: (snap) {
                    if (snap.isEmpty) {
                      return BackgroundComponent(
                          text: language.noPostJobFound,
                          subTitle: language.noPostJobFoundSubtitle);
                    }

                    return AnimatedWrap(
                      key: key,
                      runSpacing: 16,
                      spacing: 16,
                      itemCount: snap.length,
                      listAnimationType: ListAnimationType.Scale,
                      scaleConfiguration: ScaleConfiguration(
                          duration: 300.milliseconds, delay: 50.milliseconds),
                      itemBuilder: (_, index) {
                        CategoryData data = snap[index];

                        return GestureDetector(
                          onTap: () {
                            SearchListScreen(
                                    categoryId: data.id.validate(),
                                    categoryName: data.name,
                                    isFromCategory: true)
                                .launch(context);
                          },
                          child: CategoryWidget(
                              categoryData: data,
                              width: context.width() / 4 - 20),
                        );
                      },
                    );
                  },
                  loadingWidget: LoaderWidget(),
                ),
              ],
            ),
            // Observer(builder: (BuildContext context) => LoaderWidget().visible(appStore.isLoading.validate()).center()),
          ],
        ),
      ),
    );
  }
}
