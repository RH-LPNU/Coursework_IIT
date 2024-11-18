//
//  Ext + Image.swift
//  EasyRent
//
//  Created by Roman Hural on 24.10.2024.
//

import SwiftUI

extension Image {
    @MainActor
    func getUIImage() -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .clipped()

        // Render the SwiftUI image
        if let renderedImage = ImageRenderer(content: image).uiImage {
            // Fix the orientation of the UIImage
            return renderedImage.fixOrientation()
        }
        
        return nil
    }
}

