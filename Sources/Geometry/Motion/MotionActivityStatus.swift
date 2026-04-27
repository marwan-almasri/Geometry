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

@available(iOS 7.0, macOS 15.0, watchOS 2.0, tvOS 9.0, *)
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
