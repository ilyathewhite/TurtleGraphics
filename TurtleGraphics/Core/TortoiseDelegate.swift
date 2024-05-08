import Foundation

protocol TurtleDelegate: AnyObject {

    func turtleDidInitialized(_ uuid: UUID, _ state: TurtleState)

    func turtleDidChangePosition(_ uuid: UUID, _ state: TurtleState)

    func turtleDidChangeHeading(_ uuid: UUID, _ state: TurtleState)

    func turtleDidChangePen(_ uuid: UUID, _ state: TurtleState)

    func turtleDidChangeShape(_ uuid: UUID, _ state: TurtleState)

    func turtleDidRequestToFill(_ uuid: UUID, _ state: TurtleState)

    func turtleDidRequestToClear(_ uuid: UUID, _ state: TurtleState)

    func turtleDidAddToOtherCanvas(_ uuid: UUID, _ state: TurtleState)

}
