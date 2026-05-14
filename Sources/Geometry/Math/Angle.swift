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
    ///
    /// ![Equation](https://latex.codecogs.com/png.latex?%5Ctext%7Bdegrees%7D%3D%5Ctext%7Bradians%7D%5Ctimes%5Cfrac%7B180%7D%7B%5Cpi%7D)
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

/// `Equatable` and `Comparable` conformance for `Angle`, comparing in radian space.
extension Angle: Equatable, Comparable {

    /// Returns `true` if both angles have the same radian value.
    public static func == (lhs: Angle, rhs: Angle) -> Bool {
        lhs.radians == rhs.radians
    }

    /// Returns `true` if `lhs` is smaller than `rhs` in radian space.
    public static func < (lhs: Angle, rhs: Angle) -> Bool {
        lhs.radians < rhs.radians
    }
}

/// Angle constants and arithmetic operators.
public extension Angle {

    /// The zero angle (0 radians).
    static var zero: Angle { Angle(radians: 0) }

    // MARK: - Angle–Angle Operators

    /// Negates the angle.
    /// - Parameter angle: The angle to negate.
    /// - Returns: An angle with the negated radian value.
    static prefix func - (angle: Angle) -> Angle {
        Angle(radians: -angle.radians)
    }

    /// Returns the angle unchanged.
    static prefix func + (angle: Angle) -> Angle {
        angle
    }

    /// Adds two angles.
    /// - Returns: The sum of the radian values as an `Angle`.
    static func + (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians + rhs.radians)
    }

    /// Subtracts one angle from another.
    /// - Returns: The difference of the radian values as an `Angle`.
    static func - (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians - rhs.radians)
    }

    /// Multiplies two angles.
    /// - Returns: The product of the radian values as an `Angle`.
    static func * (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians * rhs.radians)
    }

    /// Divides one angle by another.
    /// - Returns: The quotient of the radian values as an `Angle`.
    static func / (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians / rhs.radians)
    }

    // MARK: - Angle and Double

    /// Adds an angle's radian value to a `Double`.
    static func + (lhs: Angle, rhs: Double) -> Double { lhs.radians + rhs }

    /// Adds a `Double` to an angle's radian value.
    static func + (lhs: Double, rhs: Angle) -> Double { lhs + rhs.radians }

    /// Subtracts a `Double` from an angle's radian value.
    static func - (lhs: Angle, rhs: Double) -> Double { lhs.radians - rhs }

    /// Subtracts an angle's radian value from a `Double`.
    static func - (lhs: Double, rhs: Angle) -> Double { lhs - rhs.radians }

    /// Multiplies an angle's radian value by a `Double`.
    static func * (lhs: Angle, rhs: Double) -> Double { lhs.radians * rhs }

    /// Multiplies a `Double` by an angle's radian value.
    static func * (lhs: Double, rhs: Angle) -> Double { lhs * rhs.radians }

    /// Divides an angle's radian value by a `Double`.
    static func / (lhs: Angle, rhs: Double) -> Double { lhs.radians / rhs }

    /// Divides a `Double` by an angle's radian value.
    static func / (lhs: Double, rhs: Angle) -> Double { lhs / rhs.radians }

    // MARK: - Angle and Int

    /// Adds an angle's radian value to an `Int` (converted to `Double`).
    static func + (lhs: Angle, rhs: Int) -> Double { lhs.radians + Double(rhs) }

    /// Adds an `Int` to an angle's radian value.
    static func + (lhs: Int, rhs: Angle) -> Double { Double(lhs) + rhs.radians }

    /// Subtracts an `Int` from an angle's radian value.
    static func - (lhs: Angle, rhs: Int) -> Double { lhs.radians - Double(rhs) }

    /// Subtracts an angle's radian value from an `Int`.
    static func - (lhs: Int, rhs: Angle) -> Double { Double(lhs) - rhs.radians }

    /// Multiplies an angle's radian value by an `Int`.
    static func * (lhs: Angle, rhs: Int) -> Double { lhs.radians * Double(rhs) }

    /// Multiplies an `Int` by an angle's radian value.
    static func * (lhs: Int, rhs: Angle) -> Double { Double(lhs) * rhs.radians }

    /// Divides an angle's radian value by an `Int`.
    static func / (lhs: Angle, rhs: Int) -> Double { lhs.radians / Double(rhs) }

    /// Divides an `Int` by an angle's radian value.
    static func / (lhs: Int, rhs: Angle) -> Double { Double(lhs) / rhs.radians }

    // MARK: - Angle and Float

    /// Adds an angle's radian value to a `Float` (converted to `Double`).
    static func + (lhs: Angle, rhs: Float) -> Double { lhs.radians + Double(rhs) }

    /// Adds a `Float` to an angle's radian value.
    static func + (lhs: Float, rhs: Angle) -> Double { Double(lhs) + rhs.radians }

    /// Subtracts a `Float` from an angle's radian value.
    static func - (lhs: Angle, rhs: Float) -> Double { lhs.radians - Double(rhs) }

    /// Subtracts an angle's radian value from a `Float`.
    static func - (lhs: Float, rhs: Angle) -> Double { Double(lhs) - rhs.radians }

    /// Multiplies an angle's radian value by a `Float`.
    static func * (lhs: Angle, rhs: Float) -> Double { lhs.radians * Double(rhs) }

    /// Multiplies a `Float` by an angle's radian value.
    static func * (lhs: Float, rhs: Angle) -> Double { Double(lhs) * rhs.radians }

    /// Divides an angle's radian value by a `Float`.
    static func / (lhs: Angle, rhs: Float) -> Double { lhs.radians / Double(rhs) }

    /// Divides a `Float` by an angle's radian value.
    static func / (lhs: Float, rhs: Angle) -> Double { Double(lhs) / rhs.radians }
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

/// `Double` convenience extension for constructing an `Angle` from a radian value.
public extension Double {
    /// Wraps this `Double` value (in radians) as an `Angle`.
    var angle: Angle { .init(radians: self) }
}
