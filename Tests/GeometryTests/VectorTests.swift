import Testing
import Foundation
@testable import Geometry

private let eps = 1e-9

struct CartesianVectorTests {

    @Test func testDefaultInit() {
        let v = CartesianVector()
        #expect(v.x == 0); #expect(v.y == 0); #expect(v.z == 0)
    }

    @Test func testInit() {
        let v = CartesianVector(x: 1, y: 2, z: 3)
        #expect(v.x == 1); #expect(v.y == 2); #expect(v.z == 3)
    }

    @Test func testToSphericalAndBack() {
        let cart = CartesianVector(x: 1, y: 0, z: 0)
        let sph = cart.sphericalVector
        let back = sph.cartesianVector
        #expect(abs(back.x - cart.x) < eps)
        #expect(abs(back.y - cart.y) < eps)
        #expect(abs(back.z - cart.z) < eps)
    }

    @Test func testToCylindricalAndBack() {
        let cart = CartesianVector(x: 3, y: 4, z: 5)
        let cyl = cart.cylindricalVector
        let back = cyl.cartesianVector
        #expect(abs(back.x - cart.x) < eps)
        #expect(abs(back.y - cart.y) < eps)
        #expect(abs(back.z - cart.z) < eps)
    }

    @Test func testSphericalRadial() {
        let cart = CartesianVector(x: 3, y: 4, z: 0)
        let sph = cart.sphericalVector
        // r = √(9 + 16 + 0) = 5
        #expect(abs(sph.radial - 5) < eps)
    }

    @Test func testZeroVectorToSphericalIsZero() {
        // The zero vector has no direction; acos(0/0) would be NaN without the guard.
        let zero = CartesianVector()
        let sph = zero.sphericalVector
        #expect(sph.radial == 0)
        #expect(!sph.theta.radians.isNaN)
        #expect(!sph.phi.radians.isNaN)
    }

    @Test func testCylindricalRho() {
        let cart = CartesianVector(x: 3, y: 4, z: 7)
        let cyl = cart.cylindricalVector
        // ρ = √(9 + 16) = 5
        #expect(abs(cyl.rho - 5) < eps)
        #expect(abs(cyl.height - 7) < eps)
    }
}

struct SphericalVectorTests {

    @Test func testDefaultInit() {
        let v = SphericalVector()
        #expect(v.radial == 0)
    }

    @Test func testToCartesianAndBack() {
        let sph = SphericalVector(radial: 5, theta: Angle(degrees: 90), phi: Angle(degrees: 0))
        let cart = sph.cartesianVector
        let back = cart.sphericalVector
        #expect(abs(back.radial - sph.radial) < eps)
    }

    @Test func testToCylindrical() {
        let sph = SphericalVector(radial: 5, theta: Angle(degrees: 90), phi: Angle(degrees: 0))
        let cyl = sph.cylindricalVector
        // theta = 90° → horizontal plane → rho = radial, height ≈ 0
        #expect(abs(cyl.rho - 5) < eps)
        #expect(abs(cyl.height) < eps)
    }
}

struct CylindricalVectorTests {

    @Test func testDefaultInit() {
        let v = CylindricalVector()
        #expect(v.rho == 0)
        #expect(v.height == 0)
    }

    @Test func testZeroCylindricalToSphericalIsZero() {
        // rho=0 and height=0 → radial=0; acos(0/0) would be NaN without the guard.
        let zero = CylindricalVector()
        let sph = zero.sphericalVector
        #expect(sph.radial == 0)
        #expect(!sph.theta.radians.isNaN)
    }

    @Test func testToCylindricalAndBack() {
        let original = CylindricalVector(rho: 3, phi: Angle(degrees: 45), height: 4)
        let cart = original.cartesianVector
        let back = cart.cylindricalVector
        #expect(abs(back.rho - original.rho) < eps)
        #expect(abs(back.height - original.height) < eps)
    }
}

struct Vector3DTests {

    @Test func testDefaultInit() {
        let v = Vector3D()
        #expect(v.x == 0); #expect(v.y == 0); #expect(v.z == 0)
    }

    @Test func testCartesianInit() {
        let v = Vector3D(x: 1, y: 2, z: 3)
        #expect(v.x == 1); #expect(v.y == 2); #expect(v.z == 3)
    }

    @Test func testCartesianInitSetsSpherical() {
        let v = Vector3D(x: 0, y: 0, z: 5)
        #expect(abs(v.radial - 5) < eps)
    }

