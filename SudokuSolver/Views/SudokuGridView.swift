//
//  SudokuGridView.swift
//  SudokuSolver
//
//  Created by rgrg on 2025-05-16.
//

import SwiftUI

struct SudokuGridView: View {
    @ObservedObject var viewModel: SudokuViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Grille de Sudoku
            sudokuGrid
                .border(SudokuStyle.gridLineColor, width: SudokuStyle.thickLineWidth)
                .padding()
            
            // Pavé numérique
            VStack {
                HStack {
                    ForEach(1...5, id: \.self) { num in
                        numberButton(for: num)
                    }
                }
                
                HStack {
                    ForEach(6...9, id: \.self) { num in
                        numberButton(for: num)
                    }
                    
                    // Bouton d'effacement
                    Button(action: {
                        viewModel.clearSelectedCell()
                    }) {
                        Image(systemName: "delete.left")
                            .font(.system(size: 22))
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(SudokuStyle.secondaryButtonStyle)
                }
                
                HStack {
                    // Bouton de basculement du mode notes
                    Button(action: {
                        viewModel.toggleNoteMode()
                    }) {
                        HStack {
                            Image(systemName: viewModel.isInNoteMode ? "pencil.circle.fill" : "pencil.circle")
                            Text(viewModel.isInNoteMode ? "Notes" : "Notes")
                        }
                    }
                    .buttonStyle(AnyButtonStyle(
                        shape: .capsule,
                        foregroundColor: viewModel.isInNoteMode ? .white : .blue,
                        backgroundColor: viewModel.isInNoteMode ? .blue : Color(UIColor.systemBackground),
                        pressedColor: viewModel.isInNoteMode ? .blue.opacity(0.8) : Color.blue.opacity(0.1)
                    ))
                    
                    // Bouton d'annulation
                    Button(action: {
                        viewModel.undo()
                    }) {
                        Image(systemName: "arrow.uturn.backward")
                    }
                    .buttonStyle(SudokuStyle.secondaryButtonStyle)
                    .disabled(!viewModel.canUndo())
                    
                    // Bouton de rétablissement
                    Button(action: {
                        viewModel.redo()
                    }) {
                        Image(systemName: "arrow.uturn.forward")
                    }
                    .buttonStyle(SudokuStyle.secondaryButtonStyle)
                    .disabled(!viewModel.canRedo())
                }
            }
            .padding()
            
            // Boutons d'action
            HStack {
                // Bouton de réinitialisation
                Button(action: {
                    viewModel.resetGrid()
                }) {
                    Text("Réinitialiser")
                }
                .buttonStyle(SudokuStyle.secondaryButtonStyle)
                
                Spacer()
                
                // Bouton de résolution
                Button(action: {
                    viewModel.solve()
                }) {
                    Text("Résoudre")
                }
                .buttonStyle(SudokuStyle.primaryButtonStyle)
            }
            .padding()
        }
        .alert("Félicitations !", isPresented: .constant(viewModel.gameCompleted)) {
            Button("Continuer", role: .cancel) { }
        } message: {
            Text("Vous avez complété la grille de Sudoku avec succès !")
        }
    }
    
    // Bouton numérique
    private func numberButton(for num: Int) -> some View {
        Button(action: {
            viewModel.enterValue(num)
        }) {
            Text("\(num)")
                .font(.system(size: 22, weight: .medium))
                .frame(width: 40, height: 40)
        }
        .buttonStyle(SudokuStyle.secondaryButtonStyle)
    }
    
    // Vérifier si une cellule est dans la même rangée ou colonne que la cellule sélectionnée
    private func isInSameLine(_ row: Int, _ col: Int) -> Bool {
        guard let selectedCell = viewModel.selectedCell else { return false }
        return row == selectedCell.row || col == selectedCell.col
    }
    
    // Vérifier si une cellule est dans le même bloc 3x3 que la cellule sélectionnée
    private func isInSameBox(_ row: Int, _ col: Int) -> Bool {
        guard let selectedCell = viewModel.selectedCell else { return false }
        let selectedBoxRow = selectedCell.row / 3
        let selectedBoxCol = selectedCell.col / 3
        let cellBoxRow = row / 3
        let cellBoxCol = col / 3
        return selectedBoxRow == cellBoxRow && selectedBoxCol == cellBoxCol
    }
    
    // Vérifier si une cellule est dans la même unité (rangée, colonne ou bloc) que la cellule sélectionnée
    private func isInSameUnit(_ row: Int, _ col: Int) -> Bool {
        guard viewModel.selectedCell != nil else { return false }
        return isInSameLine(row, col) || isInSameBox(row, col)
    }
    
    // Grille de Sudoku séparée en computed property
    private var sudokuGrid: some View {
        VStack(spacing: 0) {
            ForEach(0..<SudokuGrid.dimensions, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<SudokuGrid.dimensions, id: \.self) { col in
                        cellView(row: row, col: col)
                    }
                }
            }
        }
    }
    
    // Vue de cellule individuelle
    @ViewBuilder
    private func cellView(row: Int, col: Int) -> some View {
        let cell = viewModel.grid.cell(at: row, col)
        let cellStates = getCellStates(row: row, col: col, cell: cell)
        
        SudokuCellView(
            cell: cell,
            row: row,
            col: col,
            isSelected: cellStates.isSelected,
            isHighlighted: cellStates.isHighlighted,
            isRelated: cellStates.isRelated,
            isSameValue: cellStates.isSameValue,
            hasError: cellStates.hasError
        )
        .overlay(gridLinesOverlay(row: row, col: col))
        .onTapGesture {
            viewModel.selectCell(row: row, col: col)
        }
    }
    
    // États de la cellule regroupés
    private func getCellStates(row: Int, col: Int, cell: SudokuCell) -> (isSelected: Bool, isHighlighted: Bool, isRelated: Bool, isSameValue: Bool, hasError: Bool) {
        let isSelected = viewModel.selectedCell?.row == row && viewModel.selectedCell?.col == col
        let isHighlighted = isInSameBox(row, col) || isInSameLine(row, col)
        let isRelated = isInSameUnit(row, col)
        let isSameValue = cell.value != nil && cell.value == viewModel.highlightedValue
        let hasError = cell.value != nil && !viewModel.isValidPlacement(value: cell.value!, at: row, col: col)
        
        return (isSelected, isHighlighted, isRelated, isSameValue, hasError)
    }
    
    // Overlay pour les lignes de grille
    private func gridLinesOverlay(row: Int, col: Int) -> some View {
        GeometryReader { geo in
            Path { path in
                // Ligne verticale épaisse (droite)
                if (col + 1) % 3 == 0 && col < 8 {
                    path.move(to: CGPoint(x: geo.size.width, y: 0))
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height))
                }
                
                // Ligne horizontale épaisse (bas)
                if (row + 1) % 3 == 0 && row < 8 {
                    path.move(to: CGPoint(x: 0, y: geo.size.height))
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height))
                }
            }
            .stroke(SudokuStyle.thickLineColor, lineWidth: SudokuStyle.thickLineWidth)
        }
    }
}

#Preview {
    // Exemple de prévisualisation avec une grille partielle
    let initialGrid: [[Int?]] = [
        [5, 3, nil, nil, 7, nil, nil, nil, nil],
        [6, nil, nil, 1, 9, 5, nil, nil, nil],
        [nil, 9, 8, nil, nil, nil, nil, 6, nil],
        [8, nil, nil, nil, 6, nil, nil, nil, 3],
        [4, nil, nil, 8, nil, 3, nil, nil, 1],
        [7, nil, nil, nil, 2, nil, nil, nil, 6],
        [nil, 6, nil, nil, nil, nil, 2, 8, nil],
        [nil, nil, nil, 4, 1, 9, nil, nil, 5],
        [nil, nil, nil, nil, 8, nil, nil, 7, 9]
    ]
    
    let viewModel = SudokuViewModel(initialGrid: initialGrid)
    return SudokuGridView(viewModel: viewModel)
}
