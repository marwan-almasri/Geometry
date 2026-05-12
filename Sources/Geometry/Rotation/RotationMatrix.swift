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
    ///
    /// ![Equation](https://latex.codecogs.com/png.latex?R%3DR_x%28%5Ctext%7Broll%7D%29%5Ccdot%20R_y%28%5Ctext%7Bpitch%7D%29%5Ccdot%20R_z%28%5Ctext%7Byaw%7D%29)
    ///
    /// Extraction formulas (derived from `m13 = -sin(roll)`, `m11 = cos(roll)·cos(yaw)`, `m23 = cos(roll)·sin(pitch)`, etc.):
    ///
    /// ![Equation](https://latex.codecogs.com/png.latex?%5Cbegin%7Baligned%7D%5Ctext%7Broll%7D%26%3D%5Coperatorname%7Batan2%7D%28-m_%7B13%7D%2C%5Csqrt%7Bm_%7B11%7D%5E2%2Bm_%7B12%7D%5E2%7D%29%5C%5C%5Ctext%7Byaw%7D%26%3D%5Coperatorname%7Batan2%7D%28m_%7B12%7D%2Cm_%7B11%7D%29%5C%5C%5Ctext%7Bpitch%7D%26%3D%5Coperatorname%7Batan2%7D%28m_%7B23%7D%2Cm_%7B33%7D%29%5Cend%7Baligned%7D)
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
    ///
    /// ![Equation](https://latex.codecogs.com/png.latex?w%3D%5Ctfrac%7B1%7D%7B2%7D%5Csqrt%7B1%2B%5Coperatorname%7Btr%7D%28R%29%7D%2C%5Cquad%20x%3D%5Cfrac%7Bm_%7B23%7D-m_%7B32%7D%7D%7B4w%7D%2C%5Cquad%20y%3D%5Cfrac%7Bm_%7B31%7D-m_%7B13%7D%7D%7B4w%7D%2C%5Cquad%20z%3D%5Cfrac%7Bm_%7B12%7D-m_%7B21%7D%7D%7B4w%7D)
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
