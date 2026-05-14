//
//  Vector3D.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/10/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

prefix operator ~
infix operator ~
infix operator ^

/// An object that holds a geometrical vector in three dimensions, in different forms.
/// A vector is an object that has both a magnitude and a direction. Geometrically.
public struct Vector3D: CustomStringConvertible {
    
    // MARK: Cartesian Properties
    
    /// A `CartesianVector` object represents the vector in cartesian coordinate.
    private(set) var cartesianVector: CartesianVector
    
    /// `Double` value represents the projection on x-axis.
    public var x: Double {
        cartesianVector.x
    }
    
    /// `Double` value represents the projection on y-axis.
    public var y: Double {
        cartesianVector.y
    }
    
    /// `Double` value represents the projection on z-axis.
    public var z: Double {
        cartesianVector.z
    }
    
    // MARK: Spherical Properties
    
    /// A `SphericalVector` object represents the vector in spherical coordinate.
    private(set) var sphericalVector: SphericalVector
    
    /// `Double` value represents the magnitude of the vector.
    /// radial distance r _(𝜌 (rho) is often used instead)_
    ///
    /// __r ∈ [0, ∞) (r ≥ 0)__
    public var radial: Double {
        sphericalVector.radial
    }
    
    /// `Angle` value represents the inclination angle (or polar angle) between the z-axis and the vector, measured in radians.
    ///
    /// __𝜃 ∈ [0, +π] rad ([0° ≤ 𝜃 ≤ 180°])__
    public var theta: Angle {
        sphericalVector.theta
    }
    
    /// `Angle` value represents the azimuthal angle between the projection on the xy-plane and the x-axis, measured in radians.
    ///
    /// __𝛷 ∈ [-π, +π] rad ([-180° ≤ 𝛷 < 180°])__
    public var phi: Angle {
        sphericalVector.phi
    }
    
    // MARK: Cylindrical Properties
    
    /// A `CylindricalVector` object represents the vector in cylindrical coordinate.
    private(set) var cylindricalVector: CylindricalVector
    
    /// `Double` value represents the radial distance.
    /// ρ is the Euclidean distance in xy-plane for the vector.
    ///
    /// __𝜌 ∈ [0, ∞) (𝜌 ≥ 0)__
    public var rho: Double {
        cylindricalVector.rho
    }
    
    /// `Double` value represents the height z, which is the signed distance from the chosen plane to the vector.
    public var height: Double {
        cylindricalVector.height
    }
    
    // MARK: Vector Properties
    
    /// Returns Direction that represents the vector heading.
    public var headingDirection: Direction {
        Direction(theta: theta, phi: phi)
    }
    
    // MARK: Initialization
    
    /// `Vector3D` Default initializer.
    public init() {
        cartesianVector = CartesianVector()
        sphericalVector = cartesianVector.sphericalVector
        cylindricalVector = cartesianVector.cylindricalVector
    }
    
    /// Initialize `Vector3D` object in cartesian form.
    /// - Parameter x: `Double` value represents the projection on x-axis.
    /// - Parameter y: `Double` value represents the projection on y-axis.
    /// - Parameter z: `Double` value represents the projection on z-axis.
    public init(x: Double, y: Double, z: Double) {
        cartesianVector = CartesianVector(x: x, y: y, z: z)
        sphericalVector = cartesianVector.sphericalVector
        cylindricalVector = cartesianVector.cylindricalVector
    }
    
    /// Initialize `Vector3D` object in spherical form.
    /// - Parameter radial: `Double` value represents the magnitude of the vector.
    /// - Parameter theta: `Angle` value represents the polar angle between the z-axis and the vector.
    /// - Parameter phi: `Angle` value represents the azimuthal angle between the projection on the xy-plane and the x-axis.
    public init(radial: Double, theta: Angle, phi: Angle) {
        sphericalVector = SphericalVector(radial: radial, theta: theta, phi: phi)
        cartesianVector = sphericalVector.cartesianVector
        cylindricalVector = sphericalVector.cylindricalVector
    }
    
    /// Initialize `Vector3D` object in cylindrical form.
    /// - Parameter rho: `Double` value represents the magnitude of the vector.
    /// - Parameter phi: `Angle` value represents the azimuthal angle between the projection on the xy-plane and the x-axis.
    /// - Parameter height: `Double` value represents the height z, which is the signed distance from the chosen plane to the point P.
    public init(rho: Double, phi: Angle, height: Double) {
        cylindricalVector = CylindricalVector(rho: rho, phi: phi, height: height)
        cartesianVector = cylindricalVector.cartesianVector
        sphericalVector = cylindricalVector.sphericalVector
    }
    
    /// Initialize `Vector3D` object with a unit value.
    /// - Parameter value: Double value represents the vector x y z value.
    public init(value: Double) {
        cartesianVector = CartesianVector(x: value, y: value, z: value)
        sphericalVector = cartesianVector.sphericalVector
        cylindricalVector = cartesianVector.cylindricalVector
    }
    
    /// A multi-line description showing all three coordinate representations.
    public var description: String {
        "Vector3D\n[\n\t\(cartesianVector)\n\t\(sphericalVector)\n\t\(cylindricalVector)\n]"
    }
}
    
// MARK: Vectors Operators
    
