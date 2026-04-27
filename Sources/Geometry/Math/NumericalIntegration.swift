//
//  NumericalIntegration.swift
//  LOC8
//
//  Created by Marwan Al Masri on 6/1/18.
//  Updated for Geometry package migration.
//

import Foundation

/// Numerical integration provides methods to approximate the definite integral of a function.
///
/// It's useful when:
/// 1. The formula for the function is unknown, but a table of values or graph is available.
/// 2. An antiderivative of the integrand is unknown.
///
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Numerical_integration)
public class NumericalIntegration {

    /// Calculates the integral of a dataset using the **left Riemann sum** method.
    ///
    /// Approximates the integral by summing rectangles defined at the left-end points.
    ///
    /// ![Equation](https://latex.codecogs.com/png.latex?%5Cint_a%5Eb%20f%28x%29%20%5C%2C%20dx%20%5Capprox%20%5Csum_%7Bi%3D1%7D%5E%7Bn%7D%20%5C%20%5CDelta%20x%20f%28x_i%29)
    ///
    /// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Riemann_sum)
    /// - Parameter set: The data set to integrate.
    /// - Parameter dx: The sampling difference.
    /// - Returns: The integral over the sampling difference.
    public static func rectangularLeft(set: [Double], dx: Double) -> Double {
        guard set.count > 1 else { return 0 }

        var accumulator: Double = 0.0
        for i in 0..<(set.count - 1) {
            accumulator += set[i] * dx
        }

        return accumulator
    }

    /// Calculates the integral of a dataset using the **right Riemann sum** method.
    ///
    /// Approximates the integral by summing rectangles defined at the right-end points.
    ///
    /// ![Equation](https://latex.codecogs.com/png.latex?%5Cint_a%5Eb%20f%28x%29%20%5C%2C%20dx%20%5Capprox%20%5Csum_%7Bi%3D0%7D%5E%7Bn-1%7D%20%5C%20%5CDelta%20x%20f%28x_i%29)
    ///
    /// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Riemann_sum)
    /// - Parameter set: The data set to integrate.
    /// - Parameter dx: The sampling difference.
    /// - Returns: The integral over the sampling difference.
    public static func rectangularRight(set: [Double], dx: Double) -> Double {
        guard set.count > 1 else { return 0 }

        var accumulator: Double = 0.0
        for i in 1..<set.count {
            accumulator += set[i] * dx
        }

        return accumulator
    }

    /// Calculates the integral of a dataset using the **trapezoidal rule**.
    ///
    /// Approximates the area under the curve by summing trapezoids.
    ///
    /// ![Equation](https://latex.codecogs.com/png.latex?%5Cint_a%5Eb%20f%28x%29%20%5C%2C%20dx%20%5Capprox%20%5Csum_%7Bi%3D1%7D%5En%20%5Cfrac%7Bf%28x_%7Bi-1%7D%29&plus;f%28x_i%29%7D%7B2%7D%5C%20%5CDelta%20x_i)
    ///
    /// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Trapezoidal_rule)
    /// - Parameter set: The data set to integrate.
    /// - Parameter dx: The sampling difference.
    /// - Returns: The integral over the sampling difference.
    public static func trapezoidal(set: [Double], dx: Double) -> Double {
        guard set.count > 1 else { return 0 }

        var accumulator: Double = 0.0
        for i in 0..<(set.count - 1) {
            accumulator += ((set[i] + set[i + 1]) / 2) * dx
        }

        return accumulator
    }

    /// Calculates the integral of a dataset using **Simpson’s composite rule**.
    ///
    /// Approximates the integral using a piecewise quadratic interpolation.
    ///
    /// ![Equation](https://latex.codecogs.com/png.latex?%5Cint_a%5Eb%20f%28x%29%20%5C%2C%20dx%5Capprox%5Ctfrac%7Bh%7D%7B3%7D%20%5Cbigg%5Bf%28x_0%29&plus;2%5Csum_%7Bi%3D1%7D%5E%7Bn/2-1%7Df%28x_%7B2i%7D%29%20&plus;%204%5Csum_%7Bi%3D1%7D%5E%7Bn/2%7Df%28x_%7B2i-1%7D%29&plus;f%28x_n%29%5Cbigg%5D)
    ///
    /// ![Graph](https://upload.wikimedia.org/wikipedia/commons/6/67/Simpsonsrule2.gif)
    ///
    /// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Simpson%27s_rule)
    /// - Parameter set: The data set to integrate. Must contain an **odd** number of points
    ///   (i.e. an even number of sub-intervals). If the count is even, the method falls back
    ///   to the trapezoidal rule rather than silently producing an incorrect result.
    /// - Parameter dx: The sampling difference.
    /// - Returns: The integral over the sampling difference.
    public static func simpsons(set: [Double], dx: Double) -> Double {
        guard set.count > 1 else { return 0 }

        let n = set.count - 1
        // Simpson’s composite rule requires an even number of sub-intervals (odd point count).
        // Fall back to the trapezoidal rule rather than silently apply the wrong formula.
        guard n % 2 == 0 else { return trapezoidal(set: set, dx: dx) }
        let x0 = set[0]
        let xn = set[n]

        var sum4x: Double = 0.0
        var sum2x: Double = 0.0

        for i in 1..<n {
            let x = set[i]
            if i % 2 == 0 {
                sum2x += 2 * x  // even index
            } else {
                sum4x += 4 * x  // odd index
            }
        }

        return dx / 3 * (x0 + sum4x + sum2x + xn)
    }
}
