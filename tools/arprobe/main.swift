import AVFoundation
import AppKit
_ = NSApplication.shared
let ID = "com.apple.voice.super-compact.ar-001.Maged"

/// Render a line, reporting how much audio came back.
func render(_ text: String, rate: Float, pitch: Float,
            label: String, done: @escaping (String, Double, Int) -> Void) {
    let s = AVSpeechSynthesizer(); let u = AVSpeechUtterance(string: text)
    u.voice = AVSpeechSynthesisVoice(identifier: ID)
    u.rate = rate; u.pitchMultiplier = pitch
    var n = 0, chunks = 0; var sr = 0.0; var settled = false
    keepAlive.append(s)
    s.write(u) { b in
        guard let p = b as? AVAudioPCMBuffer else { return }
        if p.frameLength == 0 {
            if !settled { settled = true; done(label, sr > 0 ? Double(n)/sr : -1, chunks) }
            return
        }
        sr = p.format.sampleRate; n += Int(p.frameLength); chunks += 1
    }
}
var keepAlive: [AVSpeechSynthesizer] = []

let line = "وصلت. استغرق الأمر بعض الوقت."
var results: [String] = []
func report(_ l: String, _ d: Double, _ c: Int) {
    results.append(String(format: "  %-12@ %6.2fs  %d chunks", l as NSString, d, c))
}

print("one at a time:")
render(line, rate: 0.42, pitch: 0.85, label: "alone", done: report)
var dl = Date().addingTimeInterval(50)
while results.count < 1, Date() < dl { RunLoop.current.run(mode: .default, before: Date().addingTimeInterval(0.01)) }
results.forEach { print($0) }

results.removeAll()
print("\ntwo at once (what the app does with both characters out):")
render(line, rate: 0.52, pitch: 1.85, label: "peedy-ish", done: report)
render(line, rate: 0.42, pitch: 0.85, label: "bonzi-ish", done: report)
dl = Date().addingTimeInterval(90)
while results.count < 2, Date() < dl { RunLoop.current.run(mode: .default, before: Date().addingTimeInterval(0.01)) }
results.forEach { print($0) }
