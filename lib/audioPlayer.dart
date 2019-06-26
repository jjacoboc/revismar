import 'dart:async';
import 'dart:io';
import 'constants.dart';
import 'sharedPreferencesHelper.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class AudioApp extends StatefulWidget {
  @override
  _AudioAppState createState() => new _AudioAppState();
}

class _AudioAppState extends State<AudioApp> {
  bool _isLoading = true;
  String year = '';
  String edition = '';
  String article = '';
  String author = '';
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration
          .toString()
          .split('.')
          .first : '';

  get positionText =>
      position != null ? position
          .toString()
          .split('.')
          .first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    _loadFile();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
          if (s == AudioPlayerState.PLAYING) {
            setState(() => duration = audioPlayer.duration);
          } else if (s == AudioPlayerState.STOPPED) {
            onComplete();
            setState(() {
              position = duration;
            });
          }
        }, onError: (msg) {
          setState(() {
            playerState = PlayerState.stopped;
            duration = new Duration(seconds: 0);
            position = new Duration(seconds: 0);
          });
        });
  }

  Future _playLocal() async {
    await audioPlayer.play(localFilePath, isLocal: true);
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Future _loadFile() async {
    Preference.load();
    String strYear = Preference.getString('year');
    String strEdition = Preference.getString('edition');
    String strOrder = Preference.getString('order');
    String strArticle = Preference.getString('article');
    String strAuthor = Preference.getString('author');

    var response = await get(Uri.encodeFull(
        Constants.url_audio + strYear + "/" + strEdition + "/" + strOrder));
    var bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    final file = new File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        localFilePath = file.path;
        year = strYear;
        edition = strEdition;
        article = strArticle;
        author = strAuthor;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Material(
        //elevation: 2.0,
        //color: Colors.grey[200],

          child: new Center(
            child: _isLoading
                ? new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text('cargando audio...',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times New Roman')),
                )
              ],
            ) : Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(2, 29, 38, 1.0),
                      Color.fromRGBO(2, 29, 38, 0.7)
                    ],
                  )
              ),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Revista de Marina ' + year,
                          style:
                          TextStyle(fontSize: 24, fontFamily: 'Arial', color: Colors.white),
                        ),
                        Text('Edición #' + edition,
                          style:
                          TextStyle(fontSize: 18, fontFamily: 'Arial', fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ],
                    ),
                    _buildPlayer(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text('Artículo:', style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(article,
                              style: TextStyle(fontSize: 13, fontFamily: 'Arial', color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5.0, top: 20.0),
                            child: Text('Redactado por:', style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text(author,
                              style: TextStyle(fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Arial', color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
            ),
          )
      ),
    );
  }

  Widget _buildPlayer() {
      return Container(
        color: Colors.white,
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: isPlaying ? null : () => _playLocal(),
                          iconSize: 64.0,
                          icon: new Icon(Icons.play_arrow),
                          color: Color.fromRGBO(2, 29, 38, 0.9)
                      ),
                      IconButton(
                          onPressed: isPlaying ? () => pause() : null,
                          iconSize: 64.0,
                          icon: new Icon(Icons.pause),
                          color: Color.fromRGBO(2, 29, 38, 0.9)
                      ),
                      IconButton(
                          onPressed: isPlaying || isPaused
                              ? () => stop()
                              : null,
                          iconSize: 64.0,
                          icon: new Icon(Icons.stop),
                          color: Color.fromRGBO(2, 29, 38, 0.9)
                      ),
                    ]
                ),
                duration == null ?
                Container()
                    : Slider(
                        value: position?.inMilliseconds?.toDouble() ?? 0.0,
                        onChanged: (double value) =>
                          audioPlayer.seek((value / 1000).roundToDouble()),
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble(),
                        activeColor: Color.fromRGBO(2, 29, 38, 0.9),
                        inactiveColor: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        onPressed: () => mute(true),
                        icon: new Icon(Icons.volume_off),
                        color: Color.fromRGBO(2, 29, 38, 0.9)
                    ),
                    IconButton(
                        onPressed: () => mute(false),
                        icon: new Icon(Icons.volume_up),
                        color: Color.fromRGBO(2, 29, 38, 0.9)
                    ),
                  ],
                ),
              ]
          )
      );
  }

}
