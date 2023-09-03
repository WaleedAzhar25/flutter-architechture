import '../models/latest_model.dart';
import '../models/search_post_model.dart';
import '../models/search_user_model.dart';
import '../provider/latestpost_api.dart';
import '../provider/search_tags_api.dart';
import '../provider/search_user_api.dart';

class Repository {
  Future<SearchPostModel> searchRepository(String text, String userID) async {
    return await SearchApi().searchApi(text, userID);
  }

  Future<LatestPostModel> latestpostRepository(String userID) async {
    return await LatestPostApi().latestPostApi(userID);
  }

  Future<SearchUserModel> searchuserRepository(String text) async {
    return await SearchUserApi().searchuserApi(text);
  }
}
