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


class CameraManager : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var picker: accessCameraView
        
        init(picker: accessCameraView) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.picker.selectedImage = selectedImage
            self.picker.isPresented.wrappedValue.dismiss()
        }
    
    
}


