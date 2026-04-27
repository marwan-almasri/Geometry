import math_h

/// A type represent data (x, y) for numerical integration and the true integral (i)
struct MockDataSet {
    let set: [Double]
    let dx: Double
    let i: Double
}

extension MockDataSet {
    /// Generating a test data set with trigonometric function.
    ///
    /// The data is generated using the function
    /// __ƒ(x) = cos(x)__
    ///
    /// where __x ∈ [-π, +π]__ and __y ∈ [-1, +1]__
    /// and the integral of __ƒ(x)__ is:
    ///
    /// __∫ cos(x) dx = sin(x) + c__
    /// where __dx = 1/10__
    static var trigonometric: MockDataSet {
        let d = 10.0
        let start = Int(-Double.pi * d) // -π
        let end = Int(Double.pi * d)    // +π
        let x0 = Double(start) / d
        let xn = Double(end) / d
        let i = sin(xn) - sin(x0) // F(xn) - F(x0)
        var data: [Double] = []
        for v in start...end {
            let x = Double(v) / d
            let y = cos(x)
            data.append(y)
        }
        return .init(set: data, dx: 1 / d, i: i)
    }
    
    /// Generating a test data set with polynomial function.
    ///
    /// The data is generated using the function
    /// __ƒ(x) = 2x__
    ///
    /// where __x ∈ [-10, +10]__ and __y ∈ [-∞, +∞]__
    /// and the integral of __ƒ(x)__ is:
    /// __∫ 2x dx = x² + c__
    ///
    /// where __dx = 1/10__
    static var polynomial: MockDataSet {
        let d = 10.0
        let start = Int(-10.0 * d) // -10
        let end = Int(10.0 * d)    // +10
        let x0 = Double(start) / d
        let xn = Double(end) / d
        let i = pow(xn, 2) - pow(x0, 2) // F(xn) - F(x0)
        var data: [Double] = []
        for v in start...end {
            let x = Double(v) / d
            let y = 2 * x
            data.append(y)
        }
        return .init(set: data, dx: 1 / d, i: i)
    }
    
    /// Generating a test data set with exponential function.
    ///
    /// The data is generated using the function
    /// __ƒ(x) = eˣ__
    ///
    /// where __x ∈ [-10, +10]__ and __y ∈ [-∞, +∞]__
    /// and the integral of __ƒ(x)__ is:
    /// __∫ eˣ dx = eˣ + c__
    ///
    /// where __dx = 1/10__
    static var exponential: MockDataSet {
        let d = 10.0
        let start = Int(-10.0 * d) // -10
        let end = Int(10.0 * d)    // +10
        let x0 = Double(start) / d
        let xn = Double(end) / d
        let i = exp(xn) - exp(x0) // F(xn) - F(x0)
        var data: [Double] = []
        for v in start...end {
            let x = Double(v) / d
            let y = exp(x)
            data.append(y)
        }
        
        return .init(set: data, dx: 1 / d, i: i)
    }
    
    /// Generating a test data set with logarithmic function.
    ///
    /// The data is generated using the function
    /// __ƒ(x) = ln(x)__
    ///
    /// where __x ∈ [1.0, +10]__ and __y ∈ [-∞, +∞]__
    /// and the integral of __ƒ(x)__ is:
    /// __∫ ln(x) dx = x ln(x) - x + c__
    ///
    /// where __dx = 1/10__
    static var logarithmic: MockDataSet {
        let d = 10.0
        let start = Int(1.0 * d) // 0
        let end = Int(10.0 * d)  // 10
        let x0 = Double(start) / d
        let xn = Double(end) / d
        let i = (xn * log(xn) - xn) - (x0 * log(x0) - x0) // F(xn) - F(x0)
        var data: [Double] = []
        for v in start...end {
            let x = Double(v) / d
            let y = log(x)
            data.append(y)
        }
        return .init(set: data, dx: 1 / d, i: i)
    }
}
