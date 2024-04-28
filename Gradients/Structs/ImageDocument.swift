//
//  ImageDocument.swift
//  Gradients
//
//  Created by Matt Sullivan on 28/04/2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ImageDocument: FileDocument {
    var image: UIImage?

    static var readableContentTypes: [UTType] { [.png] }

    init(image: UIImage?) {
        self.image = image
    }

    init(configuration: ReadConfiguration) throws {
        // Not needed for exporting
        image = nil
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let image = image, let data = image.pngData() else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileWriteUnknownError, userInfo: nil)
        }
        return .init(regularFileWithContents: data)
    }
}
