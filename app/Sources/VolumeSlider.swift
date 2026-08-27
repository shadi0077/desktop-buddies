import AppKit

/// A volume slider that lives inside a menu.
///
/// This is the app's own level, independent of the system volume — turning
/// these two down doesn't quieten anything else, and turning the Mac up doesn't
/// make them shout. Discrete menu items would have been less work, but volume
/// is the one setting people genuinely want to nudge rather than pick from a
/// list.
final class VolumeSliderView: NSView {
    private let slider = NSSlider()
    private let readout = NSTextField(labelWithString: "")
    private let onChange: (Float) -> Void

    init(value: Float, onChange: @escaping (Float) -> Void) {
        self.onChange = onChange
        super.init(frame: NSRect(x: 0, y: 0, width: 216, height: 40))

        let icon = NSImageView(frame: NSRect(x: 14, y: 11, width: 16, height: 16))
        icon.image = NSImage(systemSymbolName: "speaker.wave.2.fill",
                             accessibilityDescription: "Volume")
            ?? NSImage(systemSymbolName: "speaker", accessibilityDescription: "Volume")
        icon.contentTintColor = .secondaryLabelColor
        addSubview(icon)

        slider.frame = NSRect(x: 36, y: 8, width: 128, height: 22)
        slider.minValue = 0
        slider.maxValue = 1
        slider.floatValue = value
        slider.isContinuous = true
        slider.target = self
        slider.action = #selector(moved)
        slider.controlSize = .small
        addSubview(slider)

        readout.frame = NSRect(x: 170, y: 11, width: 40, height: 16)
        readout.font = .monospacedDigitSystemFont(ofSize: 11, weight: .regular)
        readout.textColor = .labelColor
        readout.alignment = .right
        addSubview(readout)
        updateReadout()
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func moved() {
        updateReadout()
        onChange(slider.floatValue)
    }

    private func updateReadout() {
        readout.stringValue = "\(Int((slider.floatValue * 100).rounded()))%"
    }
}