    @Test func testSphericalInit() {
        let v = Vector3D(radial: 5, theta: Angle(degrees: 90), phi: Angle(degrees: 0))
        #expect(abs(v.radial - 5) < eps)
        #expect(abs(v.theta.degrees - 90) < eps)
        #expect(abs(v.phi.degrees - 0) < eps)
    }

    @Test func testCylindricalInit() {
        let v = Vector3D(rho: 3, phi: Angle(degrees: 0), height: 4)
        #expect(abs(v.rho - 3) < eps)
        #expect(abs(v.height - 4) < eps)
    }

    @Test func testUnitValueInit() {
        let v = Vector3D(value: 2)
        #expect(v.x == 2); #expect(v.y == 2); #expect(v.z == 2)
    }

    @Test func testSphericalCartesianRoundTrip() {
        let original = Vector3D(x: 3, y: 4, z: 0)
        let v2 = Vector3D(radial: original.radial, theta: original.theta, phi: original.phi)
        #expect(abs(v2.x - original.x) < eps)
        #expect(abs(v2.y - original.y) < eps)
        #expect(abs(v2.z - original.z) < eps)
    }

    @Test func testCylindricalCartesianRoundTrip() {
        let original = Vector3D(x: 3, y: 4, z: 5)
        let v2 = Vector3D(rho: original.rho, phi: original.phi, height: original.height)
        #expect(abs(v2.x - original.x) < eps)
        #expect(abs(v2.y - original.y) < eps)
        #expect(abs(v2.z - original.z) < eps)
    }

    // MARK: - Norm operator ~

    @Test func testNorm() {
        let v = Vector3D(x: 3, y: 4, z: 0)
        #expect(abs(~v - 5) < eps)
    }

    @Test func testNormZero() {
        let v = Vector3D()
        #expect(~v == 0)
    }

    // MARK: - Distance operator ~

    @Test func testDistance() {
        let a = Vector3D(x: 0, y: 0, z: 0)
        let b = Vector3D(x: 3, y: 4, z: 0)
        #expect(abs((a ~ b) - 5) < eps)
    }

    @Test func testDistanceSelf() {
        let v = Vector3D(x: 1, y: 2, z: 3)
        #expect((v ~ v) == 0)
    }

    // MARK: - Arithmetic

    @Test func testAddition() {
        let a = Vector3D(x: 1, y: 2, z: 3)
        let b = Vector3D(x: 4, y: 5, z: 6)
        let c = a + b
        #expect(c.x == 5); #expect(c.y == 7); #expect(c.z == 9)
    }

    @Test func testSubtraction() {
        let a = Vector3D(x: 5, y: 7, z: 9)
        let b = Vector3D(x: 1, y: 2, z: 3)
        let c = a - b
        #expect(c.x == 4); #expect(c.y == 5); #expect(c.z == 6)
    }

    @Test func testMultiplication() {
        let a = Vector3D(x: 2, y: 3, z: 4)
        let b = Vector3D(x: 5, y: 6, z: 7)
        let c = a * b
        #expect(c.x == 10); #expect(c.y == 18); #expect(c.z == 28)
    }

    @Test func testDivision() {
        let a = Vector3D(x: 10, y: 12, z: 14)
        let b = Vector3D(x: 2, y: 4, z: 7)
        let c = a / b
        #expect(c.x == 5); #expect(c.y == 3); #expect(c.z == 2)
    }

    @Test func testCompoundAdd() {
        var a = Vector3D(x: 1, y: 2, z: 3)
        a += Vector3D(x: 1, y: 1, z: 1)
        #expect(a.x == 2); #expect(a.y == 3); #expect(a.z == 4)
    }

    // MARK: - Logical operators

    @Test func testEquality() {
        let a = Vector3D(x: 1, y: 2, z: 3)
        let b = Vector3D(x: 1, y: 2, z: 3)
        let c = Vector3D(x: 0, y: 0, z: 0)
        #expect(a == b)
        #expect(a != c)
    }

    @Test func testLessThan() {
        let small = Vector3D(x: 1, y: 0, z: 0)
        let large = Vector3D(x: 10, y: 0, z: 0)
        #expect(small < large)
        #expect(large > small)
    }

    // MARK: - Heading direction

    @Test func testHeadingDirectionNorth() {
        // z-axis vector → up
        let v = Vector3D(x: 0, y: 0, z: 5)
        #expect(v.headingDirection.vertical == .up)
    }
}
