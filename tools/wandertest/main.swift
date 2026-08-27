import AppKit

// Exercises Brain.wanderTarget directly: the edge cases are the whole point.
let screen = NSRect(x: 0, y: 71, width: 1728, height: 1013)
let size = NSSize(width: 184, height: 148)
var failures = 0

func check(_ label: String, _ condition: Bool, _ detail: String = "") {
    if condition { print("  ok   \(label)") }
    else { print("  FAIL \(label) \(detail)"); failures += 1 }
}

print("pinned against the right edge, wants to go right:")
let atRight = NSPoint(x: screen.maxX - size.width - 8, y: 100)
if let t = Brain.wanderTarget(from: atRight, size: size, in: screen,
                              hop: 400, dy: 0, preferRight: true) {
    check("moves a useful distance", abs(t.x - atRight.x) >= 80,
          "moved \(Int(abs(t.x - atRight.x)))pt")
    check("stays on screen", t.x >= screen.minX && t.x + size.width <= screen.maxX)
} else { check("returns a target", false) }

print("pinned against the left edge, wants to go left:")
let atLeft = NSPoint(x: screen.minX + 8, y: 100)
if let t = Brain.wanderTarget(from: atLeft, size: size, in: screen,
                              hop: 400, dy: 0, preferRight: false) {
    check("moves a useful distance", abs(t.x - atLeft.x) >= 80,
          "moved \(Int(abs(t.x - atLeft.x)))pt")
    check("stays on screen", t.x >= screen.minX && t.x + size.width <= screen.maxX)
} else { check("returns a target", false) }

print("middle of the screen:")
let mid = NSPoint(x: 700, y: 400)
for right in [true, false] {
    if let t = Brain.wanderTarget(from: mid, size: size, in: screen,
                                  hop: 300, dy: 50, preferRight: right) {
        check("honours preferRight=\(right)", right ? t.x > mid.x : t.x < mid.x)
        check("full hop when there is room (right=\(right))", abs(t.x - mid.x) == 300)
    } else { check("returns a target (right=\(right))", false) }
}

print("window wider than the screen:")
check("gives up", Brain.wanderTarget(from: .zero, size: NSSize(width: 3000, height: 148),
                                     in: screen, hop: 300, dy: 0, preferRight: true) == nil)

print("y stays inside the visible frame:")
if let t = Brain.wanderTarget(from: NSPoint(x: 700, y: screen.minY + 10), size: size,
                              in: screen, hop: 300, dy: -500, preferRight: true) {
    check("clamped to the bottom", t.y >= screen.minY, "y=\(Int(t.y))")
}
if let t = Brain.wanderTarget(from: NSPoint(x: 700, y: screen.maxY), size: size,
                              in: screen, hop: 300, dy: 500, preferRight: true) {
    check("clamped to the top", t.y + size.height <= screen.maxY, "y=\(Int(t.y))")
}

print(failures == 0 ? "\nall checks passed" : "\n\(failures) FAILED")
exit(failures == 0 ? 0 : 1)
