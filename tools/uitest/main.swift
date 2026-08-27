import AppKit

// Render the volume slider the way it appears in the menu, so a broken layout
// is visible without having to open the menu by hand.
_ = NSApplication.shared

func shot(_ value: Float, _ label: String) -> NSImage {
    let view = VolumeSliderView(value: value) { _ in }
    // Menus adopt the system appearance; match it so the render is honest.
    view.appearance = NSAppearance(named: .aqua)
    let rep = view.bitmapImageRepForCachingDisplay(in: view.bounds)!
    view.cacheDisplay(in: view.bounds, to: rep)
    let img = NSImage(size: view.bounds.size)
    img.addRepresentation(rep)
    print("  \(label): \(Int(view.bounds.width))x\(Int(view.bounds.height))")
    return img
}

var failures = 0
func check(_ label: String, _ ok: Bool, _ detail: String = "") {
    if ok { print("  ok   \(label)") } else { print("  FAIL \(label) \(detail)"); failures += 1 }
}

let values: [(Float, String)] = [(0, "0%"), (0.35, "35%"), (0.8, "80%"), (1, "100%")]
let images = values.map { shot($0.0, $0.1) }
let w = images[0].size.width, h = images[0].size.height
let out = NSImage(size: NSSize(width: w + 24, height: (h + 8) * CGFloat(images.count) + 16))
out.lockFocus()
NSColor(calibratedWhite: 0.16, alpha: 1).setFill()
NSRect(origin: .zero, size: out.size).fill()
for (i, img) in images.enumerated() {
    let y = out.size.height - 8 - CGFloat(i + 1) * (h + 8)
    NSColor(calibratedWhite: 0.95, alpha: 1).setFill()   // menu background
    NSRect(x: 12, y: y, width: w, height: h).fill()
    img.draw(in: NSRect(x: 12, y: y, width: w, height: h))
}
out.unlockFocus()
let probe = VolumeSliderView(value: 0.5) { _ in }
check("fits a menu", probe.frame.width > 150 && probe.frame.width < 320
      && probe.frame.height > 20 && probe.frame.height < 60, "\(probe.frame.size)")
check("has its controls", probe.subviews.count >= 3, "\(probe.subviews.count) subviews")
// Distinct renders mean the knob actually tracks the value.
func fingerprint(_ img: NSImage) -> Int {
    guard let t = img.tiffRepresentation, let r = NSBitmapImageRep(data: t) else { return 0 }
    var sum = 0
    for x in stride(from: 0, to: r.pixelsWide, by: 3) {
        sum &+= Int(((r.colorAt(x: x, y: r.pixelsHigh / 2)?.brightnessComponent ?? 0) * 255))
      &* (x + 1)
    }
    return sum
}
check("the knob moves with the value",
      Set(images.map(fingerprint)).count == images.count)

if let t = out.tiffRepresentation, let r = NSBitmapImageRep(data: t),
   let p = r.representation(using: .png, properties: [:]) {
    try? p.write(to: URL(fileURLWithPath: "shots/volume_slider.png"))
    print("wrote shots/volume_slider.png")
}

print(failures == 0 ? "\nall checks passed" : "\n\(failures) FAILED")
exit(failures == 0 ? 0 : 1)
