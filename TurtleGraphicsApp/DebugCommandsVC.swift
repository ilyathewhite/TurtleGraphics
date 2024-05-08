//
//  DebugCommandsVC.swift
//  TurtleGraphicsApp
//
//  Created by Ilya Belenkiy on 5/8/24.
//

import SwiftUI
import TurtleGraphics

class DebugCommandsVC: PlaygroundCanvasVC {
    required init?(coder: NSCoder) {
        super.init { t in
            t.penUp()
            t.back(100)
            t.penDown()

            // Turtle Star!
            t.penColor(.red)
            t.fillColor(.yellow)
            t.beginFill()

            36.timesRepeat {
                t.forward(200)
                t.left(170)
            }
            t.endFill()
        }
    }
}

#Preview {
    PlaygroundCanvasVC { t in
        t.penDown()
        t.penColor(.red)
        5.timesRepeat {
            t.forward(200)
            t.left(145)
        }
    }
}
