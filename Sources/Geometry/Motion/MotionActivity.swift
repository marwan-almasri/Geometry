import Foundation

/// Represents a human motion activity detected by the device.
///
/// This class encapsulates a user's activity type and the associated confidence level.
public struct MotionActivity {

    // MARK: - Properties

    /// The detected activity status.
    public let status: MotionActivityStatus

    /// The confidence level associated with the detected activity.
    public let confidence: Accuracy

    // MARK: - Initialization

    /// Initializes a `MotionActivity` instance with a specific status and confidence.
    /// - Parameter status: The detected activity type.
    /// - Parameter confidence: The confidence level of the activity detection.
    public init(status: MotionActivityStatus = .unknown, confidence: Accuracy = .none) {
        self.status = status
        self.confidence = confidence
    }

    /// A human-readable description showing the status and confidence level.
    public var description: String {
        "\(status) confidence \(confidence)"
    }
}

#if canImport(CoreMotion)
import CoreMotion

/// Core Motion extension for constructing a `MotionActivity` from a `CMMotionActivity` (macOS 15.0+).
@available(macOS 15.0, *)
public extension MotionActivity {

    /// Initializes a `MotionActivity` from a `CMMotionActivity` instance.
    init(activity: CMMotionActivity) {
        self.init(
            status: MotionActivityStatus(activity: activity),
            confidence: Accuracy(activity: activity)
        )
    }
}
#endif
