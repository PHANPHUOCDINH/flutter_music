import 'package:flutter/cupertino.dart';
import 'package:spotify_clone/source/source.dart';

class SearchViewModel extends BaseViewModel {
  TextEditingController searchController = TextEditingController();
  List<TrackModel> searchResult = [];
  int searchIndex = 0;

  init() {}

  controlSearching(String keyword) async {
    setLoading(true);
    searchResult = null;
    searchResult = await getSearch(keyword: keyword);
    setLoading(false);
  }

  setSearchSelected(int index) {
    searchIndex = index;
    notifyListeners();
  }

  Future<List<TrackModel>> getSearch({String keyword}) async {
    var state = await authenticationRepository.getSearch(keyword: keyword);
    if (state.data != null && state.isSuccess) return state.data;
    return null;
  }
}
