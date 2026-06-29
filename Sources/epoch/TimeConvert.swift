import Foundation

enum Unit: String {
    case seconds, milliseconds, microseconds, nanoseconds

    var perSecond: Double {
        switch self {
        case .seconds: return 1
        case .milliseconds: return 1_000
        case .microseconds: return 1_000_000
        case .nanoseconds: return 1_000_000_000
        }
    }

    var label: String {
        switch self {
        case .seconds: return "s"
        case .milliseconds: return "ms"
        case .microseconds: return "µs"
        case .nanoseconds: return "ns"
        }
    }

    /// Guesses the unit of an epoch value from the magnitude of its integer part.
    /// A 10-digit number is seconds (~2001–2286); 13 digits is milliseconds, etc.
    static func detect(from value: Double) -> Unit {
        let digits = String(Int(abs(value))).count
        switch digits {
        case ...11: return .seconds
        case 12...14: return .milliseconds
        case 15...17: return .microseconds
        default: return .nanoseconds
        }
    }
}

enum TimeConvert {
    static func date(fromEpoch value: Double, unit: Unit) -> Date {
        Date(timeIntervalSince1970: value / unit.perSecond)
    }

    /// Tries to parse a human date string into a Date.
    static func date(fromString string: String) -> Date? {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: string) { return date }
        iso.formatOptions = [.withInternetDateTime]
        if let date = iso.date(from: string) { return date }

        let patterns = ["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd HH:mm", "yyyy-MM-dd"]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        for pattern in patterns {
            formatter.dateFormat = pattern
            if let date = formatter.date(from: string) { return date }
        }
        return nil
    }

    static func iso8601(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }

    static func local(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return formatter.string(from: date)
    }

    static func relative(_ date: Date, now: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: now)
    }
}
