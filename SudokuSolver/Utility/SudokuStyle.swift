//
//  SudokuStyle.swift
//  SudokuSolver
//
//  Created by rgrg on 2025-05-16.
//

import SwiftUI

struct SudokuStyle {
    // Couleurs
    static let givenNumberColor = Color.black
    static let userNumberColor = Color.blue
    static let errorColor = Color.red
    static let highlightColor = Color(red: 0.9, green: 0.9, blue: 1.0)
    static let sameValueHighlight = Color(red: 0.8, green: 0.9, blue: 1.0)
    static let gridLineColor = Color.black
    static let thickLineColor = Color.black
    static let thinLineColor = Color.gray
    static let notesColor = Color.gray
    
    // Tailles
    static let cellSize: CGFloat = 40
    static let thickLineWidth: CGFloat = 2
    static let thinLineWidth: CGFloat = 0.5
    static let numberFontSize: CGFloat = 24
    static let notesFontSize: CGFloat = 10
    
    // Animations
    static let standardAnimation = Animation.easeInOut(duration: 0.2)
    
    // Styles de boutons
    static var primaryButtonStyle: some ButtonStyle {
        return AnyButtonStyle(
            shape: .capsule,
            foregroundColor: .white,
            backgroundColor: .blue,
            pressedColor: .blue.opacity(0.8)
        )
    }
    
    static var secondaryButtonStyle: some ButtonStyle {
        return AnyButtonStyle(
            shape: .capsule,
            foregroundColor: .blue,
            backgroundColor: Color(UIColor.systemBackground),
            pressedColor: Color.blue.opacity(0.1)
        )
    }
}

// Styles de bouton personnalisables
enum ButtonShape {
    case capsule
    case rectangle
    case rounded(radius: CGFloat)
}

struct AnyButtonStyle: ButtonStyle {
    let shape: ButtonShape
    let foregroundColor: Color
    let backgroundColor: Color
    let pressedColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        let currentBackgroundColor = configuration.isPressed ? pressedColor : backgroundColor
        
        return configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundColor(foregroundColor)
            .background(
                Group {
                    switch shape {
                    case .capsule:
                        Capsule().fill(currentBackgroundColor)
                    case .rectangle:
                        Rectangle().fill(currentBackgroundColor)
                    case .rounded(let radius):
                        RoundedRectangle(cornerRadius: radius).fill(currentBackgroundColor)
                    }
                }
            )
    }
}
