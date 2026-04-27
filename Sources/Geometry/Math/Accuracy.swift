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

// CMMotionActivity is only available on macOS 15.0+
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
