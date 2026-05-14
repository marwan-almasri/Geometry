import Foundation

/// Represents an estimate of the user's physical activity based on device motion.
public enum MotionActivityStatus: CustomStringConvertible {

    /// The user is walking.
    case walking

    /// The user is running.
    case running

    /// The user is in a moving vehicle.
    case automotive

    /// The user is stationary.
    case stationary

    /// The user is cycling.
    case cycling

    /// The activity could not be determined.
    case unknown

    /// A human-readable label for the activity, e.g. `"Walking"` or `"Unknown"`.
    public var description: String {
        switch self {
        case .walking:
            return "Walking"
        case .running:
            return "Running"
        case .automotive:
            return "Automotive"
        case .stationary:
            return "Stationary"
        case .cycling:
            return "Cycling"
        case .unknown:
            return "Unknown"
        }
    }
}

#if canImport(CoreMotion)
import CoreMotion

/// Core Motion extension for deriving `MotionActivityStatus` from a `CMMotionActivity` (macOS 15.0+).
@available(macOS 15.0, *)
public extension MotionActivityStatus {

    /// Initializes a `MotionActivityStatus` from a `CMMotionActivity` object.
    /// - Parameter activity: The Core Motion activity object.
    init(activity: CMMotionActivity) {
        if activity.walking {
            self = .walking
        } else if activity.running {
            self = .running
        } else if activity.automotive {
            self = .automotive
        } else if activity.stationary {
            self = .stationary
        } else {
            #if os(iOS)
            self = activity.cycling ? .cycling : .unknown
            #else
            self = .unknown
            #endif
        }
    }
}
#endif
