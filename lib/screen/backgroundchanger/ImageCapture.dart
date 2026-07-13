// import 'dart:typed_data';
// import 'package:opencv_4/opencv_4.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class OpenCVBackgroundRemover {
//   final ImagePicker _picker = ImagePicker();

//   // Function to pick an image from the gallery or camera
//   Future<void> pickImageAndRemoveBackground() async {
//     final XFile? imageFile = await _picker.pickImage(source: ImageSource.camera); // Use ImageSource.gallery for gallery

//     if (imageFile == null) {
//       print("No image selected.");
//       return;
//     }

//     // Load image as bytes
//     File image = File(imageFile.path);
//     Uint8List imageBytes = await image.readAsBytes();

//     // Convert image to OpenCV format and process
//     Uint8List processedImage = await removeBackground(imageBytes);

//     // Save or display the processed image
//     saveProcessedFile(processedImage);
//   }

//   // Function to remove the background using OpenCV
//   Future<Uint8List> removeBackground(Uint8List inputImage) async {
//     // Convert the image to HSV color space
//     var hsvImage = await Cv2.cvtColor(inputImage, ImgProc.colorBGR2HSV);

//     // Define the range of the background color you want to remove (e.g., white background)
//     // Adjust the lower and upper range according to the background color
//     List<int> lowerRange = [0, 0, 200]; // Lower bound for white color
//     List<int> upperRange = [255, 255, 255]; // Upper bound for white color

//     // Create a mask with the specified color range
//     var mask = await Cv2.inRange(hsvImage, lowerRange, upperRange);

//     // Invert the mask to get the foreground
//     var invertedMask = await Cv2.bitwiseNot(mask);

//     // Apply the mask to the image
//     var result = await Cv2.bitwiseAnd(inputImage, inputImage, mask: invertedMask);

//     // Change the background to blue (0, 0, 255 in BGR)
//     var blueBackground = [255, 0, 0]; // Blue background color
//     var finalImage = await Cv2.addWeighted(result, 1, mask, 0.5, 0, outputType: blueBackground);

//     return finalImage;
//   }

//   // Function to save the processed file or display it
//   void saveProcessedFile(Uint8List processedImage) {
//     // Code to save or display the processed image
//     // For example, you could display it in the Flutter app or save it to the device
//     print("Background removed successfully.");
//   }
// }

