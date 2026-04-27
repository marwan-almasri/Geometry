import Testing
import Foundation
@testable import Geometry

private let eps = 1e-6

struct RotationMatrixTests {

    @Test func testMemberwiseInit() {
        let m = RotationMatrix(
            m11: 1, m12: 0, m13: 0,
            m21: 0, m22: 1, m23: 0,
            m31: 0, m32: 0, m33: 1
        )
        #expect(m.m11 == 1); #expect(m.m22 == 1); #expect(m.m33 == 1)
        #expect(m.m12 == 0); #expect(m.m13 == 0)
    }

    @Test func testIdentityToEulerAngles() {
        let identity = RotationMatrix(
            m11: 1, m12: 0, m13: 0,
            m21: 0, m22: 1, m23: 0,
            m31: 0, m32: 0, m33: 1
        )
        let euler = identity.eulerAngles
        #expect(abs(euler.roll.radians) < eps)
        #expect(abs(euler.pitch.radians) < eps)
        #expect(abs(euler.yaw.radians) < eps)
    }

    @Test func testIdentityToQuaternion() {
        let identity = RotationMatrix(
            m11: 1, m12: 0, m13: 0,
            m21: 0, m22: 1, m23: 0,
            m31: 0, m32: 0, m33: 1
        )
        let q = identity.quaternion
        #expect(abs(q.w - 1) < eps)
        #expect(abs(q.x) < eps); #expect(abs(q.y) < eps); #expect(abs(q.z) < eps)
    }

    // MARK: - Gimbal lock (roll ≈ ±90°)

    @Test func testGimbalLockPositiveRoll() {
        // Build the matrix for roll=+90°, pitch=30°, yaw=0° — cos(roll)=0 triggers the lock path.
        let euler = EulerAngles(roll: Angle(degrees: 90), pitch: Angle(degrees: 30), yaw: Angle(degrees: 0))
        let matrix = euler.rotationMatrix
        let back = matrix.eulerAngles
        // roll should still be +90°
        #expect(abs(back.roll.degrees - 90) < 1e-4)
        // yaw is set to zero by convention; pitch absorbs the coupled (pitch−yaw) value
        #expect(abs(back.yaw.degrees) < eps)
        // reconstructed matrix must match the original (even if individual angles differ)
        let rebuilt = back.rotationMatrix
        #expect(abs(rebuilt.m11 - matrix.m11) < 1e-6)
        #expect(abs(rebuilt.m22 - matrix.m22) < 1e-6)
        #expect(abs(rebuilt.m33 - matrix.m33) < 1e-6)
    }

    @Test func testGimbalLockNegativeRoll() {
        let euler = EulerAngles(roll: Angle(degrees: -90), pitch: Angle(degrees: 20), yaw: Angle(degrees: 0))
        let matrix = euler.rotationMatrix
        let back = matrix.eulerAngles
        #expect(abs(back.roll.degrees - (-90)) < 1e-4)
        #expect(abs(back.yaw.degrees) < eps)
        let rebuilt = back.rotationMatrix
        #expect(abs(rebuilt.m11 - matrix.m11) < 1e-6)
        #expect(abs(rebuilt.m33 - matrix.m33) < 1e-6)
    }

    @Test func testQuaternionNoNaNForZeroRotation() {
        // The identity matrix has trace = 3, so sqrt(max(0, 4)) = 2 → w = 1. No NaN.
        let identity = RotationMatrix(
            m11: 1, m12: 0, m13: 0,
            m21: 0, m22: 1, m23: 0,
            m31: 0, m32: 0, m33: 1
        )
        let q = identity.quaternion
        #expect(!q.w.isNaN)
        #expect(!q.x.isNaN)
    }
}

struct EulerAnglesTests {

    @Test func testDefaultInit() {
        let e = EulerAngles()
        #expect(e.roll == .zero)
        #expect(e.pitch == .zero)
        #expect(e.yaw == .zero)
    }

    @Test func testInitValues() {
        let e = EulerAngles(roll: Angle(degrees: 30), pitch: Angle(degrees: 45), yaw: Angle(degrees: 60))
        #expect(abs(e.roll.degrees - 30) < eps)
        #expect(abs(e.pitch.degrees - 45) < eps)
        #expect(abs(e.yaw.degrees - 60) < eps)
    }

    @Test func testToRotationMatrixAndBack() {
        let euler = EulerAngles(roll: Angle(degrees: 15), pitch: Angle(degrees: 30), yaw: Angle(degrees: 45))
        let matrix = euler.rotationMatrix
        let back = matrix.eulerAngles

        #expect(abs(back.roll.radians - euler.roll.radians) < eps)
        #expect(abs(back.pitch.radians - euler.pitch.radians) < eps)
        #expect(abs(back.yaw.radians - euler.yaw.radians) < eps)
    }

    @Test func testToQuaternionAndBack() {
        let euler = EulerAngles(roll: Angle(degrees: 10), pitch: Angle(degrees: 20), yaw: Angle(degrees: 30))
        let quaternion = euler.quaternion
        let back = quaternion.eulerAngles

        #expect(abs(back.roll.radians - euler.roll.radians) < eps)
        #expect(abs(back.pitch.radians - euler.pitch.radians) < eps)
        #expect(abs(back.yaw.radians - euler.yaw.radians) < eps)
    }