extension Vector3D {

    /// A unary operator calculates the length of a vector (Norm).
    /// - Parameter vector: Vector3D object.
    /// - Returns: length of the vector.
    public static prefix func ~ (vector: Vector3D) -> Double {
        return sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
    }

    /// An operator that applies dot product for two vectors.
    /// - Parameter left: Vector3D object represents the left side.
    /// - Parameter right: Vector3D object represents the right side.
    /// - Returns: a `Vector3D` object represents the result.
    public static func ~ (left: Vector3D, right: Vector3D) -> Double {
        let x = left.x - right.x
        let y = left.y - right.y
        let z = left.z - right.z
        return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
    }

    /// An operator that applies cross product for two vectors.
    /// - Parameter left: Vector3D object represents the left side.
    /// - Parameter right: Rotation3D object represents the right side.
    /// - Returns: a `Vector3D` object represents the result.
    public static func ^ (left: Vector3D, right: Rotation3D) -> Vector3D {
        let rm: RotationMatrix = right.rotationMatrix
        return Vector3D(
            x: left.x * rm.m11 + left.y * rm.m12 + left.z * rm.m13,
            y: left.x * rm.m21 + left.y * rm.m22 + left.z * rm.m23,
            z: left.x * rm.m31 + left.y * rm.m32 + left.z * rm.m33
        )
    }
}

// MARK: Arithmetic operators

extension Vector3D {

    /// Negates all three Cartesian components.
    prefix static func - (vector: Vector3D) -> Vector3D {
        Vector3D(x: -vector.x, y: -vector.y, z: -vector.z)
    }

    /// Adds two vectors component-wise.
    /// - Returns: A vector whose components are the sums of the corresponding components.
    public static func + (left: Vector3D, right: Vector3D) -> Vector3D {
        Vector3D(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }

    /// Subtracts one vector from another component-wise.
    /// - Returns: A vector whose components are the differences of the corresponding components.
    public static func - (left: Vector3D, right: Vector3D) -> Vector3D {
        left + -right
    }

    /// Adds a vector to this vector in place.
    public static func += (left: inout Vector3D, right: Vector3D) {
        left = left + right
    }

    /// Subtracts a vector from this vector in place.
    public static func -= (left: inout Vector3D, right: Vector3D) {
        left = left - right
    }

    /// Multiplies two vectors component-wise (Hadamard product).
    /// - Returns: A vector whose components are the products of the corresponding components.
    public static func * (left: Vector3D, right: Vector3D) -> Vector3D {
        Vector3D(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
    }

    /// Divides one vector by another component-wise.
    /// - Returns: A vector whose components are the quotients of the corresponding components.
    public static func / (left: Vector3D, right: Vector3D) -> Vector3D {
        Vector3D(x: left.x / right.x, y: left.y / right.y, z: left.z / right.z)
    }
}

// MARK: Logical operators

extension Vector3D {

    /// Returns `true` if all three Cartesian components are equal.
    public static func == (left: Vector3D, right: Vector3D) -> Bool {
        (left.x == right.x) && (left.y == right.y) && (left.z == right.z)
    }

    /// Returns `true` if any Cartesian component differs.
    public static func != (left: Vector3D, right: Vector3D) -> Bool {
        !(left == right)
    }

    /// Returns `true` if `left` has a magnitude less than or equal to `right`.
    public static func <= (left: Vector3D, right: Vector3D) -> Bool {
        (~left <= ~right)
    }

    /// Returns `true` if `left` has a magnitude greater than or equal to `right`.
    public static func >= (left: Vector3D, right: Vector3D) -> Bool {
        (~left >= ~right)
    }

    /// Returns `true` if `left` has a strictly smaller magnitude than `right`.
    public static func < (left: Vector3D, right: Vector3D) -> Bool {
        (~left < ~right)
    }

    /// Returns `true` if `left` has a strictly greater magnitude than `right`.
    public static func > (left: Vector3D, right: Vector3D) -> Bool {
        (~left > ~right)
    }
}

#if canImport(CoreMotion)
import CoreMotion

public extension Vector3D {

    /// Initializes a `Vector3D` from a `CMAcceleration`, converting from g-units to m/s².
    init(acceleration: CMAcceleration) {
        self.init(
            x: acceleration.x * Physics.EarthGravity,
            y: acceleration.y * Physics.EarthGravity,
            z: acceleration.z * Physics.EarthGravity
        )
    }

    /// Initializes a `Vector3D` from a `CMRotationRate`.
    init(rotationRate: CMRotationRate) {
        self.init(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z)
    }

    /// Initializes a `Vector3D` from a `CMMagneticField`.
    init(field: CMMagneticField) {
        self.init(x: field.x, y: field.y, z: field.z)
    }

    /// Initializes a `Vector3D` from a `CMCalibratedMagneticField`.
    init(magneticField: CMCalibratedMagneticField) {
        self.init(field: magneticField.field)
    }
}
#endif

#if canImport(CoreLocation)
import CoreLocation

public extension Vector3D {

    /// Initializes a `Vector3D` from the raw field values of a `CLHeading`.
    init(heading: CLHeading) {
        self.init(x: heading.x, y: heading.y, z: heading.z)
    }
}
#endif
