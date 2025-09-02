//
//  SudokuCellView.swift
//  SudokuSolver
//
//  Created by rgrg on 2025-05-16.
//

import SwiftUI

struct SudokuCellView: View {
    let cell: SudokuCell
    let row: Int
    let col: Int
    let isSelected: Bool
    let isHighlighted: Bool
    let isRelated: Bool
    let isSameValue: Bool
    let hasError: Bool
    
    var body: some View {
        ZStack {
            // Fond de la cellule
            Rectangle()
                .fill(backgroundColor)
                .border(borderColor, width: borderWidth)
            
            if let value = cell.value {
                // Afficher la valeur principale
                Text("\(value)")
                    .font(.system(size: SudokuStyle.numberFontSize, weight: cell.isGiven ? .bold : .regular))
                    .foregroundColor(textColor)
            } else if !cell.notes.isEmpty {
                // Afficher les notes
                NotesGridView(notes: cell.notes)
            }
        }
        .frame(width: SudokuStyle.cellSize, height: SudokuStyle.cellSize)
    }
    
    // Couleur de fond basée sur l'état de la cellule
    private var backgroundColor: Color {
        if isSelected {
            return SudokuStyle.highlightColor
        } else if isRelated {
            return SudokuStyle.highlightColor.opacity(0.3)
        } else if isSameValue {
            return SudokuStyle.sameValueHighlight
        } else {
            return Color.white
        }
    }
    
    // Couleur du texte basée sur l'état de la cellule
    private var textColor: Color {
        if hasError {
            return SudokuStyle.errorColor
        } else if cell.isGiven {
            return SudokuStyle.givenNumberColor
        } else {
            return SudokuStyle.userNumberColor
        }
    }
    
    // Couleur de bordure basée sur l'état de la cellule
    private var borderColor: Color {
        if isSelected {
            return .blue
        } else {
            return Color.black.opacity(0.5)
        }
    }
    
    // Épaisseur de bordure basée sur l'état de la cellule
    private var borderWidth: CGFloat {
        if isSelected {
            return 2
        } else {
            return 0.5
        }
    }
}

// Vue pour afficher les notes dans une grille 3x3
struct NotesGridView: View {
    let notes: [Int]
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<3) { row in
                GridRow {
                    ForEach(1...3, id: \.self) { col in
                        let number = row * 3 + col
                        if notes.contains(number) {
                            Text("\(number)")
                                .font(.system(size: SudokuStyle.notesFontSize))
                                .foregroundColor(SudokuStyle.notesColor)
                                .frame(width: SudokuStyle.cellSize / 3, height: SudokuStyle.cellSize / 3)
                        } else {
                            Color.clear
                                .frame(width: SudokuStyle.cellSize / 3, height: SudokuStyle.cellSize / 3)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    // Prévisualisation avec différents états de cellule
    HStack(spacing: 10) {
        SudokuCellView(
            cell: SudokuCell(value: 5, isGiven: true),
            row: 0, col: 0,
            isSelected: false,
            isHighlighted: false,
            isRelated: false,
            isSameValue: false,
            hasError: false
        )
        
        SudokuCellView(
            cell: SudokuCell(value: 7, isGiven: false),
            row: 0, col: 1,
            isSelected: true,
            isHighlighted: true,
            isRelated: false,
            isSameValue: false,
            hasError: false
        )
        
        SudokuCellView(
            cell: SudokuCell(value: 9, isGiven: false),
            row: 0, col: 2,
            isSelected: false,
            isHighlighted: false,
            isRelated: true,
            isSameValue: false,
            hasError: true
        )
        
        SudokuCellView(
            cell: SudokuCell(value: nil, isGiven: false, notes: [1, 3, 5, 8]),
            row: 0, col: 3,
            isSelected: false,
            isHighlighted: false,
            isRelated: false,
            isSameValue: false,
            hasError: false
        )
    }
    .padding()
}
