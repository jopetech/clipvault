# ClipVault

ClipVault is a clipboard manager for macOS built with SwiftUI. It stores everything you copy—text, images, videos and common documents—using Core Data with iCloud synchronization.

## Features

- Monitors the system clipboard and stores all content types in a Core Data database.
- iCloud support via `NSPersistentCloudKitContainer` to keep your history in sync.
- Shows previews for text and images and file icons for other formats.
- Allows copying any item back to the system pasteboard with a single button.

## Requirements

- macOS 12 or later
- Xcode 15 or later

## Building

Open the repository in Xcode and run the **ClipVault** scheme. The app launches and begins monitoring your clipboard automatically. Ensure your app has iCloud entitlements configured for full synchronization support.

This project uses a basic MVVM architecture consisting of models, view models, and SwiftUI views. Further improvements could include persistence, advanced filtering, and better UI design.
