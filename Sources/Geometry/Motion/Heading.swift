import Foundation

/// Represents magnetic heading information.
///
/// In land navigation, heading is measured with respect to magnetic north, true north, or grid north using a 360-degree system.
public struct Heading {

    // MARK: - Properties

    /// The heading (in radians) relative to magnetic north.
    public let magnetic: Angle!

    /// The heading (in radians) relative to true north.
    public let `true`: Angle!

    /// The maximum deviation (in radians) between the reported heading and the true geomagnetic heading.
    public let accuracy: Angle!

    /// The geomagnetic vector (in microteslas).
    public let field: Vector3D!

    // MARK: - Initialization

    /// Initializes a `Heading` object.
    /// - Parameter magnetic: Heading relative to magnetic north (in radians).
    /// - Parameter true: Heading relative to true north (in radians).
    /// - Parameter accuracy: Maximum deviation between reported and true heading (in radians).
    /// - Parameter field: Geomagnetic vector (in microteslas).
    public init(magnetic: Angle = .zero, `true`: Angle = .zero, accuracy: Angle = .zero, field: Vector3D = .init()) {
        self.magnetic = magnetic
        self.true = `true`
        self.accuracy = accuracy
        self.field = field
    }

    /// A multi-line description of all heading fields and the geomagnetic field vector.
    public var description: String {
        return """
        Heading {
            Magnetic = \(String(describing: magnetic))
            True = \(String(describing: `true`))
            Accuracy = \(String(describing: accuracy))
            Geomagnetic Field = \(String(describing: field))
        }
        """
    }
}

#if canImport(CoreLocation)
import CoreLocation

/// Core Location extension for constructing a `Heading` from a `CLHeading`.
extension Heading {
    /// Initializes a `Heading` from a `CLHeading`.
    public init(heading: CLHeading) {
        self.init(
            magnetic: heading.magneticHeading.angle,
            true: heading.trueHeading.angle,
            accuracy: heading.headingAccuracy.angle,
            field: Vector3D(heading: heading)
        )
    }
}
#endif
