import Foundation

/// Represents a cylindrical coordinate in a three-dimensional coordinate system.
///
/// A `CylindricalVector` is defined by its radial distance ρ, azimuthal angle ϕ, and height z.
///
/// If `v` is an instance of `CylindricalVector`, it represents:
/// _v = (ρ, ϕ, z)_
///
/// Where:
/// - ρ ∈ [0, ∞)
/// - ϕ ∈ [−π, +π)
/// - z ∈ (−∞, +∞)
///
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Cylindrical_coordinate_system)
public struct CylindricalVector: CustomStringConvertible {

    /// The radial distance ρ in the xy-plane (ρ ≥ 0).
    public let rho: Double

    /// The azimuthal angle ϕ in radians, measured from the x-axis in the xy-plane.
    ///
    /// ϕ ∈ [−π, +π)
    public let phi: Angle

    /// The height (z-coordinate), representing the signed distance from the xy-plane.
    public let height: Double

    /// The equivalent vector in Cartesian coordinates.
    ///
    /// Calculated as:
    /// ```
    /// x = ρ × cos(ϕ)
    /// y = ρ × sin(ϕ)
    /// z = z
    /// ```
    public var cartesianVector: CartesianVector {
        let x = rho * cos(phi)
        let y = rho * sin(phi)
        let z = height

        return CartesianVector(x: x, y: y, z: z)
    }

    /// The equivalent vector in spherical coordinates.
    ///
    /// Calculated as:
    /// ```
    /// r = √(ρ² + z²)
    /// θ = arccos(z / r)   — undefined for the zero vector; returns SphericalVector() instead
    /// ϕ = ϕ
    /// ```
    public var sphericalVector: SphericalVector {
        let radial = sqrt(rho * rho + height * height)
        guard radial > 0 else { return SphericalVector() }
        let theta = acos(height / radial).angle

        return SphericalVector(radial: radial, theta: theta, phi: phi)
    }

    // MARK: - Initialization

    /// Initializes a `CylindricalVector` with specified components.
    /// - Parameter rho: The radial distance.
    /// - Parameter phi: The azimuthal angle in radians.
    /// - Parameter height: The height (z value).
    public init(rho: Double = 0, phi: Angle = .zero, height: Double = 0) {
        self.rho = rho
        self.phi = phi
        self.height = height
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        return String(format: "Cylindrical(%.2f, %.2f˚, %.2f)",
                      Float(rho),
                      Float(phi.degrees),
                      Float(height))
    }
}
