import Foundation

/// A structure that contains physics-related constants.
public struct Physics {

    /// Earth's gravity in meters per second squared (m/s²).
    public static let EarthGravity: Double = 9.80665

    /// Earth's maximum magnetic field in microteslas (µT).
    public static let EarthMaxMagneticField: Double = 65.0

    /// Earth's minimum magnetic field in microteslas (µT).
    public static let EarthMinMagneticField: Double = 25.0
}

/// A typealias representing acceleration as a 3D vector.
///
/// Acceleration is defined as the rate of change of velocity.
/// Acceleration is inherently a vector quantity. An object will have non-zero acceleration
/// if its speed and/or direction is changing. The average acceleration is given by:
/// _v = ∂v / ∂t_
///
/// ![Equation](https://latex.codecogs.com/png.latex?%5Cdpi%7B150%7D%20v%20%3D%20%5Cfrac%7B%5Cpartial%20v%7D%7B%5Cpartial%20t%7D%20%3D%20%5Cfrac%7Bv_%7B2%7D%20-%20v_%7B1%7D%7D%7Bt_%7B2%7D%20-%20t_%7B1%7D%7D)
///
/// - Note: The measurement unit is meters per second squared (m/s²).
public typealias Acceleration = Vector3D

/// A typealias representing velocity as a 3D vector.
///
/// Velocity is the displacement over time and is a vector quantity.
/// For linear motion in the x-direction:
/// _v = ∂x / ∂t_
///
/// ![Equation](https://latex.codecogs.com/png.latex?%5Cdpi%7B150%7D%20v%20%3D%20%5Cfrac%7B%5Cpartial%20x%7D%7B%5Cpartial%20t%7D%20%3D%20%5Cfrac%7Bx_%7B2%7D%20-%20x_%7B1%7D%7D%7Bt_%7B2%7D%20-%20t_%7B1%7D%7D)
///
/// - Note: The measurement unit is meters per second (m/s).
public typealias Velocity = Vector3D

/// A typealias representing distance as a 3D vector.
///
/// Distance is a scalar quantity that refers to how much ground an object has covered during motion.
///
/// - Note: The measurement unit is meters (m).
public typealias Distance = Vector3D
