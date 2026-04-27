import Testing
@testable import Geometry

struct DirectionTests {

    // MARK: - Static Presets

    @Test func testAllCasesCount() {
        #expect(Direction.allCases.count == 27)
    }

    @Test func testPresetHorizontal() {
        #expect(Direction.north.horizontal == .north)
        #expect(Direction.north.vertical == .none)
        #expect(Direction.east.horizontal == .east)
        #expect(Direction.south.horizontal == .south)
        #expect(Direction.west.horizontal == .west)
    }

    @Test func testPresetVertical() {
        #expect(Direction.up.vertical == .up)
        #expect(Direction.up.horizontal == .none)
        #expect(Direction.down.vertical == .down)
        #expect(Direction.down.horizontal == .none)
    }

    @Test func testPresetIntercardinal() {
        #expect(Direction.northEast.horizontal == .northEast)
        #expect(Direction.southWest.horizontal == .southWest)
    }

    @Test func testPresetCombined() {
        #expect(Direction.northUp.horizontal == .north)
        #expect(Direction.northUp.vertical == .up)
        #expect(Direction.southDown.horizontal == .south)
        #expect(Direction.southDown.vertical == .down)
    }

    @Test func testNoneDirection() {
        let d = Direction.none
        #expect(d.horizontal == .none)
        #expect(d.vertical == .none)
    }

    // MARK: - init(theta:phi:)

    @Test func testHorizontalNorthFromPhi() {
        // phi = 0 → North
        let d = Direction(theta: Angle(degrees: 90), phi: Angle(degrees: 0))
        #expect(d.horizontal == .north)
        #expect(d.vertical == .none)
    }

    @Test func testHorizontalEastFromPhi() {
        let d = Direction(theta: Angle(degrees: 90), phi: Angle(degrees: 90))
        #expect(d.horizontal == .east)
    }

    @Test func testHorizontalSouthFromPhi() {
        let d = Direction(theta: Angle(degrees: 90), phi: Angle(degrees: 180))
        #expect(d.horizontal == .south)
    }

    @Test func testHorizontalWestFromPhi() {
        let d = Direction(theta: Angle(degrees: 90), phi: Angle(degrees: 270))
        #expect(d.horizontal == .west)
    }

    @Test func testHorizontalNorthEastFromPhi() {
        let d = Direction(theta: Angle(degrees: 90), phi: Angle(degrees: 45))
        #expect(d.horizontal == .northEast)
    }

    @Test func testVerticalUpFromTheta() {
        // theta near 0 → up
        let d = Direction(theta: Angle(degrees: 10), phi: Angle(degrees: 0))
        #expect(d.vertical == .up)
    }

    @Test func testVerticalDownFromTheta() {
        // theta near 180 → down
        let d = Direction(theta: Angle(degrees: 170), phi: Angle(degrees: 0))
        #expect(d.vertical == .down)
    }

    @Test func testVerticalNoneFromTheta() {
        // theta = 90 (horizontal plane) → none vertical
        let d = Direction(theta: Angle(degrees: 90), phi: Angle(degrees: 0))
        #expect(d.vertical == .none)
    }

    // MARK: - Equality

    @Test func testEquality() {
        let a = Direction(horizontal: .north, vertical: .up)
        let b = Direction(horizontal: .north, vertical: .up)
        let c = Direction(horizontal: .south, vertical: .up)
        #expect(a == b)
        #expect(a != c)
    }

    // MARK: - Description

    @Test func testDescriptionNone() {
        #expect(Direction.none.description == "None")
    }

    @Test func testDescriptionNorth() {
        #expect(Direction.north.description.contains("North"))
    }

    @Test func testDescriptionNorthUp() {
        let desc = Direction.northUp.description
        #expect(desc.contains("North"))
        #expect(desc.contains("Up"))
    }
}
