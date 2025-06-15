import 'dart:io';
import 'package:camera/camera.dart';
// import 'package:file_picker/file_picker.dart' as filepicker;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/util/constants/sizes.dart';
import 'package:tbc_application/util/device/device_utility.dart';
import 'package:tbc_application/util/helpers/helpers.dart';
import 'package:tbc_application/util/popups/full_screen_loader.dart';

class CameraImagePicker extends StatefulWidget {
  const CameraImagePicker({super.key, this.cameras,required this.onChange});

  final List<CameraDescription>? cameras;
  final Function(String value) onChange;

  @override
  State<CameraImagePicker> createState() => _CameraImagePickerState();
}

class _CameraImagePickerState extends State<CameraImagePicker> {
  late CameraController _controller;
  File? _pictureFile;
  bool _isSelfCam = false;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    FDeviceUtils.hideStatusBar();
    _controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.medium,
    );
    _controller.initialize().then((_) {
      if(!mounted){
        return;
      }
      setState(() {});
    });
  }

  // Future<void> _pickGalleryImage() async {
  //   final result = await filepicker.FilePicker.platform.pickFiles(
  //     type: filepicker.FileType.image,
  //     allowMultiple: false,
  //   );
  //   if (result != null && result.files.isNotEmpty) {
  //     setState(() {
  //       _pictureFile = File(result.files.single.path!);
  //     });
  //   }
  // }
  
  @override
  void dispose() {
    _controller.dispose();
    FDeviceUtils.showStatusBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(!_controller.value.isInitialized){
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(color: FColors.primary,),
        ),
      );
    }
    return Scaffold(
      backgroundColor: FColors.dark,
      body: Padding(
        padding: const EdgeInsets.only(
          top: FSizes.lg * 2,
          bottom: FSizes.lg * 2,
        ),
        child: _pictureFile == null
          ? Stack(
          children: [
             Center(
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    alignment: Alignment.topCenter,
                    turns: _isSelfCam ? 1 : 0,
                    child: SizedBox(
                      height: FDeviceUtils.getScreenHeight(),
                      width: FDeviceUtils.getScreenWidth(),
                      child: CameraPreview(_controller),
                    ),
                  ),
             ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: FDeviceUtils.getScreenWidth(),
                height: FDeviceUtils.getScreenHeight() * .1,
                margin: const EdgeInsets.only(bottom: FSizes.md),
                padding: const EdgeInsets.symmetric(horizontal: FSizes.spaceBtwItems),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: IconButton(
                          onPressed: _changeCamera,
                          icon: const Icon(Icons.sync, color: FColors.white,)
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          isTapped = true;
                        });
                        await Future.delayed(const Duration(milliseconds: 100));
                        setState(() {
                          isTapped = false;
                        });
                        _pick();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        height: 80 ,
                        width: 80 ,
                        padding: EdgeInsets.all(isTapped ? 15 : 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: FColors.white, width: 5),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: FColors.white
                          ),
                        )
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.5),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      // child: IconButton(
                      //     onPressed: _pickGalleryImage,
                      //     icon: const Icon(Iconsax.gallery, color: FColors.white,)
                      // ),
                    ),
                  ],
                ),
              )
            ),
            Align(
                alignment: Alignment.topRight,
                child: Container(
                    margin: const EdgeInsets.all(FSizes.spaceBtwItems),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: FColors.black.withOpacity(.5)
                    ),
                    height: 50,
                    width: 50,
                    child:IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, color: FColors.white,)
                    )
                )
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: const EdgeInsets.all(FSizes.spaceBtwItems),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: FColors.black.withOpacity(.5)
                    ),
                    height: 50,
                    width: 50,
                    child:IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.flash_auto_outlined, color: FColors.white,)
                    )
                )
            ),
          ],
        )
          : InkWell(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.file(_pictureFile!)
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.all(FSizes.sm),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: FColors.primary,
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: IconButton(
                        icon: const Icon(Iconsax.arrow_right_1, color: FColors.white,),
                        onPressed: _processPickedImage,
                      )
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.all(FSizes.sm),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: FColors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: FColors.white,),
                        onPressed: () {
                          setState(() {
                            _pictureFile = null ;
                          });
                        },
                      )
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }

  _pick() async {
    XFile cameraFile = await _controller.takePicture();
    setState(() {
      _pictureFile = File(cameraFile.path);
    });
  }

  void _changeCamera() {
    setState(() {
      _isSelfCam = !_isSelfCam;
      _controller.setDescription(widget.cameras![_isSelfCam ? 1 : 0]);
    });
  }
/*  void _changeZoom(double zoom){
    setState(() {
      _controller.setZoomLevel(zoom) ;
    });
  }*/

  void _processPickedImage(){
    String image = Helpers().fileToBase64(_pictureFile!);
    widget.onChange(image);
    FFullScreenLoader.stopLoading();
  }
}