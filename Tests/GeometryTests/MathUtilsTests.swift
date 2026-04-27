import Testing
@testable import Geometry

struct InfinityTests {

    @Test func testInfinityIsIEEE754Infinity() {
        // Must be true IEEE-754 infinity, not merely the largest finite double.
        #expect(infinity.isInfinite)
        #expect(infinity > Double.greatestFiniteMagnitude)
        #expect(infinity == Double.infinity)
    }
}

struct MathUtilsTests {
    @Test func testClamp() async throws {
        // Normal range, value is within bounds
        #expect(clamp(value: 5, min: 1, max: 10) == 5)
        // Below minimum bound
        #expect(clamp(value: -3, min: 0, max: 5) == 0)
        // Above maximum bound
        #expect(clamp(value: 100, min: 0, max: 50) == 50)
        // Value equal to min and max (edge case)
        #expect(clamp(value: 5, min: 3, max: 3) == 3)
        // Min and max are swapped internally (min > max)
        #expect(clamp(value: 4, min: 10, max: 0) == 4)
    }
    
    @Test func testRotate() async throws {
        // Value within range
        #expect(rotate(value: 5, min: 0, max: 10) == 5)
        // Value above range, should wrap around
        #expect(rotate(value: 12, min: 0, max: 10) == 2)
        // Value below range, should wrap around
        #expect(rotate(value: -2, min: 0, max: 10) == 8)
        // Invalid range (max < min), return value unchanged
        #expect(rotate(value: 3, min: 5, max: 1) == 3)
        // Collapsed range (min == max): any input maps to min, not NaN
        #expect(rotate(value: 99, min: 5, max: 5) == 5)
        #expect(!rotate(value: 99, min: 5, max: 5).isNaN)
    }
    
    @Test func testTruncate() async throws {
        let value = 3.14159265
        // Truncate positive value to 4 decimal places
        #expect(truncate(value: value, decimalPlaces: 4) == 3.1415)
        // Truncate negative value to 4 decimal places
        #expect(truncate(value: -value, decimalPlaces: 4) == -3.1415)
        // Truncate near rounding threshold to 2 decimal places
        #expect(truncate(value: 2.9999, decimalPlaces: 2) == 2.99)
    }

    @Test func testLerp() async throws {
        // Interpolate halfway between 0 and 10
        #expect(lerp(from: 0, to: 10, t: 0.5) == 5)
        // Interpolate 25% between -5 and 5
        #expect(lerp(from: -5, to: 5, t: 0.25) == -2.5)
    }

    @Test func testInverseLerp() async throws {
        // Value halfway between 0 and 10
        #expect(inverseLerp(from: 0, to: 10, value: 5) == 0.5)
        // Value halfway between 10 and 20
        #expect(inverseLerp(from: 10, to: 20, value: 15) == 0.5)
    }

    @Test func testMap() async throws {
        // Map value in middle of 0–10 to 0–100
        #expect(map(value: 5, from: 0...10, to: 0...100) == 50)
        // Map value in middle of 10–20 to 0–1
        #expect(map(value: 15, from: 10...20, to: 0...1) == 0.5)
    }

    @Test func testSign() async throws {
        // Positive number returns 1
        #expect(sign(10) == 1)
        // Negative number returns -1
        #expect(sign(-0.1) == -1)
        // Zero returns 0
        #expect(sign(0) == 0)
    }

    @Test func testNormalize() async throws {
        // Normalize value halfway in range
        #expect(normalize(value: 5, min: 0, max: 10) == 0.5)
        // Normalize value at lower bound
        #expect(normalize(value: 10, min: 10, max: 20) == 0)
        // max <= min: returns 0, not a divide-by-zero
        #expect(normalize(value: 5, min: 10, max: 5) == 0)
        #expect(normalize(value: 5, min: 5, max: 5) == 0)
    }

    @Test func testWrap() async throws {
        // Wrap value above range
        #expect(wrap(370, min: 0, max: 360) == 10)
        // Wrap value below range
        #expect(wrap(-10, min: 0, max: 360) == 350)
        // Wrap value far above custom range
        #expect(wrap(725, min: 180, max: 540) == 365)
    }
}
