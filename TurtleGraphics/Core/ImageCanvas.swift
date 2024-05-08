import Foundation
import CoreGraphics

public class ImageCanvas: Canvas, TurtleDelegate {

    public init(size: Vec2D, scale: Double = 1, color: Color? = nil) {
        self.canvasSize = size
        self.canvasColor = color ?? .white
        self.bitmapScale = CGFloat(scale)
        self.bitmapContext = createForegroundContext(size: size.toCGSize(),
                                                     scale: self.bitmapScale)
    }

    public var cgImage: CGImage? {
        let size = canvasSize.toCGSize()
        let bgContext = createBackgroundContext(size: size, scale: bitmapScale)
        bgContext?.setFillColor(canvasColor.cgColor)
        bgContext?.fill(CGRect(origin: .zero, size: size))
        if let fgImage = bitmapContext?.makeImage() {
            bgContext?.draw(fgImage, in: CGRect(origin: .zero, size: size))
        }
        return bgContext?.makeImage()
    }

    // MARK: - Canvas

    public func add(_ turtle: Turtle) {
        guard turtle.delegate !== self else { return }
        turtle.delegate?.turtleDidAddToOtherCanvas(turtle.uuid, turtle.state)
        turtle.delegate = self
        turtleDidInitialized(turtle.uuid, turtle.state)
    }

    public var canvasSize: Vec2D

    public func canvasColor(_ r: Double, _ g: Double, _ b: Double) {
        canvasColor = Color(r, g, b)
    }

    public func canvasColor(_ hex: String) {
        canvasColor = Color(hex)
    }

    public func canvasColor(_ color: Color) {
        canvasColor = color
    }

    public private(set) var canvasColor: Color

    // MARK: - TurtleDelegate

    func turtleDidInitialized(_ uuid: UUID, _ state: TurtleState) {
        turtlePositions[uuid] = state.position
    }

    func turtleDidChangePosition(_ uuid: UUID, _ state: TurtleState) {
        let position = turtlePositions[uuid] ?? .zero
        turtlePositions[uuid] = state.position
        guard state.pen.isDown else { return }
        bitmapContext?.saveGState()
        bitmapContext?.setStrokeColor(state.pen.color.cgColor)
        bitmapContext?.setFillColor(CGColor.clear)
        bitmapContext?.setLineWidth(CGFloat(state.pen.width))
        bitmapContext?.addPath([position, state.position].toCGPath())
        bitmapContext?.strokePath()
        bitmapContext?.restoreGState()
    }

    func turtleDidChangeHeading(_ uuid: UUID, _ state: TurtleState) {
        // Nothing to do
    }

    func turtleDidChangePen(_ uuid: UUID, _ state: TurtleState) {
        // Nothing to do
    }

    func turtleDidChangeShape(_ uuid: UUID, _ state: TurtleState) {
        // Nothing to do
    }

    func turtleDidRequestToFill(_ uuid: UUID, _ state: TurtleState) {
        guard let fillPath = state.fillPath else { return }
        bitmapContext?.saveGState()
        bitmapContext?.setStrokeColor(CGColor.clear)
        bitmapContext?.setFillColor(state.pen.fillColor.cgColor)
        bitmapContext?.addPath(fillPath.toCGPath())
        bitmapContext?.fillPath(using: .evenOdd)
        bitmapContext?.restoreGState()
    }

    func turtleDidRequestToClear(_ uuid: UUID, _ state: TurtleState) {
        bitmapContext = createForegroundContext(size: canvasSize.toCGSize(),
                                                scale: bitmapScale)
    }

    func turtleDidAddToOtherCanvas(_ uuid: UUID, _ state: TurtleState) {
        turtlePositions[uuid] = nil
    }

    // MARK: - Internal

    func drawImage(_ image: CGImage, in rect: CGRect) {
        bitmapContext?.draw(image, in: rect)
    }

    // MARK: - Private

    private var bitmapContext: CGContext?

    private let bitmapScale: CGFloat

    private var turtlePositions: [UUID: Vec2D] = [:]

}

private func createBackgroundContext(size: CGSize, scale: CGFloat) -> CGContext? {
    let width = Int(size.width * scale)
    let height = Int(size.height * scale)
    guard width > 0, height > 0 else { return nil }

    let context = CGContext(data: nil,
                            width: width,
                            height: height,
                            bitsPerComponent: 8,
                            bytesPerRow: width * 4,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)!
    // swiftlint:disable:previous force_unwrapping
    context.scaleBy(x: scale, y: scale)
    return context
}

private func createForegroundContext(size: CGSize, scale: CGFloat) -> CGContext? {
    let context = createBackgroundContext(size: size, scale: scale)
    context?.translateBy(x: size.width * 0.5, y: size.height * 0.5)
    return context
}
