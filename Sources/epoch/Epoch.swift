import ArgumentParser
import Foundation

@main
struct Epoch: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "epoch",
        abstract: "Convert between Unix timestamps and human-readable dates.",
        discussion: """
        With no argument, prints the current time. Given a number, treats it as a
        Unix timestamp (unit auto-detected from its size). Given a date string,
        prints the matching Unix timestamp.
        """,
        version: "0.1.0"
    )

    @Argument(help: "A Unix timestamp, a date string (e.g. 2024-06-29T12:00:00Z), or nothing for \"now\".")
    var input: [String] = []

    @Flag(name: .long, help: "Force the input number to be seconds.")
    var s = false
    @Flag(name: .long, help: "Force the input number to be milliseconds.")
    var ms = false
    @Flag(name: .long, help: "Force the input number to be microseconds.")
    var us = false
    @Flag(name: .long, help: "Force the input number to be nanoseconds.")
    var ns = false

    @Flag(name: [.short, .long], help: "Print only the converted value, for scripting.")
    var raw = false

    func run() throws {
        let now = Date()
        let argument = input.joined(separator: " ").trimmingCharacters(in: .whitespaces)

        if argument.isEmpty {
            emit(date: now, now: now, sourceWasEpoch: false)
            return
        }

        if let value = Double(argument) {
            let unit = forcedUnit() ?? Unit.detect(from: value)
            let date = TimeConvert.date(fromEpoch: value, unit: unit)
            emit(date: date, now: now, sourceWasEpoch: true, detectedUnit: unit)
        } else if let date = TimeConvert.date(fromString: argument) {
            emit(date: date, now: now, sourceWasEpoch: false)
        } else {
            throw ValidationError("Couldn't parse \"\(argument)\" as a timestamp or a date.")
        }
    }

    private func forcedUnit() -> Unit? {
        if s { return .seconds }
        if ms { return .milliseconds }
        if us { return .microseconds }
        if ns { return .nanoseconds }
        return nil
    }

    private func emit(date: Date, now: Date, sourceWasEpoch: Bool, detectedUnit: Unit? = nil) {
        let seconds = date.timeIntervalSince1970

        if raw {
            // For epoch input, the useful output is the date; for date input, the number.
            print(sourceWasEpoch ? TimeConvert.iso8601(date) : formatInt(seconds))
            return
        }

        if let unit = detectedUnit {
            print("Interpreted as: \(unit.rawValue) (\(unit.label))")
        }
        print("Unix (s):   \(formatInt(seconds))")
        print("Unix (ms):  \(formatInt(seconds * 1000))")
        print("ISO 8601:   \(TimeConvert.iso8601(date))")
        print("Local:      \(TimeConvert.local(date))")
        print("Relative:   \(TimeConvert.relative(date, now: now))")
    }

    private func formatInt(_ value: Double) -> String {
        String(Int(value.rounded()))
    }
}
