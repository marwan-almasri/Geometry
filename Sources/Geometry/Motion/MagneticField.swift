import Foundation

/// Represents a magnetic field vector in three-dimensional space.
///
/// A magnetic field is a force field created by moving electric charges and magnetic dipoles.
/// It exerts a force on nearby moving charges and dipoles.
///
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Magnetic_field)
public struct MagneticField {

    /// A 3-axis vector representing the magnetic field.
    public let field: Vector3D

    /// The accuracy of the magnetic field measurement.
    public let accuracy: Accuracy

    /// Initializes a magnetic field instance with the given data.
    /// - Parameter field: A `Vector3D` containing magnetometer data.
    /// - Parameter accuracy: The accuracy level of the field.
    public init(field: Vector3D, accuracy: Accuracy) {
        self.field = field
        self.accuracy = accuracy
    }

    /// A multi-line description showing the accuracy level and the field vector.
    public var description: String {
        return """
        MagneticField with accuracy \(accuracy) {
            \(field)
        }
        """
    }
}

#if canImport(CoreMotion)
import CoreMotion

/// Core Motion extension for constructing a `MagneticField` from a `CMCalibratedMagneticField`.
public extension MagneticField {

    /// Initializes a magnetic field from a `CMCalibratedMagneticField` object (iOS only).
    ///
    /// - Parameter magneticField: A Core Motion magnetic field reading.
    init(magneticField: CMCalibratedMagneticField) {
        accuracy = Accuracy(magneticField: magneticField)
        field = Vector3D(magneticField: magneticField)
    }
}
#endif
