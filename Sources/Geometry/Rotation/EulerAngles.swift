import Foundation

/// Represents Euler angles—a method for parameterizing rotation in 3D space.
///
/// Euler angles define the orientation of a rigid body using three angles:
/// _[roll, pitch, yaw]_
///
/// - roll: Rotation around the x-axis.
/// - pitch: Rotation around the y-axis.
/// - yaw: Rotation around the z-axis.
public struct EulerAngles: CustomStringConvertible {

    /// Rotation around the x-axis.
    public let roll: Angle

    /// Rotation around the y-axis.
    public let pitch: Angle

    /// Rotation around the z-axis.
    public let yaw: Angle

    /// The equivalent rotation represented as a `RotationMatrix`.
    public var rotationMatrix: RotationMatrix {
        let m11 =  cos(roll) * cos(yaw)
        let m12 =  cos(roll) * sin(yaw)
        let m13 = -sin(roll)
        let m21 =  sin(pitch) * sin(roll) * cos(yaw) - cos(pitch) * sin(yaw)
        let m22 =  sin(pitch) * sin(roll) * sin(yaw) + cos(pitch) * cos(yaw)
        let m23 =  cos(roll) * sin(pitch)
        let m31 =  cos(pitch) * sin(roll) * cos(yaw) + sin(pitch) * sin(yaw)
        let m32 =  cos(pitch) * sin(roll) * sin(yaw) - sin(pitch) * cos(yaw)
        let m33 =  cos(roll) * cos(pitch)

        return RotationMatrix(
            m11: m11, m12: m12, m13: m13,
            m21: m21, m22: m22, m23: m23,
            m31: m31, m32: m32, m33: m33
        )
    }

    /// The equivalent rotation represented as a `Quaternion`.
    public var quaternion: Quaternion {
        let c1 = cos(yaw / 2)
        let s1 = sin(yaw / 2)
        let c2 = cos(pitch / 2)
        let s2 = sin(pitch / 2)
        let c3 = cos(roll / 2)
        let s3 = sin(roll / 2)

        let x = (c1 * s2 * c3) - (s1 * c2 * s3)
        let y = (c1 * c2 * s3) + (s1 * s2 * c3)
        let z = (s1 * c2 * c3) + (c1 * s2 * s3)
        let w = (c1 * c2 * c3) - (s1 * s2 * s3)

        return Quaternion(x: x, y: y, z: z, w: w)
    }

    // MARK: - Initialization

    /// Initializes an `EulerAngles` object with specified values.
    /// - Parameter roll: Rotation around the x-axis.
    /// - Parameter pitch: Rotation around the y-axis.
    /// - Parameter yaw: Rotation around the z-axis.
    public init(roll: Angle = .zero, pitch: Angle = .zero, yaw: Angle = .zero) {
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
    }

    public var description: String {
        return String(format: "EulerAngles[roll: %.2f, pitch: %.2f, yaw: %.2f]",
                      Float(roll.degrees), Float(pitch.degrees), Float(yaw.degrees))
    }
}

#if canImport(CoreMotion)
import CoreMotion

public extension EulerAngles {

    /// Initializes an `EulerAngles` object using `CMAttitude` from Core Motion.
    /// - Parameter attitude: A `CMAttitude` representing the device’s orientation.
    init(attitude: CMAttitude) {
        self.roll = attitude.roll.angle
        self.pitch = attitude.pitch.angle
        self.yaw = attitude.yaw.angle
    }
}
#endif
