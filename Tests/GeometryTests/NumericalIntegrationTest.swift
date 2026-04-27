import Testing
@testable import Geometry

struct NumericalIntegrationTest {

    @Test
    func testRectangularLeft() async throws {
        let data = MockDataSet.trigonometric
        let result = NumericalIntegration.rectangularLeft(set: data.set, dx: data.dx)
        #expect(result.toBeClose(to: data.i))
    }

    @Test
    func testRectangularRight() async throws {
        let data = MockDataSet.trigonometric
        let result = NumericalIntegration.rectangularRight(set: data.set, dx: data.dx)
        #expect(result.toBeClose(to: data.i))
    }

    @Test
    func testTrapezoidalWithTrigonometricData() async throws {
        let data = MockDataSet.trigonometric
        let result = NumericalIntegration.trapezoidal(set: data.set, dx: data.dx)
        #expect(result.toBeClose(to: data.i))
    }

    @Test
    func testTrapezoidalWithPolynomialData() async throws {
        let data = MockDataSet.polynomial
        let result = NumericalIntegration.trapezoidal(set: data.set, dx: data.dx)
        #expect(result.toBeClose(to: data.i))
    }

    @Test
    func testSimpsonsWithTrigonometricData() async throws {
        let data = MockDataSet.trigonometric
        let result = NumericalIntegration.simpsons(set: data.set, dx: data.dx)
        #expect(result.toBeClose(to: data.i))
    }

    @Test
    func testSimpsonsWithPolynomialData() async throws {
        let data = MockDataSet.polynomial
        let result = NumericalIntegration.simpsons(set: data.set, dx: data.dx)
        #expect(result.toBeClose(to: data.i))
    }

    @Test
    func testSimpsonsWithExponentialData() async throws {
        let data = MockDataSet.exponential
        let result = NumericalIntegration.simpsons(set: data.set, dx: data.dx)
        #expect(result.toBeClose(to: data.i, accuracy: 0.02))
    }

    @Test
    func testSimpsonsWithLogarithmicData() async throws {
        let data = MockDataSet.logarithmic
        let result = NumericalIntegration.simpsons(set: data.set, dx: data.dx)
        #expect(result.toBeClose(to: data.i))
    }

    @Test
    func testSimpsonsOddIntervalCountFallsBackToTrapezoidal() async throws {
        // f(x) = x on [0, 3] with dx=1 → 4 data points = 3 sub-intervals (odd).
        // Simpson's requires an even count; the method must fall back to trapezoidal.
        // Exact integral = x²/2 |₀³ = 4.5. Trapezoidal is exact for linear functions.
        let data = [0.0, 1.0, 2.0, 3.0]
        let result = NumericalIntegration.simpsons(set: data, dx: 1.0)
        let trapResult = NumericalIntegration.trapezoidal(set: data, dx: 1.0)
        #expect(result.toBeClose(to: 4.5))
        #expect(result == trapResult)
    }
}


extension Double {
    func toBeClose(to expected: Double, accuracy: Double = 0.01) -> Bool {
        return abs(self - expected) < accuracy
    }
}
