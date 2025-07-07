import Foundation
import CoreData
import AppKit

@objc(ClipboardEntry)
public class ClipboardEntry: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClipboardEntry> {
        NSFetchRequest<ClipboardEntry>(entityName: "ClipboardEntry")
    }

    @NSManaged public var id: UUID
    @NSManaged public var originalName: String
    @NSManaged public var fileExtension: String
    @NSManaged public var type: String
    @NSManaged public var previewData: Data?
    @NSManaged public var contentData: Data
    @NSManaged public var date: Date

    var previewImage: NSImage? {
        if let data = previewData {
            return NSImage(data: data)
        }
        return nil
    }
}
