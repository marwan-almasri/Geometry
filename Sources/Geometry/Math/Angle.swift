import Foundation

/// An implementation of `Angle` providing angle unit conversions.
///
/// An angle is the space between two intersecting lines or surfaces at or near the point where they meet.
/// In planar geometry, an angle is formed by two rays (the sides of the angle) sharing a common endpoint (the vertex).
///
/// Angles lie in a plane but do not necessarily have to be in a Euclidean plane.
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Angle)
public struct Angle {
    
    /// The angle in radians.
    ///
    /// Radians are the standard unit of angular measure, equal to the arc length on the unit circle.
    /// One radian is just under 57.3 degrees.
    public let radians: Double

    /// The angle in degrees.
    ///
    /// Degrees represent a measurement of plane angle, where one full rotation is 360 degrees.
    ///
    /// Computed using the formula:
    /// degree = radian × (180 / π)
    public var degrees: Double { radians * 180 / .pi }

    /// Creates an angle from a value in radians.
    /// - Parameter radians: The angle in radians.
    public init(radians: Double) {
        self.radians = radians
    }

    /// Creates an angle from a value in degrees.
    /// - Parameter degrees: The angle in degrees.
    public init(degrees: Double) {
        self.radians = degrees * .pi / 180
    }
}

extension Angle: Equatable, Comparable {
    public static func == (lhs: Angle, rhs: Angle) -> Bool {
        lhs.radians == rhs.radians
    }
    
    public static func < (lhs: Angle, rhs: Angle) -> Bool {
        lhs.radians < rhs.radians
    }
}

public extension Angle {
    static var zero: Angle { Angle(radians: 0) }
    
    // MARK: - Arithmetic Operators

    static prefix func - (angle: Angle) -> Angle {
        Angle(radians: -angle.radians)
    }

    static prefix func + (angle: Angle) -> Angle {
        angle
    }
    
    static func + (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians + rhs.radians)
    }

    static func - (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians - rhs.radians)
    }

    static func * (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians * rhs.radians)
    }

    static func / (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians / rhs.radians)
    }

    // MARK: - Angle and Double

    static func + (lhs: Angle, rhs: Double) -> Double {
        lhs.radians + rhs
    }

    static func + (lhs: Double, rhs: Angle) -> Double {
        lhs + rhs.radians
    }

    static func - (lhs: Angle, rhs: Double) -> Double {
        lhs.radians - rhs
    }

    static func - (lhs: Double, rhs: Angle) -> Double {
        lhs - rhs.radians
    }

    static func * (lhs: Angle, rhs: Double) -> Double {
        lhs.radians * rhs
    }

    static func * (lhs: Double, rhs: Angle) -> Double {
        lhs * rhs.radians
    }

    static func / (lhs: Angle, rhs: Double) -> Double {
        lhs.radians / rhs
    }

    static func / (lhs: Double, rhs: Angle) -> Double {
        lhs / rhs.radians
    }

    // MARK: - Angle and Int

    static func + (lhs: Angle, rhs: Int) -> Double {
        lhs.radians + Double(rhs)
    }

    static func + (lhs: Int, rhs: Angle) -> Double {
        Double(lhs) + rhs.radians
    }

    static func - (lhs: Angle, rhs: Int) -> Double {
        lhs.radians - Double(rhs)
    }

    static func - (lhs: Int, rhs: Angle) -> Double {
        Double(lhs) - rhs.radians
    }

    static func * (lhs: Angle, rhs: Int) -> Double {
        lhs.radians * Double(rhs)
    }

    static func * (lhs: Int, rhs: Angle) -> Double {
        Double(lhs) * rhs.radians
    }

    static func / (lhs: Angle, rhs: Int) -> Double {
        lhs.radians / Double(rhs)
    }

    static func / (lhs: Int, rhs: Angle) -> Double {
        Double(lhs) / rhs.radians
    }

    // MARK: - Angle and Float

    static func + (lhs: Angle, rhs: Float) -> Double {
        lhs.radians + Double(rhs)
    }

    static func + (lhs: Float, rhs: Angle) -> Double {
        Double(lhs) + rhs.radians
    }

    static func - (lhs: Angle, rhs: Float) -> Double {
        lhs.radians - Double(rhs)
    }

    static func - (lhs: Float, rhs: Angle) -> Double {
        Double(lhs) - rhs.radians
    }

    static func * (lhs: Angle, rhs: Float) -> Double {
        lhs.radians * Double(rhs)
    }

    static func * (lhs: Float, rhs: Angle) -> Double {
        Double(lhs) * rhs.radians
    }

    static func / (lhs: Angle, rhs: Float) -> Double {
        lhs.radians / Double(rhs)
    }

    static func / (lhs: Float, rhs: Angle) -> Double {
        Double(lhs) / rhs.radians
    }
}

// MARK: - Trigonometry functions

/// Returns the cosine of the given angle.
/// - Parameter value: The angle.
/// - Returns: The cosine of the angle.
func cos(_ value: Angle) -> Double {
    cos(value.radians)
}

/// Returns the sine of the given angle.
/// - Parameter value: The angle.
/// - Returns: The sine of the angle.
func sin(_ value: Angle) -> Double {
    sin(value.radians)
}

/// Returns the arcsine (inverse sine) of the given value in radians.
/// - Parameter value: A value between -1.0 and 1.0.
/// - Returns: The angle in radians whose sine is equal to the given value.
func asin(_ value: Double) -> Angle {
    Foundation.asin(value).angle
}

/// Returns the arccosine (inverse cosine) of the given value in radians.
/// - Parameter value: A value between -1.0 and 1.0.
/// - Returns: The angle in radians whose cosine is equal to the given value.
func acos(_ value: Double) -> Angle {
    Foundation.acos(value).angle
}

/// Returns the arctangent (inverse tangent) of the given value in radians.
/// - Parameter value: The value whose arctangent is to be returned.
/// - Returns: The angle in radians whose tangent is equal to the given value.
func atan(_ value: Double) -> Angle {
    Foundation.atan(value).angle
}

/// Returns the arctangent of y/x, using the signs of the two to determine the correct quadrant.
/// - Parameter y: The y-coordinate.
/// - Parameter x: The x-coordinate.
/// - Returns: The angle in radians between the positive x-axis and the point (x, y).
func atan2(_ y: Double, _ x: Double) -> Angle {
    Foundation.atan2(y, x).angle
}

public extension Double {
    var angle: Angle { .init(radians: self) }
}
