import Foundation

/// An object representing a motion in three dimensions.
///
/// Motion may be described in terms of displacement, distance, velocity, acceleration, time, and speed.
/// This object contains distance and weight to represent the repetition of the object along the distance.
public struct Motion {

    // MARK: - Properties

    /// Direction value representing the direction of the motion.
    public let direction: Direction

    /// Distance of the motion.
    public let distance: Double

    /// Weight of the motion (how many times it repeats).
    public let weight: UInt

    // MARK: - Initialization

    /// Initialize Motion with full data.
    public init(direction: Direction = .none, distance: Double = 0, weight: UInt = 0) {
        self.direction = direction
        self.distance = distance
        self.weight = weight
    }

    // MARK: - Description

    /// A human-readable description of the motion.
    public var description: String {
        if distance == 0 {
            return "Motion \(direction) with weight \(weight)."
        } else {
            let distanceFormatted = String(format: "%.2f", distance)
            return "[\(direction), \(weight), \(distanceFormatted)]"
        }
    }

    // MARK: - Logical Operators

    /// Returns `true` if both motions have the same direction.
    public static func == (lhs: Motion, rhs: Motion) -> Bool {
        return lhs.direction == rhs.direction
    }

    /// Returns `true` if the two motions have different directions.
    public static func != (lhs: Motion, rhs: Motion) -> Bool {
        return lhs.direction != rhs.direction
    }
}
