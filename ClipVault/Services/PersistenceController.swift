import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        let model = Self.managedObjectModel
        container = NSPersistentCloudKitContainer(name: "ClipVault", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        if let description = container.persistentStoreDescriptions.first {
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.example.clipvault")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    static var managedObjectModel: NSManagedObjectModel = {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = "ClipboardEntry"
        entity.managedObjectClassName = "ClipboardEntry"

        var properties: [NSAttributeDescription] = []

        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .UUIDAttributeType
        idAttr.isOptional = false
        properties.append(idAttr)

        let nameAttr = NSAttributeDescription()
        nameAttr.name = "originalName"
        nameAttr.attributeType = .stringAttributeType
        nameAttr.isOptional = false
        properties.append(nameAttr)

        let extAttr = NSAttributeDescription()
        extAttr.name = "fileExtension"
        extAttr.attributeType = .stringAttributeType
        extAttr.isOptional = false
        properties.append(extAttr)

        let typeAttr = NSAttributeDescription()
        typeAttr.name = "type"
        typeAttr.attributeType = .stringAttributeType
        typeAttr.isOptional = false
        properties.append(typeAttr)

        let previewAttr = NSAttributeDescription()
        previewAttr.name = "previewData"
        previewAttr.attributeType = .binaryDataAttributeType
        previewAttr.isOptional = true
        properties.append(previewAttr)

        let dataAttr = NSAttributeDescription()
        dataAttr.name = "contentData"
        dataAttr.attributeType = .binaryDataAttributeType
        dataAttr.isOptional = false
        properties.append(dataAttr)

        let dateAttr = NSAttributeDescription()
        dateAttr.name = "date"
        dateAttr.attributeType = .dateAttributeType
        dateAttr.isOptional = false
        properties.append(dateAttr)

        entity.properties = properties
        model.entities = [entity]
        return model
    }()
}
