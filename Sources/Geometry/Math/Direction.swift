import Foundation

/// Represents the horizontal direction on the XY plane.
public enum HorizontalDirection: String, CaseIterable, Sendable {
    case none, north, east, south, west, northEast, southEast, southWest, northWest

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
    case none, up, down

    var arrow: String {
        switch self {
        case .none: return ""
        case .up: return "↑"
        case .down: return "↓"
        }
    }
}

/// Represents a 3D direction: horizontal (XY) and vertical (Z).
public struct Direction: Equatable, Sendable, CustomStringConvertible, CaseIterable {

    public let horizontal: HorizontalDirection
    public let vertical: VerticalDirection

    /// Default initializer
    public init(horizontal: HorizontalDirection = .none, vertical: VerticalDirection = .none) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    /// Initialize from azimuth (ϕ) and elevation (θ)
    ///
    /// - Parameter theta: Vertical inclination angle (0 = Up, 90 = Horizontal, 180 = Down)
    /// - Parameter phi: Azimuth angle in degrees (0 = North, 90 = East, etc.)
    public init(theta: Angle = 90.0.angle, phi: Angle) {
        vertical = Direction.verticalDirection(from: theta)
        horizontal = Direction.horizontalDirection(from: phi)
    }

    public var description: String {
        let hDesc = horizontal == .none ? "" : horizontal.rawValue.capitalized
        let vDesc = vertical == .none ? "" : vertical.rawValue.capitalized
        let desc = [hDesc, vDesc].filter { !$0.isEmpty }.joined(separator: " ")

        let short = [horizontal.shortLabel, vertical.arrow].joined()
        return desc.isEmpty ? "None" : "\(desc) (\(short))"
    }
    
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

    public static let none = Direction()
    public static let north = Direction(horizontal: .north)
    public static let east = Direction(horizontal: .east)
    public static let south = Direction(horizontal: .south)
    public static let west = Direction(horizontal: .west)
    public static let up = Direction(vertical: .up)
    public static let down = Direction(vertical: .down)

    // MARK: - Horizontal Intercardinal Directions

    public static let northEast = Direction(horizontal: .northEast)
    public static let southEast = Direction(horizontal: .southEast)
    public static let southWest = Direction(horizontal: .southWest)
    public static let northWest = Direction(horizontal: .northWest)

    // MARK: - Vertical Up Directions

    public static let northUp = Direction(horizontal: .north, vertical: .up)
    public static let northEastUp = Direction(horizontal: .northEast, vertical: .up)
    public static let eastUp = Direction(horizontal: .east, vertical: .up)
    public static let southEastUp = Direction(horizontal: .southEast, vertical: .up)
    public static let southUp = Direction(horizontal: .south, vertical: .up)
    public static let southWestUp = Direction(horizontal: .southWest, vertical: .up)
    public static let westUp = Direction(horizontal: .west, vertical: .up)
    public static let northWestUp = Direction(horizontal: .northWest, vertical: .up)

    // MARK: - Vertical Down Directions

    public static let northDown = Direction(horizontal: .north, vertical: .down)
    public static let northEastDown = Direction(horizontal: .northEast, vertical: .down)
    public static let eastDown = Direction(horizontal: .east, vertical: .down)
    public static let southEastDown = Direction(horizontal: .southEast, vertical: .down)
    public static let southDown = Direction(horizontal: .south, vertical: .down)
    public static let southWestDown = Direction(horizontal: .southWest, vertical: .down)
    public static let westDown = Direction(horizontal: .west, vertical: .down)
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
