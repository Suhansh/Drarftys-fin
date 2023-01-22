import 'dart:async';
import 'dart:io';
import '/apiservice/Api_Header.dart';
import '/apiservice/Apiservice.dart';
import '/custom/loader_custom_widget.dart';
import '/trimmer_addition/trimmer_view.dart';
import '/widget/MarqueWidget.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import '/util/custom_countdown_progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '/util/constants.dart';
import '/screen/upload_video/uploadvideohalf.dart';
import '/screen/initialize_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../addMusic.dart';

List<CameraDescription> cameras = [];

//ignore: must_be_immutable
class UploadVideoScreen extends StatefulWidget {
  final addMusicId;
  String? musicPath;

  UploadVideoScreen({Key? key, this.addMusicId, this.musicPath})
      : super(key: key);

  @override
  _UploadVideoScreen createState() => _UploadVideoScreen();
}

IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    default:
      throw ArgumentError('Unknown lens direction');
  }
}

void logError(String code, String? message) {
  if (message != null) {
    if (kDebugMode) {
      print('Error: $code\nError Message: $message');
    }
  } else {
    if (kDebugMode) {
      print('Error: $code');
    }
  }
}

class _UploadVideoScreen extends State<UploadVideoScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  VideoPlayerController? videoController;
  bool enableAudio = true;
  double minAvailableExposureOffset = 0.0;
  double maxAvailableExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late AnimationController _exposureModeControlRowAnimationController;
  late AnimationController _focusModeControlRowAnimationController;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  bool showCamera = true;
  bool showVideo = false;
  bool showAllButton = true;
  bool showSpinner = false;
  String? musicName = '';
  String actualAudio = '';
  String songId = '';
  final assetsAudioPlayer = AssetsAudioPlayer();
  String? videoPath;
  bool videoRecorded = false;
  bool threeSec = false;
  bool fiveSec = false;
  bool eightSec = false;
  bool tenSec = false;
  late List<CameraDescription> _availableCameras;
  int _pointers = 0;
  Timer? _timer;
  int countdown = 0;
  int videoTime = 15;
  int? selectedCameraIdx;
  CountDownController countDownController = CountDownController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    print("camera call");
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.isNotEmpty) {
        setState(() {
          selectedCameraIdx = 0;
          print("camera success");
        });
        // _onCameraSwitched(cameras[selectedCameraIdx!]).then((void v) {});
        _onCameraSwitched(cameras[0]).then((void v) {});
      }
    }).catchError((err) {
      if (kDebugMode) {
        print('camera faild');
        print('Error: $err.code\nError Message: $err.message');
      }
    });
    controller = CameraController(cameras[0], ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.yuv420);
    _getAvailableCameras();
    if (widget.addMusicId == null) {
    } else {
      callApiForSongRequest(widget.addMusicId);
      onAudioModeButtonPressed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    _timer!.cancel();
    videoController!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countdown == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            countdown--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // CameraDescription selectedCamera = cameras[selectedCameraIdx];
    // CameraLensDirection lensDirection = selectedCamera.lensDirection;
    var deviceRatio = size.width / size.height;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.black54),
    );

    return SafeArea(
      child: WillPopScope(
        onWillPop: _onPressBackButton,
        child: Scaffold(
          key: _scaffoldKey,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: Stack(
              children: <Widget>[
                //for camera
                Visibility(
                  visible: showCamera,
                  child: GestureDetector(
                    child: Center(
                      child: Transform.scale(
                        scale: (!controller!.value.isInitialized)
                            ? 1
                            : controller!.value.aspectRatio / deviceRatio,
                        child: AspectRatio(
                          aspectRatio: (!controller!.value.isInitialized)
                              ? 1
                              : controller!.value.aspectRatio,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Center(
                                      child: (!controller!.value.isInitialized)
                                          ? const CustomLoader()
                                          : _cameraPreviewWidget(),
                                    ),
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onDoubleTap: () {
                      _onSwitchCamera();
                    },
                  ),
                ),

                Visibility(
                  visible: showAllButton,
                  child: Positioned(
                    top: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 30),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(enableAudio
                                  ? Icons.music_note
                                  : Icons.music_off),
                              color: Colors.blue,
                              onPressed: controller != null
                                  ? onAudioModeButtonPressed
                                  : null,
                            ),
                            MarqueeWidget(
                              direction: Axis.horizontal,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    this.context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddMusicScreen(
                                        fromVideoUpload: true,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      // margin: EdgeInsets.only(
                                      //     left: 10, right: 5, top: 0),
                                      padding: const EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                          "images/small_music_note.svg"),
                                    ),
                                    Text(
                                      () {
                                        if (musicName != '') {
                                          return musicName;
                                        } else {
                                          return "Add a Music";
                                        }
                                      }()!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          color: Color(Constants.whitetext),
                                          fontFamily: Constants.appFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Are you sure?'),
                                    content: const Text('Do you want go back'),
                                    actions: <Widget>[
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(this.context)
                                                .pop(false);
                                          },
                                          icon: const Text("NO")),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            // _audioPlayer.pause();
                                            assetsAudioPlayer.pause();
                                            videoController?.pause();
                                            controller?.dispose();
                                            // timer?.cancel();
                                            _timer?.cancel();
                                            Navigator.of(this.context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        InitializeScreen(0)));
                                          },
                                          icon: const Text("YES"))
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset("images/close.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: showAllButton,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: ScreenUtil().setHeight(55),
                      color: Colors.transparent.withOpacity(0.3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                videoTime = 15;
                                // countDownController = CountDownController();
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: videoTime == 15
                                      ? Colors.white60
                                      : Colors.transparent.withOpacity(0.3),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              child: Text(
                                "15s",
                                style: TextStyle(
                                    color: Color(Constants.whitetext),
                                    fontFamily: Constants.appFont,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 80, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///effects button
                        Visibility(
                          visible: showAllButton,
                          child: Expanded(
                            flex: 1,
                            child: InkWell(
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: const [],
                              ),
                            ),
                          ),
                        ),

                        ///record button
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              if (controller != null &&
                                  controller!.value.isInitialized &&
                                  !controller!.value.isRecordingVideo) {
                                setState(() {
                                  countDownController.start();
                                  showAllButton = false;
                                });
                                onVideoRecordButtonPressed();
                                setState(() {
                                  Future.delayed(
                                      Duration(seconds: videoTime.toInt()), () {
                                    if (showCamera) onStopButtonPressed();
                                  });
                                });
                              } else {
                                onStopButtonPressed();
                              }
                            },
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: CountDownProgressIndicator(
                                      controller: countDownController,
                                      valueColor:
                                          Color(Constants.lightbluecolor),
                                      backgroundColor: Colors.white54,
                                      initialPosition: 0,
                                      duration: videoTime,
                                      onComplete: () => null,
                                      autostart: false,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color:
                                              Color(Constants.lightbluecolor),
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// upload button
                        Visibility(
                          visible: showAllButton,
                          child: Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.video,
                                    allowCompression: false,
                                  );
                                  if (result != null) {
                                    File file = File(result.files.single.path!);
                                    Navigator.of(this.context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return TrimmerView(
                                          file: file,
                                          onVideoSave: (output) async {
                                            setState(() {
                                              if (kDebugMode) {
                                                print("outputPath $output");
                                              }
                                              videoPath = output;
                                            });
                                            if (kDebugMode) {
                                              print("videoPath $videoPath");
                                            }
                                            Navigator.pop(this.context);
                                            Navigator.of(this.context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UploadVideoHalfScreen(
                                                  videoPath: videoPath,
                                                  musicPath: widget.musicPath,
                                                  songId: songId,
                                                  isSong: false,
                                                  videoLength: videoTime,
                                                  fromWhere: 'gallery',
                                                  customMusic: actualAudio,
                                                ),
                                              ),
                                            );
                                          },
                                          maxLength: double.parse(
                                              videoTime.toString()),
                                          sound: widget.musicPath,
                                        );
                                      }),
                                    );
                                  }
                                },
                                // onTap: getVideoGallery,
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child:
                                          SvgPicture.asset("images/upload.svg"),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Upload",
                                        style: TextStyle(
                                            color: Color(Constants.whitetext),
                                            fontSize: 14,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Visibility(
                  visible: showAllButton,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(left: 10, bottom: 10),
                            width: 100.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///timer
                                InkWell(
                                    onTap: () {
                                      _openTimerBottomSheet();
                                    },
                                    child: _getSocialAction(
                                        icon: "images/timer.svg",
                                        title: "Timer")),

                                ///Flip
                                InkWell(
                                    onTap: () {
                                      _toggleCameraLens();
                                    },
                                    child: _getSocialAction(
                                        icon: "images/flip.svg",
                                        title: "Flip")),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      showVideo = false;
                      showAllButton = true;
                    });
                  },
                  child: Visibility(
                    visible: showVideo,
                    child: _thumbnailWidget(),
                  ),
                ),
                0 < countdown
                    ? Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '$countdown',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 80,
                              ),
                            )),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onPressBackButton() async {
    // return Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => HomeScreen(0)));
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to go back'),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(this.context).pop(false);
                  },
                  icon: const Text("NO")),
              const SizedBox(width: 10.0),
              IconButton(
                  onPressed: () {
                    // _audioPlayer.pause();
                    assetsAudioPlayer.pause();
                    videoController?.pause();
                    controller?.dispose();
                    // timer?.cancel();
                    _timer?.cancel();
                    Navigator.of(this.context).push(MaterialPageRoute(
                        builder: (context) => InitializeScreen(0)));
                  },
                  icon: const Text("YES")),
            ],
          ),
        ) as FutureOr<bool>? ??
        false;
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (details) => onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller?.setZoomLevel(_currentScale);
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    final VideoPlayerController? localVideoController = videoController;

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          localVideoController == null
              ? Container()
              : SizedBox(
                  child: Container(
                    child: Center(
                      child: AspectRatio(
                          aspectRatio: localVideoController.value.size != null
                              ? localVideoController.value.aspectRatio
                              : 1.0,
                          child: VideoPlayer(localVideoController)),
                    ),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.pink)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
        ],
      ),
    );
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        // showInSnackBar(
        //     'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        // The exposure mode is currently not supported on the web.
        ...(!kIsWeb
            ? [
                cameraController
                    .getMinExposureOffset()
                    .then((value) => minAvailableExposureOffset = value),
                cameraController
                    .getMaxExposureOffset()
                    .then((value) => maxAvailableExposureOffset = value)
              ]
            : []),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (controller != null) {
      onNewCameraSelected(controller!.description);
    }
  }

  void onVideoRecordButtonPressed() {
    setState(() {
      videoRecorded = true;
      // showText = false;
    });
    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    setState(() {
      showSpinner = false;
      videoRecorded = false;
    });
    stopVideoRecording().then((file) async {
      if (kDebugMode) {
        print("the file path is ${file?.path ?? ""}");
      }
      late String filePath;
      if (Platform.isAndroid) {
        final Directory? appDirectory = await (getExternalStorageDirectory());
        final String videoDirectory = '${appDirectory!.path}/Videos';
        await Directory(videoDirectory).create(recursive: true);
        /*final String currentTime =
        "$countVideos" + DateTime.now().millisecondsSinceEpoch.toString();*/
        final String currentTime =
            DateTime.now().millisecondsSinceEpoch.toString();
        filePath = '$videoDirectory/$currentTime.mp4';
      } else {
        final Directory? appDirectory =
            await (getApplicationDocumentsDirectory());
        final String videoDirectory = '${appDirectory!.path}/Videos';
        await Directory(videoDirectory).create(recursive: true);
        final String currentTime =
            DateTime.now().millisecondsSinceEpoch.toString();
        filePath = '$videoDirectory/$currentTime.mp4';
      }
      file?.saveTo(filePath);
      videoPath = filePath;
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      bool isSong = false;
      if (widget.musicPath == null && widget.musicPath == "") {
        widget.musicPath = "";
        isSong = true;
      }
      setState(() {
        showCamera = false;
        showVideo = true;
      });

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UploadVideoHalfScreen(
          videoPath: videoPath,
          musicPath: widget.musicPath,
          videoLength: videoTime,
          isSong: isSong,
          songId: songId,
          fromWhere: 'camera',
          customMusic: actualAudio,
        ),
      ));
    });
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      /// prefer using rename as it is probably faster
      /// if same directory path
      return await sourceFile.rename(newPath);
    } catch (e) {
      /// if rename fails, copy the source file
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }

  Future<void> startVideoRecording() async {
    setState(() {});
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      // showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    if (enableAudio == false) {
      // _audioPlayer.pause();
      assetsAudioPlayer.play();
    }
    try {
      // await controller!.startVideoRecording(filePath);
      // videoPath = filePath;
      await controller!.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
    // return filePath;
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }
    // timer!.cancel();
    // _audioPlayer.pause();
    assetsAudioPlayer.pause();

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    // showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Widget _getSocialAction({required String title, required String icon}) {
    return Container(
        margin: const EdgeInsets.only(top: 5.0, right: 5),
        width: 60.0,
        height: 50.0,
        child: Column(children: [
          SvgPicture.asset(icon),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ]));
  }

  void _openTimerBottomSheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Color(Constants.bgblack),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(50),
                    child: InkWell(
                      onTap: () {
                        mystate(() {
                          countdown = 3;
                          Navigator.pop(this.context);
                          startTimer();
                          Timer(const Duration(milliseconds: 3000), () {
                            setState(() {
                              countDownController.start();
                              showAllButton = false;
                              onVideoRecordButtonPressed();
                            });
                            //after 3 seconds this will be called,
                            Future.delayed(Duration(seconds: videoTime.toInt()),
                                () {
                              if (showCamera) onStopButtonPressed();
                            });
                            threeSec = !threeSec;
                            setState(() {});
                          });
                          threeSec = !threeSec;
                          fiveSec = false;
                          eightSec = false;
                          tenSec = false;
                        });
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "3 Seconds",
                            style: TextStyle(
                                color: threeSec
                                    ? Color(Constants.whitetext)
                                    : Color(Constants.greytext),
                                fontSize: 16,
                                fontFamily: Constants.appFont),
                          )),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(50),
                    child: InkWell(
                      onTap: () {
                        mystate(() {
                          countdown = 5;
                          Navigator.pop(this.context);
                          startTimer();
                          Timer(const Duration(milliseconds: 5000), () {
                            setState(() {
                              countDownController.start();
                              showAllButton = false;
                              onVideoRecordButtonPressed();
                            });
                            Future.delayed(Duration(seconds: videoTime.toInt()),
                                () {
                              if (showCamera) onStopButtonPressed();
                            });
                            fiveSec = !fiveSec;
                            setState(() {});
                          });
                          fiveSec = !fiveSec;
                          threeSec = false;
                          eightSec = false;
                          tenSec = false;
                        });
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "5 Seconds",
                            style: TextStyle(
                                color: fiveSec
                                    ? Color(Constants.whitetext)
                                    : Color(Constants.greytext),
                                fontSize: 16,
                                fontFamily: Constants.appFont),
                          )),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(50),
                    child: InkWell(
                      onTap: () {
                        mystate(() {
                          countdown = 8;
                          Navigator.pop(this.context);
                          startTimer();
                          Timer(const Duration(milliseconds: 8000), () {
                            setState(() {
                              countDownController.start();
                              showAllButton = false;
                              onVideoRecordButtonPressed();
                            });
                            Future.delayed(Duration(seconds: videoTime.toInt()),
                                () {
                              if (showCamera) onStopButtonPressed();
                            });
                            // onVideoRecordButtonPressed();
                            eightSec = !eightSec;
                            setState(() {});
                          });
                          eightSec = !eightSec;
                          threeSec = false;
                          fiveSec = false;
                          tenSec = false;
                        });
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "8 Seconds",
                            style: TextStyle(
                                color: eightSec
                                    ? Color(Constants.whitetext)
                                    : Color(Constants.greytext),
                                fontSize: 16,
                                fontFamily: Constants.appFont),
                          )),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(50),
                    child: InkWell(
                      onTap: () {
                        mystate(() {
                          countdown = 10;
                          Navigator.pop(this.context);
                          startTimer();
                          Timer(const Duration(milliseconds: 10000), () {
                            setState(() {
                              countDownController.start();
                              showAllButton = false;
                              onVideoRecordButtonPressed();
                            });
                            Future.delayed(Duration(seconds: videoTime.toInt()),
                                () {
                              if (showCamera) onStopButtonPressed();
                            });
                            // onVideoRecordButtonPressed();
                            tenSec = !tenSec;
                            setState(() {});
                          });
                          tenSec = !tenSec;
                          threeSec = false;
                          fiveSec = false;
                          eightSec = false;
                        });
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "10 Seconds",
                            style: TextStyle(
                                color: tenSec
                                    ? Color(Constants.whitetext)
                                    : Color(Constants.greytext),
                                fontSize: 16,
                                fontFamily: Constants.appFont),
                          )),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  void callApiForSongRequest(int? id) {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .singleMusicRequest(id)
        .then((response) async {
      setState(() {
        showSpinner = false;
      });
      if (response.success!) {
        setState(() {
          musicName = response.data!.title;
          songId = response.data!.id.toString();
          actualAudio = response.data!.imagePath! + response.data!.audio!;
        });
        assetsAudioPlayer.open(
          Audio.network(actualAudio),
          autoStart: false,
        );
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  // get available cameras
  Future<void> _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 50));
    _availableCameras = await availableCameras();
    await Future.delayed(const Duration(milliseconds: 200));
    _initCamera(_availableCameras.first);
  }

  // init camera
  Future<void> _initCamera(CameraDescription description) async {
    final CameraController cameraController = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.yuv420,
      // imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller = cameraController;

    await Future.delayed(const Duration(milliseconds: 200));
    try {
      await controller!.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = controller!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      if (kDebugMode) {
        print('Asked camera not available');
      }
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx! < cameras.length - 1 ? selectedCameraIdx! + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx!];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg);

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller!.value.hasError) {
        if (kDebugMode) {
          print('Camera error ${controller!.value.errorDescription}');
        }
      }
    });
    if (mounted) {
      setState(() {});
    }
  }
}
