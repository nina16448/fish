import 'package:fish/locator.dart';
import 'package:fish/services/camera.service.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class FaceDetectorService {
  CameraService _cameraService = locator<CameraService>();

  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => _faceDetector;

  List<Face> _faces = [];
  List<Face> get faces => _faces;
  bool get faceDetected => _faces.isNotEmpty;

  void initialize() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    // _faceDetector = FaceDetector(
    //     options: FaceDetectorOptions(
    //         performanceMode: FaceDetectorMode.fast,
    //         enableContours: true,
    //         enableClassification: true));
  }

  Future<void> detectFacesFromImage(CameraImage image) async {
    if (image.planes.isNotEmpty) {
      InputImageData _firebaseImageMetadata = InputImageData(
        // imageRotation: _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
        // inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21,
        // size: Size(image.planes[0].bytesPerRow.toDouble(), image.height.toDouble()),
        // planeData: image.planes.map(
        //   (Plane plane) {
        //     return InputImagePlaneMetadata(
        //       bytesPerRow: plane.bytesPerRow,
        //       height: plane.height,
        //       width: plane.width,
        //     );
        //   },
        // ).toList(),
        inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw)!,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        imageRotation: InputImageRotation.rotation90deg,
        planeData: image.planes
            .map((Plane plane) => InputImagePlaneMetadata(
                  bytesPerRow: plane.bytesPerRow,
                  height: plane.height,
                  width: plane.width,
                ))
            .toList(),
      );

      //   final ByteData allBytes = ByteData(image.planes[0].bytesPerRow * image.height);

      //   for (Plane plane in image.planes) {
      //     // allBytes.putUint8List(plane.bytes);
      //     allBytes.buffer.asUint8List().setAll(0, plane.bytes);
      //   }

      //   InputImage _firebaseVisionImage = InputImage.fromBytes(
      //     bytes: allBytes.buffer.asUint8List(),
      //     inputImageData: _firebaseImageMetadata,
      //   );

      //   _faces = await _faceDetector.processImage(
      //     InputImage.fromBytes(
      //       bytes: allBytes.buffer.asUint8List(),
      //       inputImageData: _firebaseImageMetadata,
      //     ),
      //   );
      Uint8List bytes = Uint8List.fromList(
        image.planes.fold(<int>[], (List<int> previousValue, element) => previousValue..addAll(element.bytes)),
      );

      _faces = await _faceDetector.processImage(InputImage.fromBytes(
        bytes: bytes,
        inputImageData: _firebaseImageMetadata,
      ));
    }
  }

  ///for new version
  // Future<void> detectFacesFromImage(CameraImage image) async {
  //   // InputImageData _firebaseImageMetadata = InputImageData(
  //   //   imageRotation: _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
  //   //   inputImageFormat: InputImageFormatMethods ?? InputImageFormat.nv21,
  //   //   size: Size(image.width.toDouble(), image.height.toDouble()),
  //   //   planeData: image.planes.map(
  //   //     (Plane plane) {
  //   //       return InputImagePlaneMetadata(
  //   //         bytesPerRow: plane.bytesPerRow,
  //   //         height: plane.height,
  //   //         width: plane.width,
  //   //       );
  //   //     },
  //   //   ).toList(),
  //   // );

  //   final ByteData allBytes = ByteData(image.planes[0].bytesPerRow * image.height);
  //   for (Plane plane in image.planes) {
  //     allBytes.buffer.asUint8List().setAll(0, plane.bytes);
  //   }
  //   final bytes = allBytes.buffer.asUint8List();

  //   final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

  //   InputImageRotation imageRotation = _cameraService.cameraRotation ?? InputImageRotation.rotation0deg;

  //   final inputImageData = InputImageData(
  //     size: imageSize,
  //     imageRotation: imageRotation,
  //     inputImageFormat: InputImageFormat.yuv420,
  //     planeData: image.planes.map(
  //       (Plane plane) {
  //         return InputImagePlaneMetadata(
  //           bytesPerRow: plane.bytesPerRow,
  //           height: plane.height,
  //           width: plane.width,
  //         );
  //       },
  //     ).toList(),
  //   );

  //   InputImage _firebaseVisionImage = InputImage.fromBytes(
  //     bytes: bytes,
  //     inputImageData: inputImageData,
  //   );

  //   _faces = await _faceDetector.processImage(_firebaseVisionImage);
  // }

  dispose() {
    _faceDetector.close();
  }
}
