import Foundation

/// Represents a spherical coordinate in a three-dimensional coordinate system.
///
/// Commonly used in physics (ISO convention), a `SphericalVector` is defined by its magnitude `r`,
/// inclination angle `θ`, and azimuthal angle `ϕ`.
///
/// If `v` is an instance of `SphericalVector`, it represents:
/// _v = (r, θ, ϕ)_
///
/// Where:
/// - r ∈ [0, ∞)
/// - θ ∈ [0, π]
/// - ϕ ∈ [−π, +π)
///
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Spherical_coordinate_system)
public struct SphericalVector: CustomStringConvertible {

    /// The magnitude of the vector (radial distance), r ≥ 0.
    public let radial: Double

    /// The inclination (polar) angle θ, measured from the positive z-axis. In radians.
    ///
    /// θ ∈ [0, π]
    public let theta: Angle

    /// The azimuthal angle ϕ, measured in the xy-plane from the x-axis. In radians.
    ///
    /// ϕ ∈ [−π, +π)
    public let phi: Angle

    /// The equivalent vector in Cartesian coordinates.
    ///
    /// Calculated as:
    /// ```
    /// x = r × sin(θ) × cos(ϕ)
    /// y = r × sin(θ) × sin(ϕ)
    /// z = r × cos(θ)
    /// ```
    public var cartesianVector: CartesianVector {
        let x = radial * sin(theta) * cos(phi)
        let y = radial * sin(theta) * sin(phi)
        let z = radial * cos(theta)

        return CartesianVector(x: x, y: y, z: z)
    }

    /// The equivalent vector in cylindrical coordinates.
    ///
    /// Calculated as:
    /// ```
    /// ρ = r × sin(θ)
    /// ϕ = ϕ
    /// z = r × cos(θ)
    /// ```
    public var cylindricalVector: CylindricalVector {
        let rho = radial * sin(theta)
        let z = radial * cos(theta)

        return CylindricalVector(rho: rho, phi: phi, height: z)
    }

    // MARK: - Initialization

    /// Initializes a `SphericalVector` with the specified components.
    /// - Parameter radial: The magnitude of the vector.
    /// - Parameter theta: The inclination (polar) angle in radians.
    /// - Parameter phi: The azimuthal angle in radians.
    public init(radial: Double = 0, theta: Angle = .zero, phi: Angle = .zero) {
        self.radial = radial
        self.theta = theta
        self.phi = phi
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        return String(format: "Spherical(%.2f, %.2f˚, %.2f˚)",
                      Float(radial),
                      Float(theta.degrees),
                      Float(phi.degrees))
    }
}
