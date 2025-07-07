import SwiftUI
import AppKit

enum ClipboardFilter: String, CaseIterable, Identifiable {
    case all, text, image, file

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "All"
        case .text: return "Text"
        case .image: return "Images"
        case .file: return "Files"
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: ClipboardViewModel
    @State private var selectedFilter: ClipboardFilter = .all

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClipboardEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<ClipboardEntry>

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ClipboardViewModel(context: context))
        _entries = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \ClipboardEntry.date, ascending: false)],
            animation: .default)
    }

    private var filteredEntries: [ClipboardEntry] {
        switch selectedFilter {
        case .all:
            return Array(entries)
        default:
            return entries.filter { $0.type == selectedFilter.rawValue }
        }
    }

    var body: some View {
        NavigationView {
            List(ClipboardFilter.allCases, selection: $selectedFilter) { filter in
                Text(filter.title)
                    .tag(filter)
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 150)

            Table(filteredEntries) {
            TableColumn("Preview") { entry in
                if let image = entry.previewImage {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                } else if entry.type == "text",
                          let text = String(data: entry.contentData, encoding: .utf8) {
                    Text(text).lineLimit(1)
                } else {
                    Image(nsImage: NSWorkspace.shared.icon(forFileType: entry.fileExtension))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
            }
            TableColumn("Name") { entry in
                Text(entry.originalName)
            }
            TableColumn("Extension") { entry in
                Text(entry.fileExtension)
            }
            TableColumn("Date") { entry in
                Text(entry.date, style: .time)
            }
            TableColumn("Copy") { entry in
                Button("Copy") {
                    viewModel.copyToPasteboard(entry)
                }
            }
        }
        .frame(minWidth: 500, minHeight: 400)
        }
    }
}

#Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(context: PersistenceController.shared.container.viewContext)
    }
}
