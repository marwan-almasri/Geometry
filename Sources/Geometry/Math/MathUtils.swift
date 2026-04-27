import Foundation

/// The IEEE 754 positive infinity value.
///
/// **Infinity** (symbol: ∞) is an abstract concept describing something without any bound or larger than any number.
/// This is `Double.infinity` — distinct from `Double.greatestFiniteMagnitude`, which is merely the largest
/// representable finite number (~1.8 × 10³⁰⁸).
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Infinity)
public let infinity = Double.infinity

/// Clamps a value to a range between `min` and `max`.
///
/// Clamping is the process of limiting a position to an area.
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Clamping_(graphics))
/// - Warning: `min` must be less than or equal to `max`.
/// - Note: If `min` is greater than `max`, the values will be swapped.
/// - Parameter value: The current value.
/// - Parameter min: The minimum value.
/// - Parameter max: The maximum value.
/// - Returns: A value within the range `[min, max]`. If outside, returns `min` or `max`.
public func clamp<T: Comparable>(value: T, min: T, max: T) -> T {
    if max == min {
        return min
    }

    var minimum = min
    var maximum = max

    if minimum > maximum {
        swap(&minimum, &maximum)
    }

    if value > maximum {
        return maximum
    } else if value < minimum {
        return minimum
    } else {
        return value
    }
}

/// Rotates a value within a range between `min` and `max`.
///
/// Rotating adjusts a value to wrap around a range, like angles going from 0 to 360.
/// - Parameter value: The current value.
/// - Parameter min: The minimum value.
/// - Parameter max: The maximum value.
/// - Returns: A value rotated within the specified range.
/// - Warning: If `max` is less than `min`, the original value is returned unchanged.
///   If `max` equals `min`, `min` is returned for any input.
public func rotate(value: Double, min: Double, max: Double) -> Double {
    guard max >= min else { return value }

    let delta = max - min
    // When min == max the range collapses to a single point; any value maps to that point.
    guard delta > 0 else { return min }

    if value > max {
        return min + (value - max).truncatingRemainder(dividingBy: delta)
    } else if value < min {
        return max - (min - value).truncatingRemainder(dividingBy: delta)
    } else {
        return value
    }
}

/// Truncates a number to a specified number of decimal places without rounding.
///
/// A method of approximating a decimal number by dropping all decimal places past a certain point.
///
/// Example:
/// ```swift
/// let value = Geometry.truncate(3.14159265, decimalPlaces: 4)
/// // value will be 3.1415
/// ```
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Truncation)
/// - Parameter value: The value to truncate.
/// - Parameter decimalPlaces: The number of decimal places to keep.
/// - Returns: The truncated value.
public func truncate(value: Double, decimalPlaces place: UInt) -> Double {
    let v = abs(value)
    let sign = value < 0 ? -1.0 : 1.0
    let factor = pow(10.0, Double(place))

    return sign * (floor(factor * v) / factor)
}
/// Linearly interpolates between `a` and `b` using a parameter `t` in the range [0, 1].
///
/// Interpolation is the process of estimating unknown values between two known values.
/// - Parameter a: The start value.
/// - Parameter b: The end value.
/// - Parameter t: The interpolation factor, typically in the range [0, 1].
/// - Returns: The interpolated value.
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Linear_interpolation)
public func lerp(from a: Double, to b: Double, t: Double) -> Double {
    a + (b - a) * t
}

/// Calculates the interpolation factor `t` given a value between `a` and `b`.
///
/// Inverse interpolation determines how far along a range a particular value is.
/// - Parameter a: The start value of the range.
/// - Parameter b: The end value of the range.
/// - Parameter value: The value to evaluate.
/// - Returns: A normalized factor `t` representing the relative position between `a` and `b`.
/// - Warning: If `a` is equal to `b`, this will result in a division by zero.
public func inverseLerp(from a: Double, to b: Double, value: Double) -> Double {
    (value - a) / (b - a)
}

/// Maps a value from one numerical range to another.
///
/// This function transforms a value from a source range to a proportionally equivalent value in a target range.
/// - Parameter value: The value to map.
/// - Parameter source: The original range that contains the input value.
/// - Parameter target: The target range to map the value into.
/// - Returns: A value proportionally mapped into the target range.
/// - Warning: If `source.lowerBound` is equal to `source.upperBound`, this will result in a division by zero.
public func map(value: Double, from source: ClosedRange<Double>, to target: ClosedRange<Double>) -> Double {
    let t = inverseLerp(from: source.lowerBound, to: source.upperBound, value: value)
    return lerp(from: target.lowerBound, to: target.upperBound, t: t)
}

/// Returns the sign of a given number.
///
/// Sign is a property that indicates whether a number is positive, negative, or zero.
/// - Parameter value: A `Double` value.
/// - Returns: `1` if the value is positive, `-1` if negative, and `0` if zero.
public func sign(_ value: Double) -> Int {
    if value > 0 { return 1 }
    if value < 0 { return -1 }
    return 0
}

/// Normalizes a value to a 0...1 range within a specified minimum and maximum.
///
/// Useful for converting absolute values into relative representations.
/// - Parameter value: The current value.
/// - Parameter min: The minimum value of the original range.
/// - Parameter max: The maximum value of the original range.
/// - Returns: A normalized value between `0` and `1`.
/// - Warning: If `max` is less than or equal to `min`, the function returns `0`.
public func normalize(value: Double, min: Double, max: Double) -> Double {
    guard max > min else { return 0 }
    return (value - min) / (max - min)
}

/// Wraps a floating-point value to a circular range between `min` and `max`.
///
/// Useful for angle wrapping or any value that should rotate within a range.
/// - Parameter value: The value to wrap.
/// - Parameter min: The minimum bound of the wrap range.
/// - Parameter max: The maximum bound of the wrap range.
/// - Returns: A value wrapped to the range `[min, max)`.
/// - Warning: If `max` is less than or equal to `min`, the function returns the original value.
public func wrap(_ value: Double, min: Double, max: Double) -> Double {
    let range = max - min
    guard range > 0 else { return value }
    let result = (value - min).truncatingRemainder(dividingBy: range)
    let adjusted = result < 0 ? result + range : result
    return adjusted + min
}
