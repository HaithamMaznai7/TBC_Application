import '../constants/colors.dart';
import '../constants/image_strings.dart';
import '../constants/text_strings.dart';
import 'helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';

class Helpers {
  // Future<File?> pickFile(filepicker.FileType fileType) async {
  //   try {
  //     filepicker.FilePickerResult? result =
  //         await filepicker.FilePicker.platform.pickFiles(
  //       allowMultiple: false,
  //       type: fileType,
  //     );
  //     if (result != null) {
  //       //var fileName = result.files.first.name;
  //       var file = result.files.first;
  //       if (file.extension == 'pdf') {
  //         return File(file.path.toString());
  //       } else {
  //         return FHelper.getSnackBar(
  //             message: 'The file is not PDF, You should to upload PDF file.'.tr,
  //             color: FColors.warning,
  //             icon: Icons.attach_file,
  //             duration: 3);
  //       }
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  //   return null;
  // }

  List<Map<String, String>> generateYearsList() {
    int currentYear = DateTime.now().year + 1;
    List<Map<String, String>> yearsList = [];
    yearsList.add({
        'label': 'none',
        'value': 'none',
    });
    for (int year = 2000; year <= currentYear; year++) {
      yearsList.add({
        'label': year.toString(),
        'value': year.toString(),
      });
    }
    return yearsList;
  }

  String fileToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String result = base64Encode(imageBytes);
    return result;
  }

  String imageWithOutBgInBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String result = base64Encode(imageBytes);
    return result;
  }

  Future<File> base64ToFile(String base64String, String fileName) async {
    List<int> fileBytes = base64Decode(base64String);
    File file = File(fileName);
    file.writeAsBytesSync(fileBytes);
    return file;
  }
}

// class FImage extends StatelessWidget {
//   const FImage({super.key,
//       this.image,
//       this.height = 100,
//       this.width = 100,
//       this.placeHolder});

//   final String? image;
//   final double height;
//   final double width;
//   final Widget? placeHolder;
//   final Widget defaultPlaceHolder =
//     const Icon(Icons.camera_alt, size: 50, color: Colors.grey);
//   @override
//   Widget build(BuildContext context) {
//     if(image == null){
//       if (placeHolder == null) {
//         return EasyImageView(
//           imageProvider: Image.asset(
//             FImages.onError,
//             fit: BoxFit.contain,
//             width: double.infinity, 
//             height: double.infinity,
//           ).image
//         );
//       }
//       else{
//         return placeHolder!;
//       }
//     }
//     else{ 
//       if (image!.startsWith('https://') || image!.startsWith('http://')){
//         return EasyImageView(
//           imageProvider: Image.network(
//             image!,
//             fit: BoxFit.contain,
//             width: double.infinity, 
//             height: double.infinity,
//           ).image
//         );
//         // NetworkImage(url: image!);
//       }
//       else if (image!.startsWith('//s3')){
//         return EasyImageView(
//           imageProvider: Image.network(
//             'https:${image!}',
//             fit: BoxFit.contain,
//             width: double.infinity, 
//             height: double.infinity,
//           ).image
//         );
//       }
//       else{
//         return EasyImageView(
//           imageProvider: Image.memory(
//             base64Decode(image!),
//             fit: BoxFit.contain,
//             width: double.infinity, 
//             height: double.infinity,
//           ).image
//         );
//       }
//     }
  
//   }
// }

// class NetworkImage extends StatefulWidget {
//   const NetworkImage({super.key, required this.url});
//   final String url;

//   @override
//   State<NetworkImage> createState() => _NetworkImageState();
// }

// class _NetworkImageState extends State<NetworkImage> {
//   double progress = 0.0;
//   bool isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Center(
//           child: EasyImageView(imageProvider:  
//             Image.network(
//               widget.url,
//               fit: BoxFit.contain,
//               width: double.infinity, 
//               height: double.infinity,
//             ).image 
//           )
//         ),
//         isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   color: FColors.primary,
//                 ),
//               )
//             : const SizedBox(),
//       ],
//     );
//   }
// }
