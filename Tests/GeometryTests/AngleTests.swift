import Testing
import Foundation
@testable import Geometry

struct AngleTests {

    // MARK: - Initialization

    @Test func testInitFromRadians() {
        let a = Angle(radians: .pi)
        #expect(abs(a.radians - .pi) < 1e-10)
        #expect(abs(a.degrees - 180) < 1e-10)
    }

    @Test func testInitFromDegrees() {
        let a = Angle(degrees: 90)
        #expect(abs(a.degrees - 90) < 1e-10)
        #expect(abs(a.radians - .pi / 2) < 1e-10)
    }

    @Test func testZero() {
        #expect(Angle.zero.radians == 0)
        #expect(Angle.zero.degrees == 0)
    }

    @Test func testDoubleAngleExtension() {
        let a = (Double.pi / 2).angle
        #expect(abs(a.radians - .pi / 2) < 1e-10)
    }

    // MARK: - Comparison

    @Test func testEquality() {
        let a = Angle(degrees: 45)
        let b = Angle(degrees: 45)
        let c = Angle(degrees: 90)
        #expect(a == b)
        #expect(a != c)
    }

    @Test func testComparable() {
        let small = Angle(degrees: 30)
        let large = Angle(degrees: 120)
        #expect(small < large)
        #expect(large > small)
    }

    // MARK: - Arithmetic (Angle × Angle)

    @Test func testAddition() {
        let a = Angle(degrees: 45)
        let b = Angle(degrees: 45)
        let sum = a + b
        #expect(abs(sum.degrees - 90) < 1e-10)
    }

    @Test func testSubtraction() {
        let a = Angle(degrees: 90)
        let b = Angle(degrees: 30)
        let diff = a - b
        #expect(abs(diff.degrees - 60) < 1e-10)
    }

    @Test func testNegation() {
        let a = Angle(degrees: 45)
        #expect(abs((-a).degrees - (-45)) < 1e-10)
    }

    @Test func testMultiplication() {
        let a = Angle(degrees: 45)
        let b = Angle(radians: 2)
        let result = a * b
        #expect(abs(result.radians - a.radians * b.radians) < 1e-10)
    }

    @Test func testDivision() {
        let a = Angle(radians: .pi)
        let b = Angle(radians: 2)
        let result = a / b
        #expect(abs(result.radians - .pi / 2) < 1e-10)
    }

    // MARK: - Arithmetic (Angle × Double)

    @Test func testAddDouble() {
        let a = Angle(radians: 1.0)
        let result: Double = a + 0.5
        #expect(abs(result - 1.5) < 1e-10)
    }

    @Test func testMultiplyDouble() {
        let a = Angle(radians: 2.0)
        let result: Double = a * 3.0
        #expect(abs(result - 6.0) < 1e-10)
    }

    // MARK: - Trigonometry

    @Test func testCos() {
        #expect(abs(cos(Angle(degrees: 0)) - 1.0) < 1e-10)
        #expect(abs(cos(Angle(degrees: 90))) < 1e-10)
        #expect(abs(cos(Angle(degrees: 180)) - (-1.0)) < 1e-10)
    }

    @Test func testSin() {
        #expect(abs(sin(Angle(degrees: 0))) < 1e-10)
        #expect(abs(sin(Angle(degrees: 90)) - 1.0) < 1e-10)
        #expect(abs(sin(Angle(degrees: 180))) < 1e-10)
    }

    @Test func testAsin() {
        let angle: Angle = asin(1.0)
        #expect(abs(angle.degrees - 90) < 1e-10)
    }

    @Test func testAcos() {
        let angle: Angle = acos(0.0)
        #expect(abs(angle.degrees - 90) < 1e-10)
    }

    @Test func testAtan2() {
        let angle: Angle = atan2(1.0, 0.0)
        #expect(abs(angle.degrees - 90) < 1e-10)
    }

    @Test func testAtan() {
        let angle: Angle = atan(1.0)
        #expect(abs(angle.degrees - 45) < 1e-10)
    }

    // MARK: - Round-trip

    @Test func testDegreesRadiansRoundTrip() {
        let original = 123.456
        let angle = Angle(degrees: original)
        #expect(abs(angle.degrees - original) < 1e-9)
    }
}
