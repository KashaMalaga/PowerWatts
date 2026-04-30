import AppKit

let iconDir = URL(fileURLWithPath: CommandLine.arguments[1])
try FileManager.default.createDirectory(at: iconDir, withIntermediateDirectories: true)

let outputs: [(String, CGFloat)] = [
    ("AppIcon-16.png", 16),
    ("AppIcon-16@2x.png", 32),
    ("AppIcon-32.png", 32),
    ("AppIcon-32@2x.png", 64),
    ("AppIcon-128.png", 128),
    ("AppIcon-128@2x.png", 256),
    ("AppIcon-256.png", 256),
    ("AppIcon-256@2x.png", 512),
    ("AppIcon-512.png", 512),
    ("AppIcon-512@2x.png", 1024),
]

func drawIcon(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()
    defer { image.unlockFocus() }

    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    NSColor.clear.setFill()
    rect.fill()

    let background = NSBezierPath(
        roundedRect: rect.insetBy(dx: size * 0.04, dy: size * 0.04),
        xRadius: size * 0.22,
        yRadius: size * 0.22
    )
    NSGradient(colors: [
        NSColor(red: 1.0, green: 0.82, blue: 0.18, alpha: 1.0),
        NSColor(red: 1.0, green: 0.52, blue: 0.08, alpha: 1.0)
    ])?.draw(in: background, angle: 315)

    let shadow = NSShadow()
    shadow.shadowColor = NSColor.black.withAlphaComponent(0.22)
    shadow.shadowBlurRadius = size * 0.045
    shadow.shadowOffset = NSSize(width: 0, height: -size * 0.018)
    shadow.set()

    let bolt = NSBezierPath()
    bolt.move(to: NSPoint(x: size * 0.58, y: size * 0.86))
    bolt.line(to: NSPoint(x: size * 0.31, y: size * 0.48))
    bolt.line(to: NSPoint(x: size * 0.50, y: size * 0.48))
    bolt.line(to: NSPoint(x: size * 0.40, y: size * 0.14))
    bolt.line(to: NSPoint(x: size * 0.72, y: size * 0.58))
    bolt.line(to: NSPoint(x: size * 0.52, y: size * 0.58))
    bolt.close()

    NSColor.white.setFill()
    bolt.fill()

    return image
}

for output in outputs {
    let image = drawIcon(size: output.1)
    guard
        let tiff = image.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiff),
        let png = bitmap.representation(using: .png, properties: [:])
    else {
        fatalError("Could not render \(output.0)")
    }

    try png.write(to: iconDir.appendingPathComponent(output.0))
}
