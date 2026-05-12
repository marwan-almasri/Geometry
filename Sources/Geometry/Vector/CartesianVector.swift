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
    ///
    /// ![Equation](https://latex.codecogs.com/png.latex?%5Cbegin%7Baligned%7Dr%26%3D%5Csqrt%7Bx%5E2%2By%5E2%2Bz%5E2%7D%5C%5C%5Ctheta%26%3D%5Carccos%28z%2Fr%29%5C%5C%5Cphi%26%3D%5Coperatorname%7Batan2%7D%28y%2Cx%29%5Cend%7Baligned%7D)
    ///
    /// - Attention: Undefined for the zero vector; returns `SphericalVector()` instead.
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
    ///
    /// ![Equation](https://latex.codecogs.com/png.latex?%5Cbegin%7Baligned%7D%5Crho%26%3D%5Csqrt%7Bx%5E2%2By%5E2%7D%5C%5C%5Cphi%26%3D%5Coperatorname%7Batan2%7D%28y%2Cx%29%5C%5Cz%26%3Dz%5Cend%7Baligned%7D)
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