    @Test func testZeroRotationMatrix() {
        let euler = EulerAngles()
        let matrix = euler.rotationMatrix
        // Identity-like matrix (all diagonal ≈ 1, off-diagonal ≈ 0)
        #expect(abs(matrix.m11 - 1) < eps)
        #expect(abs(matrix.m22 - 1) < eps)
        #expect(abs(matrix.m33 - 1) < eps)
        #expect(abs(matrix.m12) < eps)
        #expect(abs(matrix.m13) < eps)
    }

    @Test func testZeroQuaternion() {
        let euler = EulerAngles()
        let q = euler.quaternion
        #expect(abs(q.w - 1) < eps)
        #expect(abs(q.x) < eps)
        #expect(abs(q.y) < eps)
        #expect(abs(q.z) < eps)
    }

    @Test func testDescription() {
        let e = EulerAngles(roll: Angle(degrees: 0), pitch: Angle(degrees: 0), yaw: Angle(degrees: 0))
        #expect(e.description.contains("EulerAngles"))
    }
}

struct QuaternionTests {

    @Test func testDefaultInit() {
        let q = Quaternion()
        #expect(q.x == 0); #expect(q.y == 0); #expect(q.z == 0); #expect(q.w == 0)
    }

    @Test func testInit() {
        let q = Quaternion(x: 1, y: 2, z: 3, w: 4)
        #expect(q.x == 1); #expect(q.y == 2); #expect(q.z == 3); #expect(q.w == 4)
    }

    @Test func testToRotationMatrixAndBack() {
        let original = Quaternion(x: 0, y: 0, z: 0, w: 1)
        let matrix = original.rotationMatrix
        let q = matrix.quaternion
        #expect(abs(q.w - original.w) < eps)
        #expect(abs(q.x - original.x) < eps)
        #expect(abs(q.y - original.y) < eps)
        #expect(abs(q.z - original.z) < eps)
    }

    @Test func testDescription() {
        let q = Quaternion(x: 0, y: 0, z: 0, w: 1)
        #expect(q.description.contains("Quaternion"))
    }
}

struct Rotation3DTests {

    @Test func testDefaultInit() {
        let r = Rotation3D()
        #expect(r.roll == .zero)
        #expect(r.pitch == .zero)
        #expect(r.yaw == .zero)
    }

    @Test func testInitRollPitchYaw() {
        let r = Rotation3D(roll: Angle(degrees: 10), pitch: Angle(degrees: 20), yaw: Angle(degrees: 30))
        #expect(abs(r.roll.degrees - 10) < eps)
        #expect(abs(r.pitch.degrees - 20) < eps)
        #expect(abs(r.yaw.degrees - 30) < eps)
    }

    @Test func testAddition() {
        let a = Rotation3D(roll: Angle(degrees: 10), pitch: Angle(degrees: 20), yaw: Angle(degrees: 30))
        let b = Rotation3D(roll: Angle(degrees: 5), pitch: Angle(degrees: 5), yaw: Angle(degrees: 5))
        let c = a + b
        #expect(abs(c.roll.degrees - 15) < eps)
        #expect(abs(c.pitch.degrees - 25) < eps)
        #expect(abs(c.yaw.degrees - 35) < eps)
    }

    @Test func testSubtraction() {
        let a = Rotation3D(roll: Angle(degrees: 20), pitch: Angle(degrees: 20), yaw: Angle(degrees: 20))
        let b = Rotation3D(roll: Angle(degrees: 5), pitch: Angle(degrees: 5), yaw: Angle(degrees: 5))
        let c = a - b
        #expect(abs(c.roll.degrees - 15) < eps)
    }

    @Test func testNegation() {
        let r = Rotation3D(roll: Angle(degrees: 30), pitch: Angle(degrees: 0), yaw: Angle(degrees: 0))
        let neg = -r
        #expect(abs(neg.roll.degrees - (-30)) < eps)
    }

    @Test func testEquality() {
        let a = Rotation3D(roll: Angle(degrees: 10), pitch: Angle(degrees: 20), yaw: Angle(degrees: 30))
        let b = Rotation3D(roll: Angle(degrees: 10), pitch: Angle(degrees: 20), yaw: Angle(degrees: 30))
        let c = Rotation3D()
        #expect(a == b)
        #expect(a != c)
    }

    @Test func testCompoundAdd() {
        var r = Rotation3D(roll: Angle(degrees: 10), pitch: Angle(degrees: 0), yaw: Angle(degrees: 0))
        r += Rotation3D(roll: Angle(degrees: 5), pitch: Angle(degrees: 0), yaw: Angle(degrees: 0))
        #expect(abs(r.roll.degrees - 15) < eps)
    }

    @Test func testRotationMatrixIsSet() {
        let r = Rotation3D(roll: Angle(degrees: 10), pitch: Angle(degrees: 20), yaw: Angle(degrees: 30))
        #expect(r.rotationMatrix != nil)
    }

    @Test func testQuaternionIsSet() {
        let r = Rotation3D(roll: Angle(degrees: 10), pitch: Angle(degrees: 20), yaw: Angle(degrees: 30))
        #expect(r.quaternion != nil)
    }
}
