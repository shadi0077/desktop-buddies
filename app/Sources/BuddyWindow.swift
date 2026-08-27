import AppKit

/// The transparent, always-on-top window the bird lives in.
final class BuddyWindow: NSPanel {
    let buddyView: BuddyView

    var onClick: (() -> Void)?
    var onRightClick: ((NSEvent) -> Void)?
    var onDragBegan: (() -> Void)?
    var onDragMoved: ((NSPoint) -> Void)?
    var onDragEnded: (() -> Void)?

    private var dragOffset: NSPoint = .zero
    private var dragging = false
    private var didMove = false

    init(store: SpriteStore, scale: CGFloat) {
        buddyView = BuddyView(store: store)
        let size = NSSize(width: store.canvas.width * scale, height: store.canvas.height * scale)
        super.init(contentRect: NSRect(origin: .zero, size: size),
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered, defer: false)
        isOpaque = false
        backgroundColor = .clear
        hasShadow = false
        isMovableByWindowBackground = false
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary, .ignoresCycle]
        contentView = buddyView
        buddyView.frame = NSRect(origin: .zero, size: size)
    }

    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }

    func resize(to scale: CGFloat, store: SpriteStore) {
        let size = NSSize(width: store.canvas.width * scale, height: store.canvas.height * scale)
        var f = frame
        f.origin.x += (f.width - size.width) / 2      // keep him centred and
        f.size = size                                 // his feet on the ground
        setFrame(f, display: true)
        buddyView.frame = NSRect(origin: .zero, size: size)
    }

    override func mouseDown(with event: NSEvent) {
        dragging = true
        didMove = false
        let mouse = NSEvent.mouseLocation
        dragOffset = NSPoint(x: mouse.x - frame.origin.x, y: mouse.y - frame.origin.y)
    }

    override func mouseDragged(with event: NSEvent) {
        guard dragging else { return }
        if !didMove {
            didMove = true
            onDragBegan?()
        }
        let mouse = NSEvent.mouseLocation
        let origin = NSPoint(x: mouse.x - dragOffset.x, y: mouse.y - dragOffset.y)
        setFrameOrigin(origin)
        onDragMoved?(origin)
    }

    override func mouseUp(with event: NSEvent) {
        guard dragging else { return }
        dragging = false
        if didMove { onDragEnded?() } else { onClick?() }
    }

    override func rightMouseDown(with event: NSEvent) {
        onRightClick?(event)
    }
}
