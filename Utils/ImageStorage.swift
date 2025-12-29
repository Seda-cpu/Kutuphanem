//
//  ImageStorage.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 29.12.2025.
//

import UIKit

enum ImageStorage {

    static func saveImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }

        let fileName = UUID().uuidString + ".jpg"
        let url = documentsDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: url)
            return fileName
        } catch {
            print("❌ Görsel kaydedilemedi:", error)
            return nil
        }
    }

    static func loadImage(named name: String) -> UIImage? {
        let url = documentsDirectory.appendingPathComponent(name)
        return UIImage(contentsOfFile: url.path)
    }

    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

