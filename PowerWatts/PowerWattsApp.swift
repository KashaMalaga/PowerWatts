import SwiftUI
import AppKit

@main
struct PowerWattsApp: App {

    @StateObject private var powerMonitor = PowerMonitor()

    var body: some Scene {
        MenuBarExtra {
            if let watts = powerMonitor.wattage {
                Text("Charging: \(watts)W")
            } else {
                Text("Not charging")
            }

            Divider()

            Button("Quit PowerWatts") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        } label: {
            if let watts = powerMonitor.wattage {
                Text("⚡\(watts)W")
            } else {
                Text("⚡")
            }
        }
    }
}
