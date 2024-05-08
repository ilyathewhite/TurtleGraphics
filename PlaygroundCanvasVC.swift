//
//  PlaygroundCanvasVC.swift
//  TurtleGraphics
//
//  Created by Ilya Belenkiy on 5/8/24.
//

#if os(iOS)
import UIKit

open class PlaygroundCanvasVC: UIViewController {
    let turtle = Turtle()
    var canvas: PlaygroundCanvas?
    
    let commands: (Turtle) -> Void
    
    public init(commands: @escaping (Turtle) -> Void) {
        self.commands = commands
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let canvas = PlaygroundCanvas(size: .init(size: UIScreen.main.bounds.size))
        self.canvas = canvas
        canvas.add(turtle)
        view = canvas
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commands(turtle)
    }
}

#endif
