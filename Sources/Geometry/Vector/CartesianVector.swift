import Foundation

/// Represents a Cartesian coordinate in a three-dimensional coordinate system.
///
/// If `v` is an instance of `CartesianVector`, it represents the vector:
/// _v = (x, y, z)_
///
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Cartesian_coordinate_system)
/// - Attention: This structure follows the right-hand rule.
public struct CartesianVector: CustomStringConvertible {

    /// The projection on the x-axis.
    public let x: Double

    /// The projection on the y-axis.
    public let y: Double

    /// The projection on the z-axis.
    public let z: Double

    /// The equivalent vector in spherical coordinates.
    ///
    /// Calculated as:
    /// ```
    /// r = √(x² + y² + z²)
    /// θ = arccos(z / r)   — undefined for the zero vector; returns SphericalVector() instead
    /// ϕ = atan2(y, x)
    /// ```
    public var sphericalVector: SphericalVector {
        let radial = sqrt(x * x + y * y + z * z)
        guard radial > 0 else { return SphericalVector() }
        let theta = acos(z / radial).angle
        let phi = atan2(y, x).angle

        return SphericalVector(radial: radial, theta: theta, phi: phi)
    }

    /// The equivalent vector in cylindrical coordinates.
    ///
    /// Calculated as:
    /// ```
    /// ρ = √(x² + y²)
    /// ϕ = atan2(y, x)
    /// z = z
    /// ```
    public var cylindricalVector: CylindricalVector {
        let rho = sqrt(x * x + y * y)
        let phi = atan2(y, x).angle

        return CylindricalVector(rho: rho, phi: phi, height: z)
    }

    // MARK: - Initialization

    /// Initializes a `CartesianVector` with specified x, y, and z components.
    /// - Parameter x: The projection on the x-axis.
    /// - Parameter y: The projection on the y-axis.
    /// - Parameter z: The projection on the z-axis.
    public init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        return String(format: "Cartesian(%.2f, %.2f, %.2f)", Float(x), Float(y), Float(z))
    }
}
