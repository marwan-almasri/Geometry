import Foundation

/// Represents a rotation matrix in three-dimensional space.
///
/// In linear algebra, a rotation matrix is used to perform rotations in Euclidean space.
public struct RotationMatrix: CustomStringConvertible {

    public let m11: Double
    public let m12: Double
    public let m13: Double
    public let m21: Double
    public let m22: Double
    public let m23: Double
    public let m31: Double
    public let m32: Double
    public let m33: Double

    /// Converts the rotation matrix to Euler angles.
    ///
    /// Inverts the convention used by `EulerAngles.rotationMatrix`:
    /// `R = Rx(roll) · Ry(pitch) · Rz(yaw)`
    ///
    /// Extraction formulas (derived from the forward formula):
    /// - `roll  = atan2(-m13, √(m11² + m12²))`   from `m13 = -sin(roll)`
    /// - `yaw   = atan2(m12, m11)`                 from `m11 = cos(roll)·cos(yaw)`, `m12 = cos(roll)·sin(yaw)`
    /// - `pitch = atan2(m23, m33)`                 from `m23 = cos(roll)·sin(pitch)`, `m33 = cos(roll)·cos(pitch)`
    ///
    /// **Gimbal lock** (roll ≈ ±π/2, `cos(roll) ≈ 0`): only `(pitch − yaw)` or `(pitch + yaw)` is
    /// recoverable. By convention `yaw` is set to zero and `pitch` absorbs the coupled value:
    /// - roll ≈ +π/2 (`m13 < 0`): `pitch = atan2(m21, m22)`  recovers `(pitch − yaw)`
    /// - roll ≈ −π/2 (`m13 ≥ 0`): `pitch = atan2(-m21, m22)` recovers `(pitch + yaw)`
    public var eulerAngles: EulerAngles {
        let cosRoll = sqrt(m11 * m11 + m12 * m12)
        let roll = atan2(-m13, cosRoll).angle

        let pitch: Angle
        let yaw: Angle

        if cosRoll < 1e-6 {
            // Gimbal lock: cos(roll) ≈ 0. Detect the roll sign via m13 = -sin(roll).
            if m13 < 0 {
                // roll ≈ +π/2: m21 = sin(pitch−yaw), m22 = cos(pitch−yaw)
                pitch = atan2(m21, m22).angle
            } else {
                // roll ≈ −π/2: m21 = −sin(pitch+yaw), m22 = cos(pitch+yaw)
                pitch = atan2(-m21, m22).angle
            }
            yaw = .zero
        } else {
            yaw = atan2(m12, m11).angle
            pitch = atan2(m23, m33).angle
        }

        return EulerAngles(roll: roll, pitch: pitch, yaw: yaw)
    }

    /// Converts the rotation matrix to a quaternion.
    ///
    /// Uses the Cayley–Klein (Shepperd) formula:
    /// `w = ½√(1 + tr(R))`,  `x = (m23−m32)/(4w)`,  `y = (m31−m13)/(4w)`,  `z = (m12−m21)/(4w)`
    ///
    /// The `max(0, …)` guard prevents a negative radicand from floating-point drift near θ = 0.
    public var quaternion: Quaternion {
        let w = sqrt(max(0, 1 + m11 + m22 + m33)) / 2
        let x = (m23 - m32) / (4 * w)
        let y = (m31 - m13) / (4 * w)
        let z = (m12 - m21) / (4 * w)
        return Quaternion(x: x, y: y, z: z, w: w)
    }

    // MARK: - Initialization

    /// Initializes a `RotationMatrix` with all nine matrix elements.
    public init(m11: Double, m12: Double, m13: Double,
                m21: Double, m22: Double, m23: Double,
                m31: Double, m32: Double, m33: Double) {
        self.m11 = m11; self.m12 = m12; self.m13 = m13
        self.m21 = m21; self.m22 = m22; self.m23 = m23
        self.m31 = m31; self.m32 = m32; self.m33 = m33
    }

    public var description: String {
        return String(format: """
        RotationMatrix:
        |%.2f,\t%.2f,\t%.2f|
        |%.2f,\t%.2f,\t%.2f|
        |%.2f,\t%.2f,\t%.2f|
        """, m11, m12, m13, m21, m22, m23, m31, m32, m33)
    }
}

#if canImport(CoreMotion)
import CoreMotion

public extension RotationMatrix {

    /// Initializes a `RotationMatrix` using `CMRotationMatrix` from Core Motion.
    /// - Parameter matrix: A `CMRotationMatrix` representing the rotation.
    init(matrix: CMRotationMatrix) {
        m11 = matrix.m11
        m12 = matrix.m12
        m13 = matrix.m13
        m21 = matrix.m21
        m22 = matrix.m22
        m23 = matrix.m23
        m31 = matrix.m31
        m32 = matrix.m32
        m33 = matrix.m33
    }
}
#endif
