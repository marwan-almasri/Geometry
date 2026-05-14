import Foundation

/// Represents a quaternion, a mathematical construct used to encode 3D rotations.
///
/// If `q` is an instance of `Quaternion`, it is represented as:
///
/// ![Equation](https://latex.codecogs.com/png.latex?q%3Dx%5Cmathbf%7Bi%7D%2By%5Cmathbf%7Bj%7D%2Bz%5Cmathbf%7Bk%7D%2Bw)
///
/// Where:
///
/// ![Equation](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bi%7D%5E2%3D%5Cmathbf%7Bj%7D%5E2%3D%5Cmathbf%7Bk%7D%5E2%3D%5Cmathbf%7Bi%7D%5Cmathbf%7Bj%7D%5Cmathbf%7Bk%7D%3D-1)
public struct Quaternion: CustomStringConvertible {

    /// Projection of the quaternion’s unity vector on the x-axis.
    public let x: Double

    /// Projection on the y-axis.
    public let y: Double

    /// Projection on the z-axis.
    public let z: Double

    /// Scalar part of the quaternion (rotation angle component).
    public let w: Double

    /// Converts the quaternion to Euler angles.
    public var eulerAngles: EulerAngles {
        let roll  = atan2(2 * y * w - 2 * z * x, 1 - 2 * pow(y, 2) - 2 * pow(x, 2)).angle
        let pitch =  asin(2 * y * z + 2 * x * w).angle
        let yaw   = atan2(2 * z * w - 2 * y * x, 1 - 2 * pow(z, 2) - 2 * pow(x, 2)).angle

        return EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
    }

    /// Converts the quaternion to a rotation matrix.
    public var rotationMatrix: RotationMatrix {
        let m11 = 1 - 2 * (pow(y, 2) + pow(z, 2))
        let m12 = 2 * (x * y + w * z)
        let m13 = 2 * (x * z - w * y)
        let m21 = 2 * (x * y - w * z)
        let m22 = 1 - 2 * (pow(x, 2) + pow(z, 2))
        let m23 = 2 * (y * z + w * x)
        let m31 = 2 * (x * z + w * y)
        let m32 = 2 * (y * z - w * x)
        let m33 = 1 - 2 * (pow(x, 2) + pow(y, 2))

        return RotationMatrix(
            m11: m11, m12: m12, m13: m13,
            m21: m21, m22: m22, m23: m23,
            m31: m31, m32: m32, m33: m33
        )
    }

    // MARK: - Initialization

    /// Initializes a quaternion with the specified components.
    /// - Parameter x: Projection on the x-axis.
    /// - Parameter y: Projection on the y-axis.
    /// - Parameter z: Projection on the z-axis.
    /// - Parameter w: Scalar component (rotation angle).
    public init(x: Double = 0, y: Double = 0, z: Double = 0, w: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    /// A human-readable description of the quaternion components, e.g. `"Quaternion(0.00, 0.00, 0.00, 1.00)"`.
    public var description: String {
        return String(format: "Quaternion(%.2f, %.2f, %.2f, %.2f)", Float(x), Float(y), Float(z), Float(w))
    }
}

#if canImport(CoreMotion)
import CoreMotion

/// Core Motion extension for constructing a `Quaternion` from a `CMQuaternion`.
public extension Quaternion {

    /// Initializes a quaternion using `CMQuaternion` from Core Motion.
    /// - Parameter quaternion: A `CMQuaternion` representing the rotation.
    init(quaternion: CMQuaternion) {
        self.x = quaternion.x
        self.y = quaternion.y
        self.z = quaternion.z
        self.w = quaternion.w
    }
}
#endif
