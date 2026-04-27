import Testing
@testable import Geometry

struct AccuracyTests {

    @Test func testCasesExist() {
        let cases: [Accuracy] = [.none, .low, .medium, .high]
        #expect(cases.count == 4)
    }

    @Test func testRawValues() {
        #expect(Accuracy.none.rawValue == 0)
        #expect(Accuracy.low.rawValue == 1)
        #expect(Accuracy.medium.rawValue == 2)
        #expect(Accuracy.high.rawValue == 3)
    }

    @Test func testDescriptions() {
        #expect(Accuracy.none.description == "Unknown")
        #expect(Accuracy.low.description == "Low")
        #expect(Accuracy.medium.description == "Medium")
        #expect(Accuracy.high.description == "High")
    }
}

struct MotionActivityStatusTests {

    @Test func testAllCases() {
        let statuses: [MotionActivityStatus] = [
            .walking, .running, .automotive, .stationary, .cycling, .unknown
        ]
        #expect(statuses.count == 6)
    }

    @Test func testDescriptions() {
        #expect(MotionActivityStatus.walking.description == "Walking")
        #expect(MotionActivityStatus.running.description == "Running")
        #expect(MotionActivityStatus.automotive.description == "Automotive")
        #expect(MotionActivityStatus.stationary.description == "Stationary")
        #expect(MotionActivityStatus.cycling.description == "Cycling")
        #expect(MotionActivityStatus.unknown.description == "Unknown")
    }
}

struct MotionActivityTests {

    @Test func testDefaultInit() {
        let activity = MotionActivity()
        #expect(activity.status == .unknown)
        #expect(activity.confidence == .none)
    }

    @Test func testCustomInit() {
        let activity = MotionActivity(status: .walking, confidence: .high)
        #expect(activity.status == .walking)
        #expect(activity.confidence == .high)
    }

    @Test func testDescription() {
        let activity = MotionActivity(status: .running, confidence: .medium)
        #expect(activity.description.contains("Running"))
        #expect(activity.description.contains("Medium"))
    }
}

struct MagneticFieldTests {

    @Test func testInit() {
        let field = Vector3D(x: 10, y: 20, z: 30)
        let mf = MagneticField(field: field, accuracy: .high)
        #expect(mf.field == field)
        #expect(mf.accuracy == .high)
    }

    @Test func testDescription() {
        let mf = MagneticField(field: Vector3D(), accuracy: .low)
        #expect(mf.description.contains("Low"))
    }
}

struct MotionTests {

    @Test func testInit() {
        let m = Motion(direction: .north, distance: 5.0, weight: 3)
        #expect(m.direction == .north)
        #expect(m.distance == 5.0)
        #expect(m.weight == 3)
    }

    @Test func testEquality() {
        let a = Motion(direction: .north, distance: 5.0, weight: 3)
        let b = Motion(direction: .north, distance: 5.0, weight: 3)
        let c = Motion(direction: .south, distance: 5.0, weight: 3)
        #expect(a == b)
        #expect(a != c)
    }
}

struct HeadingTests {

    @Test func testDefaultInit() {
        let h = Heading()
        #expect(h.magnetic == .zero)
        #expect(h.true == .zero)
        #expect(h.accuracy == .zero)
    }

    @Test func testCustomInit() {
        let h = Heading(
            magnetic: Angle(degrees: 90),
            true: Angle(degrees: 88),
            accuracy: Angle(degrees: 2),
            field: Vector3D(x: 1, y: 0, z: 0)
        )
        #expect(abs(h.magnetic.degrees - 90) < 1e-10)
        #expect(abs(h.true.degrees - 88) < 1e-10)
    }

    @Test func testDescription() {
        let h = Heading()
        #expect(h.description.contains("Heading"))
    }
}
