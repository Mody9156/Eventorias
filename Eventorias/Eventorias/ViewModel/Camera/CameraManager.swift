//
//  CameraPreview.swift
//  Eventorias
//
//  Created by KEITA on 17/12/2024.
//
import Foundation
import SwiftUI
import AVFoundation
import Photos


class CameraManager : NSObject, ObservableObject {}

extension CameraManager {
    func checkPermission() throws {
        if AVCaptureDevice.authorizationStatus(for: .video) == .denied { throw Error.cameraPermissionNotGranted}
    }
}

extension CameraManager { enum Error: Swift.Error {
    case cameraPermissionNotGranted
}}
