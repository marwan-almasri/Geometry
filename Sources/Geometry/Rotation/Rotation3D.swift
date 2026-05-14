import Foundation

/// Represents a geometric rotation in three dimensions, available in multiple forms.
///
/// A `Rotation3D` stores the same rotation expressed as Euler angles, a quaternion, and a rotation matrix.
/// It supports arithmetic operations and encoding/decoding for persistence.
public struct Rotation3D {

    // MARK: - Properties

    /// Rotation around the x-axis.
    public var roll: Angle { eulerAngles.roll }

    /// Rotation around the y-axis.
    public var pitch: Angle { eulerAngles.pitch }

    /// Rotation around the z-axis.
    public var yaw: Angle { eulerAngles.yaw }

    /// The Euler angle representation of the rotation.
    public let eulerAngles: EulerAngles!

    /// The quaternion representation of the rotation.
    public let quaternion: Quaternion!

    /// The rotation matrix representation of the rotation.
    public let rotationMatrix: RotationMatrix!

    // MARK: - Initialization

    /// Default initializer.
    public init() {
        eulerAngles = EulerAngles()
        quaternion = eulerAngles.quaternion
        rotationMatrix = eulerAngles.rotationMatrix
    }

    /// Initializes a rotation with specific Euler angles.
    /// - Parameter roll: Rotation around x-axis.
    /// - Parameter pitch: Rotation around y-axis.
    /// - Parameter yaw: Rotation around z-axis.
    public init(roll: Angle, pitch: Angle, yaw: Angle) {
        eulerAngles = EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
        quaternion = eulerAngles.quaternion
        rotationMatrix = eulerAngles.rotationMatrix
    }

    /// A human-readable description of the rotation in degrees, e.g. `"Rotation3D[roll: 0.00, pitch: 0.00, yaw: 0.00]"`.
    public var description: String {
        let fmt = "Rotation3D[roll: %.2f, pitch: %.2f, yaw: %.2f]"
        return String(format: fmt, Float(roll.degrees), Float(pitch.degrees), Float(yaw.degrees))
    }
}

// MARK: - Arithmetic Operators

extension Rotation3D {

    /// Negates all three Euler angle components.
    /// - Parameter rotation: The rotation to negate.
    /// - Returns: A rotation with each axis angle negated.
    public static prefix func - (rotation: Rotation3D) -> Rotation3D {
        Rotation3D(roll: -rotation.roll, pitch: -rotation.pitch, yaw: -rotation.yaw)
    }

    /// Adds two rotations component-wise.
    /// - Parameters:
    ///   - left: The first rotation.
    ///   - right: The second rotation.
    /// - Returns: A rotation whose angles are the sums of the corresponding angles.
    public static func + (left: Rotation3D, right: Rotation3D) -> Rotation3D {
        Rotation3D(roll: left.roll + right.roll,
                   pitch: left.pitch + right.pitch,
                   yaw: left.yaw + right.yaw)
    }

    /// Subtracts one rotation from another component-wise.
    /// - Parameters:
    ///   - left: The base rotation.
    ///   - right: The rotation to subtract.
    /// - Returns: A rotation whose angles are the differences of the corresponding angles.
    public static func - (left: Rotation3D, right: Rotation3D) -> Rotation3D {
        left + -right
    }

    /// Adds a rotation to this rotation in place.
    public static func += (left: inout Rotation3D, right: Rotation3D) {
        left = left + right
    }

    /// Subtracts a rotation from this rotation in place.
    public static func -= (left: inout Rotation3D, right: Rotation3D) {
        left = left - right
    }

    /// Multiplies two rotations component-wise.
    /// - Parameters:
    ///   - left: The first rotation.
    ///   - right: The second rotation.
    /// - Returns: A rotation whose angles are the products of the corresponding angles.
    public static func * (left: Rotation3D, right: Rotation3D) -> Rotation3D {
        Rotation3D(roll: left.roll * right.roll,
                   pitch: left.pitch * right.pitch,
                   yaw: left.yaw * right.yaw)
    }

    /// Divides one rotation by another component-wise.
    /// - Parameters:
    ///   - left: The dividend rotation.
    ///   - right: The divisor rotation.
    /// - Returns: A rotation whose angles are the quotients of the corresponding angles.
    public static func / (left: Rotation3D, right: Rotation3D) -> Rotation3D {
        Rotation3D(roll: left.roll / right.roll,
                   pitch: left.pitch / right.pitch,
                   yaw: left.yaw / right.yaw)
    }
}

// MARK: - Logical Operators

extension Rotation3D {

    /// Returns `true` if all three angle components are equal.
    public static func == (left: Rotation3D, right: Rotation3D) -> Bool {
        (left.roll == right.roll) && (left.pitch == right.pitch) && (left.yaw == right.yaw)
    }

    /// Returns `true` if any angle component differs.
    public static func != (left: Rotation3D, right: Rotation3D) -> Bool {
        !(left == right)
    }
}

#if canImport(CoreMotion)
import CoreMotion

/// Core Motion extension for constructing a `Rotation3D` from a `CMAttitude`.
public extension Rotation3D {

    /// Initializes a `Rotation3D` using a `CMAttitude` from Core Motion.
    /// - Parameter attitude: A `CMAttitude` representing the current device orientation.
    init(attitude: CMAttitude) {
        eulerAngles = EulerAngles(attitude: attitude)
        rotationMatrix = RotationMatrix(matrix: attitude.rotationMatrix)
        quaternion = Quaternion(quaternion: attitude.quaternion)
    }
}
#endif
