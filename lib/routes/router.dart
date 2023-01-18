import 'package:auto_route/auto_route.dart';
import 'package:bujuan/pages/guide/guide_view.dart';
import 'package:bujuan/pages/home/view/home_view.dart';
import 'package:bujuan/pages/index/album_view.dart';
import 'package:bujuan/pages/index/main_view.dart';
import 'package:bujuan/pages/local/local_song.dart';
import 'package:bujuan/pages/mv/mv_view.dart';
import 'package:bujuan/pages/radio/my_radio_view.dart';
import 'package:bujuan/pages/radio/radio_details_view.dart';
import 'package:bujuan/pages/setting/settring_view.dart';
import 'package:bujuan/pages/setting/user_setting_view.dart';
import 'package:bujuan/pages/talk/talk_view.dart';
import 'package:bujuan/pages/today/today_view.dart';
import 'package:bujuan/pages/user/user_view.dart';

import '../pages/artists/artists_view.dart';
import '../pages/local/edit_song_view.dart';
import '../pages/local/local_view.dart';
import '../pages/login/login.dart';
import '../pages/play_list/playlist_view.dart';
import '../pages/search/search_view.dart';
import '../pages/splash_page.dart';
import '../pages/update/update_view.dart';

abstract class Routes {
  Routes._();

  static const home = _Paths.home;
  static const index = _Paths.index;
  static const user = _Paths.user;
  static const details = _Paths.details;
  static const splash = _Paths.splash;
  static const setting = _Paths.setting;
  static const playlist = _Paths.playlist;
  static const login = _Paths.login;
  static const search = _Paths.search;
  static const talk = _Paths.talk;
  static const today = _Paths.today;
  static const cloud = _Paths.cloud;
  static const artists = _Paths.artists;
  static const myRadio = _Paths.myRadio;
  static const guide = _Paths.guide;
  static const userSetting = _Paths.userSetting;
  static const mv = _Paths.mv;
  static const update = _Paths.update;
  static const local = _Paths.local;
  static const editSong = _Paths.editSong;
  static const localSong = _Paths.localSong;
  static const radioDetails = _Paths.radioDetails;
}

abstract class _Paths {
  _Paths._();

  static const home = '/home';
  static const index = 'index';
  static const user = 'user';
  static const local = 'local';
  static const search = 'search';
  static const playlist = 'playlist';
  static const details = '/details';
  static const setting = '/setting';
  static const splash = '/splash';
  static const login = '/login';
  static const talk = '/talk';
  static const today = 'today';
  static const cloud = 'cloud';
  static const artists = 'artists';
  static const myRadio = 'myRadio';
  static const radioDetails = 'radioDetails';
  static const guide = '/guide';
  static const userSetting = '/userSetting';
  static const mv = '/mv';
  static const update = '/update';
  static const editSong = '/editSong';
  static const localSong = 'localSong';
}

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: Routes.home, page: HomeView, deferredLoading: true, children: [
      AutoRoute(path: Routes.user, page: UserView, initial: true, deferredLoading: true),
      AutoRoute(path: Routes.cloud, page: AlbumView),
      AutoRoute(path: Routes.playlist, page: PlayListView),
      AutoRoute(path: Routes.index, page: MainView),
      AutoRoute(path: Routes.today, page: TodayView),
      AutoRoute(path: Routes.search, page: SearchView),
      AutoRoute(path: Routes.artists, page: ArtistsView),
      AutoRoute(path: Routes.myRadio, page: MyRadioView),
      AutoRoute(path: Routes.radioDetails, page: RadioDetailsView),
      AutoRoute(path: Routes.local, page: LocalView),
      AutoRoute(path: Routes.localSong, page: LocalSongView),
    ]),
    AutoRoute(path: Routes.splash, page: SplashPage, initial: true, deferredLoading: true),
    AutoRoute(path: Routes.login, page: LoginView),
    AutoRoute(path: Routes.talk, page: TalkView),
    AutoRoute(path: Routes.setting, page: SettingView),
    AutoRoute(path: Routes.guide, page: GuideView),
    AutoRoute(path: Routes.userSetting, page: UserSettingView),
    AutoRoute(path: Routes.mv, page: MvView),
    AutoRoute(path: Routes.update, page: UpdateView),
    AutoRoute(path: Routes.editSong, page: EditSongView),
  ],
)
class $RootRouter {}
