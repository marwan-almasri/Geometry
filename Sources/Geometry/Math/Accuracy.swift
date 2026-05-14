import Foundation

/// Represents the level of accuracy for measurements or estimations.
public enum Accuracy: Int, CustomStringConvertible {
    
    /// Unknown or uncalibrated accuracy.
    case none = 0
    
    /// Low accuracy.
    case low = 1
    
    /// Medium accuracy.
    case medium = 2
    
    /// High accuracy.
    case high = 3
    
    /// A human-readable label for the accuracy level, e.g. `"High"` or `"Unknown"`.
    public var description: String {
        switch self {
        case .none:
            return "Unknown"
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

#if canImport(CoreMotion)
import CoreMotion

/// Core Motion extensions mapping `CMMagneticFieldCalibrationAccuracy` and `CMMotionActivity` to `Accuracy`.
public extension Accuracy {

    /// Initializes `Accuracy` from `CMMagneticFieldCalibrationAccuracy`.
    init(accuracy: CMMagneticFieldCalibrationAccuracy) {
        switch accuracy {
        case .uncalibrated:
            self = .none
        case .low:
            self = .low
        case .medium:
            self = .medium
        case .high:
            self = .high
        @unknown default:
            self = .none
        }
    }

    /// Initializes `Accuracy` from a `CMCalibratedMagneticField`.
    init(magneticField: CMCalibratedMagneticField) {
        self.init(accuracy: magneticField.accuracy)
    }
}

/// Core Motion extensions mapping `CMMotionActivityConfidence` to `Accuracy` (macOS 15.0+).
@available(macOS 15.0, *)
public extension Accuracy {

    /// Initializes `Accuracy` from `CMMotionActivityConfidence`.
    init(confidence: CMMotionActivityConfidence) {
        switch confidence {
        case .low:
            self = .low
        case .medium:
            self = .medium
        case .high:
            self = .high
        @unknown default:
            self = .none
        }
    }

    /// Initializes `Accuracy` from a `CMMotionActivity` instance.
    init(activity: CMMotionActivity) {
        self.init(confidence: activity.confidence)
    }
}
#endif
