import 'dart:async';
import 'dart:io';
import 'sharedPreferencesHelper.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

typedef void OnError(Exception exception);

const kUrl = "http://www.rxlabz.com/labz/audio2.mp3";
const kUrl2 = "http://www.rxlabz.com/labz/audio.mp3";

enum PlayerState { stopped, playing, paused }

class AudioApp extends StatefulWidget {
  @override
  _AudioAppState createState() => new _AudioAppState();
}

class _AudioAppState extends State<AudioApp> {
  bool _isLoading = true;
  String year = '';
  String edition = '';
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

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

  Future play() async {
    await audioPlayer.play(kUrl);
    setState(() {
      playerState = PlayerState.playing;
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
    //final bytes = await _loadFileBytes(kUrl, onError: (Exception exception) => print('_loadFile => exception $exception'));
    Preference.load();
    String strYear = Preference.getString('year');
    String strEdition = Preference.getString('edition');

    var response = await get(Uri.encodeFull(
        "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/audio/" +
            strYear +
            "/" +
            strEdition));
    var bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    final file = new File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        localFilePath = file.path;
        year = strYear;
        edition = strEdition;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
          child: new Material(
              elevation: 2.0,
              color: Colors.grey[200],
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
                )
                    : new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          'Revista de Marina ' +
                              year +
                              ', Edición #' +
                              edition,
                          style:
                          TextStyle(fontSize: 24, fontFamily: 'Arial'),
                        ),
                      ),
                      new Material(child: _buildPlayer()),
                    ]),
              )
      ),
    );
  }

  Widget _buildPlayer() => new Container(
      padding: new EdgeInsets.all(16.0),
      child: new Column(mainAxisSize: MainAxisSize.min, children: [
        new Row(mainAxisSize: MainAxisSize.min, children: [
          new IconButton(
              onPressed: isPlaying ? null : () => _playLocal(),
              iconSize: 64.0,
              icon: new Icon(Icons.play_arrow),
              color: Colors.cyan),
          new IconButton(
              onPressed: isPlaying ? () => pause() : null,
              iconSize: 64.0,
              icon: new Icon(Icons.pause),
              color: Colors.cyan),
          new IconButton(
              onPressed: isPlaying || isPaused ? () => stop() : null,
              iconSize: 64.0,
              icon: new Icon(Icons.stop),
              color: Colors.cyan),
        ]),
        duration == null
            ? new Container()
            : new Slider(
                value: position?.inMilliseconds?.toDouble() ?? 0.0,
                onChanged: (double value) =>
                    audioPlayer.seek((value / 1000).roundToDouble()),
                min: 0.0,
                max: duration.inMilliseconds.toDouble()),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new IconButton(
                onPressed: () => mute(true),
                icon: new Icon(Icons.headset_off),
                color: Colors.cyan),
            new IconButton(
                onPressed: () => mute(false),
                icon: new Icon(Icons.headset),
                color: Colors.cyan),
          ],
        ),
      ]));

}
