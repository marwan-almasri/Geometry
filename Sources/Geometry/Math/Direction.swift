import Foundation

/// Represents the horizontal direction on the XY plane.
public enum HorizontalDirection: String, CaseIterable, Sendable {

    /// No horizontal component.
    case none

    /// North — positive Y axis (0°).
    case north

    /// East — positive X axis (90°).
    case east

    /// South — negative Y axis (180°).
    case south

    /// West — negative X axis (270°).
    case west

    /// North-east diagonal (45°).
    case northEast

    /// South-east diagonal (135°).
    case southEast

    /// South-west diagonal (225°).
    case southWest

    /// North-west diagonal (315°).
    case northWest

    var shortLabel: String {
        switch self {
        case .none: return ""
        case .north: return "N"
        case .northEast: return "NE"
        case .east: return "E"
        case .southEast: return "SE"
        case .south: return "S"
        case .southWest: return "SW"
        case .west: return "W"
        case .northWest: return "NW"
        }
    }
}

/// Represents the vertical direction on the Z axis.
public enum VerticalDirection: String, CaseIterable, Sendable {

    /// No vertical component — horizontal plane.
    case none

    /// Upward — positive Z axis.
    case up

    /// Downward — negative Z axis.
    case down

    var arrow: String {
        switch self {
        case .none: return ""
        case .up: return "↑"
        case .down: return "↓"
        }
    }
}

/// Represents a 3D direction: horizontal (XY) and vertical (Z).
///
/// A `Direction` combines a `HorizontalDirection` with a `VerticalDirection` to form one of
/// 27 discrete compass directions (8 horizontal × 3 vertical, plus horizontal-only, vertical-only,
/// and the neutral "none").
public struct Direction: Equatable, Sendable, CustomStringConvertible, CaseIterable {

    /// The horizontal component of this direction.
    public let horizontal: HorizontalDirection

    /// The vertical component of this direction.
    public let vertical: VerticalDirection

    /// A human-readable description of the direction, e.g. `"North Up (N↑)"`.
    public var description: String {
        let hDesc = horizontal == .none ? "" : horizontal.rawValue.capitalized
        let vDesc = vertical == .none ? "" : vertical.rawValue.capitalized
        let desc = [hDesc, vDesc].filter { !$0.isEmpty }.joined(separator: " ")

        let short = [horizontal.shortLabel, vertical.arrow].joined()
        return desc.isEmpty ? "None" : "\(desc) (\(short))"
    }

    /// Default initializer.
    /// - Parameter horizontal: Horizontal component. Defaults to `.none`.
    /// - Parameter vertical: Vertical component. Defaults to `.none`.
    public init(horizontal: HorizontalDirection = .none, vertical: VerticalDirection = .none) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    /// Initialize from azimuth (ϕ) and elevation (θ).
    ///
    /// - Parameter theta: Vertical inclination angle (0 = Up, 90 = Horizontal, 180 = Down).
    /// - Parameter phi: Azimuth angle in degrees (0 = North, 90 = East, etc.).
    public init(theta: Angle = 90.0.angle, phi: Angle) {
        vertical = Direction.verticalDirection(from: theta)
        horizontal = Direction.horizontalDirection(from: phi)
    }

    /// All 27 discrete directions, ordered from neutral through horizontal, then combined up and down variants.
    public static let allCases: [Direction] = [
        .none,
        .north,
        .east,
        .south,
        .west,
        .up,
        .down,
        .northEast,
        .southEast,
        .southWest,
        .northWest,
        .northUp,
        .northEastUp,
        .eastUp,
        .southEastUp,
        .southUp,
        .southWestUp,
        .westUp,
        .northWestUp,
        .northDown,
        .northEastDown,
        .eastDown,
        .southEastDown,
        .southDown,
        .southWestDown,
        .westDown,
        .northWestDown
    ]

    // MARK: - Static Presets

    /// No direction — neutral.
    public static let none = Direction()

    /// North (0°, horizontal).
    public static let north = Direction(horizontal: .north)

    /// East (90°, horizontal).
    public static let east = Direction(horizontal: .east)

    /// South (180°, horizontal).
    public static let south = Direction(horizontal: .south)

    /// West (270°, horizontal).
    public static let west = Direction(horizontal: .west)

    /// Straight up (positive Z only).
    public static let up = Direction(vertical: .up)

    /// Straight down (negative Z only).
    public static let down = Direction(vertical: .down)

    // MARK: - Horizontal Intercardinal Directions

    /// North-east (45°, horizontal).
    public static let northEast = Direction(horizontal: .northEast)

    /// South-east (135°, horizontal).
    public static let southEast = Direction(horizontal: .southEast)

    /// South-west (225°, horizontal).
    public static let southWest = Direction(horizontal: .southWest)

    /// North-west (315°, horizontal).
    public static let northWest = Direction(horizontal: .northWest)

    // MARK: - Vertical Up Directions

    /// North and up.
    public static let northUp = Direction(horizontal: .north, vertical: .up)

    /// North-east and up.
    public static let northEastUp = Direction(horizontal: .northEast, vertical: .up)

    /// East and up.
    public static let eastUp = Direction(horizontal: .east, vertical: .up)

    /// South-east and up.
    public static let southEastUp = Direction(horizontal: .southEast, vertical: .up)

    /// South and up.
    public static let southUp = Direction(horizontal: .south, vertical: .up)

    /// South-west and up.
    public static let southWestUp = Direction(horizontal: .southWest, vertical: .up)

    /// West and up.
    public static let westUp = Direction(horizontal: .west, vertical: .up)

    /// North-west and up.
    public static let northWestUp = Direction(horizontal: .northWest, vertical: .up)

    // MARK: - Vertical Down Directions

    /// North and down.
    public static let northDown = Direction(horizontal: .north, vertical: .down)

    /// North-east and down.
    public static let northEastDown = Direction(horizontal: .northEast, vertical: .down)

    /// East and down.
    public static let eastDown = Direction(horizontal: .east, vertical: .down)

    /// South-east and down.
    public static let southEastDown = Direction(horizontal: .southEast, vertical: .down)

    /// South and down.
    public static let southDown = Direction(horizontal: .south, vertical: .down)

    /// South-west and down.
    public static let southWestDown = Direction(horizontal: .southWest, vertical: .down)

    /// West and down.
    public static let westDown = Direction(horizontal: .west, vertical: .down)

    /// North-west and down.
    public static let northWestDown = Direction(horizontal: .northWest, vertical: .down)

    // MARK: - Angle Helpers

    private static func horizontalDirection(from angle: Angle) -> HorizontalDirection {
        let normalized = fmod(angle.degrees < 0 ? angle.degrees + 360 : angle.degrees, 360)

        switch normalized {
        case 0..<22.5, 337.5...360:
            return .north
        case 22.5..<67.5:
            return .northEast
        case 67.5..<112.5:
            return .east
        case 112.5..<157.5:
            return .southEast
        case 157.5..<202.5:
            return .south
        case 202.5..<247.5:
            return .southWest
        case 247.5..<292.5:
            return .west
        case 292.5..<337.5:
            return .northWest
        default:
            return .none
        }
    }

    private static func verticalDirection(from theta: Angle) -> VerticalDirection {
        switch theta.degrees {
        case 0..<45:
            return .up
        case 135...180:
            return .down
        default:
            return .none
        }
    }
}
