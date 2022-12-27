import 'package:fish/services/camera.service.dart';
import 'package:fish/services/ml_service.dart';
import 'package:fish/services/face_detector_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<FaceDetectorService>(() => FaceDetectorService());
  locator.registerLazySingleton<MLService>(() => MLService());
}
