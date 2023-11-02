// import 'package:camera/camera.dart';
// import 'package:image/image.dart' as imglib;

// Future<List<int>?> convertImagetoPng(CameraImage image) async {
//   try {
//     imglib.Image img = _convertYUV420(image);

//     imglib.PngEncoder pngEncoder = imglib.PngEncoder();

//     // Convert to png
//     List<int> png = pngEncoder.encode(img);
//     return png;
//   } catch (e) {
//     print(">>>>>>>>>>>> ERROR:$e");
//   }
//   return null;
// }

// // CameraImage YUV420_888 -> PNG -> Image (compresion:0, filter: none)
// // Black
// imglib.Image _convertYUV420(CameraImage image) {
//   var img = imglib.Image(
//       width: image.width, height: image.height); // Create an Image buffer

//   Plane plane = image.planes[0];
//   const int shift = (0xFF << 24);

//   // Fill the image buffer with plane[0] from YUV420_888
//   for (int y = 0; y < image.height; y++) {
//     for (int x = 0; x < image.width; x++) {
//       int planeOffset = y * image.width + x;
//       final pixelColor = plane.bytes[planeOffset];
//       // Color: 0xFF  FF  FF  FF
//       //        A   B   G   R
//       // Calculate pixel color
//       var newVal = shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

//       img.setPixel(x, y, newVal);
//     }
//   }

//   return img;
// }

// Future<imglib.Image> convertYUV420toImage(CameraImage image) async {
//   try {
//     final int width = image.width;
//     final int height = image.height;

//     // imgLib -> Image package from https://pub.dartlang.org/packages/image
//     var img = imglib.Image(width: width,height: height); // Create Image buffer

//     // Fill image buffer with plane[0] from YUV420_888
//     for (int x = 0; x < width; x++) {
//       for (int y = 0; y < height; y++) {
//         final pixelColor = image.planes[0].bytes[y * width + x];
//         // color: 0x FF  FF  FF  FF
//         //           A   B   G   R
//         // Calculate pixel color
//         img.data?[y * width + x] =
//             (0xFF << 24) | (pixelColor << 16) | (pixelColor << 8) | pixelColor;
//       }
//     }

//     imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0, filter: 0);
//     List<int> png = pngEncoder.encode(img);

//     return imglib.Image.memory(png);
//   } catch (e) {
//     print(">>>>>>>>>>>> ERROR:$e");
//   }
//   return null;
// }


// imglib.Image? convertCameraImageToImage(CameraImage image) {
//   if (image.format.group == ImageFormatGroup.yuv420) {
//     // Check if the image format is YUV420
//     Plane? yPlane = image.planes[0]; // Y plane
//     Plane? uPlane = image.planes[1]; // U plane
//     Plane? vPlane = image.planes[2]; // V plane

//     // Calculate the dimensions of the U and V planes
//     int uvRowStride = uPlane.bytesPerRow;
//     int uvPixelStride = uPlane.bytesPerPixel!;

//     int width = image.width;
//     int height = image.height;

//     // Create an empty imglib.Image object
//     var img = imglib.Image(width: width,height: height);

//     // Fill the image with YUV data
//     for (int y = 0; y < height; y++) {
//       for (int x = 0; x < width; x++) {
//         int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);

//         int yValue = yPlane.bytes[y * width + x];
//         int uValue = uPlane.bytes[uvIndex];
//         int vValue = vPlane.bytes[uvIndex];

//         // Convert YUV to RGB
//         int r = (yValue + 1.13983 * (vValue - 128)).round();
//         int g = (yValue - 0.39465 * (uValue - 128) - 0.5806 * (vValue - 128)).round();
//         int b = (yValue + 2.03211 * (uValue - 128)).round();

//         // Ensure the values are in the valid range
//         r = r.clamp(0, 255);
//         g = g.clamp(0, 255);
//         b = b.clamp(0, 255);

//         // Create a 32-bit color (0xAARRGGBB) and set the pixel in the imglib.Image
//         int color = (0xFF << 24) | (r << 16) | (g << 8) | b;
//         img.setPixel(x, y, color);
//       }
//     }

//     return img;
//   }

//   return null; // Return null if the image format is not YUV420
// }