# Geometry Package — Claude Code Guide

## Quick commands

```bash
swift build                              # build the package
swift test                               # run all tests (131 tests, ~0.005s)
swiftlint lint --config .swiftlint.yml   # lint Sources/ (requires swiftlint)
jazzy                                    # generate API docs → docs/ (requires jazzy gem)
```

All commands run from `Packages/Geometry/` (this directory).

## Source layout

```
Sources/Geometry/
├── Math/
│   ├── Angle.swift                — Angle value type; trig free functions (sin/cos/asin/acos/atan/atan2)
│   ├── Accuracy.swift             — Accuracy enum: none/low/medium/high + CoreMotion extensions
│   ├── Direction.swift            — 27-preset 3D directional enum (horizontal × vertical)
│   ├── MathUtils.swift            — clamp, rotate, truncate, lerp, inverseLerp, map, sign, normalize, wrap
│   │                                Also defines the `infinity` constant (Double.infinity)
│   ├── NumericalIntegration.swift — rectangularLeft/Right, trapezoidal, simpsons
│   └── Physics.swift              — EarthGravity (9.80665), magnetic field bounds
├── Motion/
│   ├── Heading.swift              — magnetic + true heading angles + optional CLHeading init
│   ├── MagneticField.swift        — Vector3D field + Accuracy
│   ├── Motion.swift               — direction + distance + weight; Equatable
│   ├── MotionActivity.swift       — status + confidence composite
│   └── MotionActivityStatus.swift — walking/running/automotive/stationary/cycling/unknown
├── Rotation/
│   ├── EulerAngles.swift          — rotationMatrix (Rx·Ry·Rz convention) + quaternion conversions
│   ├── Quaternion.swift           — rotationMatrix + eulerAngles conversions
│   ├── Rotation3D.swift           — roll/pitch/yaw arithmetic wrapper
│   └── RotationMatrix.swift       — eulerAngles (gimbal-lock safe) + quaternion conversions
└── Vector/
    ├── CartesianVector.swift      — x/y/z → SphericalVector / CylindricalVector
    ├── CylindricalVector.swift    — ρ/ϕ/z → CartesianVector / SphericalVector
    ├── SphericalVector.swift      — r/θ/ϕ → CartesianVector / CylindricalVector
    └── Vector3D.swift             — unified 3D vector exposing all three coordinate forms
```

## Key invariants

**Coordinate conversions**
- All `acos(z/r)` calls are guarded by `guard radial > 0 else { return SphericalVector() }` — the zero vector never produces NaN.
- `atan2` is safe for the zero vector (returns 0 by IEEE 754 convention).

**Rotation round-trips**
- `EulerAngles.rotationMatrix` uses the convention `R = Rx(roll) · Ry(pitch) · Rz(yaw)`.
- `RotationMatrix.eulerAngles` inverts that convention exactly, including gimbal-lock handling:
  - `cosRoll < 1e-6` triggers the lock path.
  - Sign of `m13` (= −sin(roll)) distinguishes roll ≈ +π/2 (m13 < 0) from roll ≈ −π/2.
  - Convention: `yaw = 0`, pitch absorbs the coupled value.
- `Quaternion.rotationMatrix` uses the standard Cayley–Klein formula; `sqrt(max(0, trace))` prevents NaN at θ = 0.
- All three round-trips (`Euler↔Matrix`, `Euler↔Quaternion`, `Matrix↔Quaternion`) are verified by `RotationTests.swift`.

**Numerical integration**
- `simpsons` requires an **even** number of sub-intervals. If `(set.count - 1) % 2 != 0`, it falls back to `trapezoidal` (no silent wrong result).

**Platform guards**
- Use `#if canImport(CoreMotion)` — not `#if os(iOS)` — so macOS also gets CoreMotion extensions.
- Use `#if canImport(CoreLocation)` for CLHeading.
- `CMMotionActivity` / `CMMotionActivityConfidence` require `@available(iOS 7.0, macOS 15.0, watchOS 2.0, tvOS 9.0, *)`.
- `activity.cycling` is `API_UNAVAILABLE(macos)` — guard it with `#if os(iOS)` inside the CoreMotion block.

## Testing

Framework: **Swift Testing** (`import Testing`, `@Test`, `#expect`).
Never use `XCTestCase` in this package.

Tests live in `Tests/GeometryTests/`. Mock data for numerical integration is in `Tests/GeometryTests/Mocks/MockDataSet.swift`.

Run a single suite:
```bash
swift test --filter RotationMatrixTests
```

## Documentation

Config: `.jazzy.yaml` at the package root.
Output: `docs/` (deployed to GitHub Pages via `.github/workflows/docs.yml`).
Update `module_version` in `.jazzy.yaml` before each release.

## Linting

Config: `.swiftlint.yml` at the package root.
Only `Sources/` is linted — `Tests/` is excluded.
SwiftLint is NOT a Package.swift dependency (keeps the package clean for consumers); it runs in CI only.
