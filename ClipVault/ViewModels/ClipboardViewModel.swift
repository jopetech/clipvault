import Foundation
import AppKit
import CoreData
import UniformTypeIdentifiers

final class ClipboardViewModel: ObservableObject {
    private let pasteboard = NSPasteboard.general
    private var changeCount: Int
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        self.changeCount = pasteboard.changeCount
        startMonitoring()
    }

    private func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkPasteboard()
        }
    }

    private func checkPasteboard() {
        guard pasteboard.changeCount != changeCount else { return }
        changeCount = pasteboard.changeCount

        guard let item = pasteboard.pasteboardItems?.first else { return }
        guard let type = item.types.first, let data = item.data(forType: type) else { return }

        let entry = ClipboardEntry(context: context)
        entry.id = UUID()
        entry.date = Date()
        entry.originalName = "ClipboardItem"
        entry.fileExtension = UTType(type.rawValue)?.preferredFilenameExtension ?? ""
        entry.type = determineType(for: type)
        entry.contentData = data

        if type == .string {
            entry.previewData = data
        } else if let image = NSImage(data: data) {
            entry.previewData = image.tiffRepresentation
        }

        try? context.save()
    }

    private func determineType(for pasteboardType: NSPasteboard.PasteboardType) -> String {
        if pasteboardType == .string { return "text" }
        if pasteboardType == .png || pasteboardType == .tiff { return "image" }
        return "file"
    }

    func copyToPasteboard(_ entry: ClipboardEntry) {
        pasteboard.clearContents()
        if entry.type == "text" {
            if let string = String(data: entry.contentData, encoding: .utf8) {
                pasteboard.setString(string, forType: .string)
            }
        } else {
            pasteboard.setData(entry.contentData, forType: NSPasteboard.PasteboardType(entry.fileExtension))
        }
    }
}
