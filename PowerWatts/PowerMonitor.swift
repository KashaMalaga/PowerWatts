import Foundation
import IOKit.ps
import Combine

final class PowerMonitor: ObservableObject {

    /// nil means "no external power adapter / not charging"
    @Published var wattage: Int? = nil
    private var timer: Timer?

    init() {
        update()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.update()
        }
    }

    private func update() {
        guard
            let snapshot = IOPSCopyExternalPowerAdapterDetails()?.takeRetainedValue() as? [String: Any],
            let watts = snapshot["Watts"] as? Int,
            watts > 0
        else {
            DispatchQueue.main.async { [weak self] in
                self?.wattage = nil
            }
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.wattage = watts
        }
    }
}
