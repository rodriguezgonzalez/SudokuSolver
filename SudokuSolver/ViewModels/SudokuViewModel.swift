//
//  SudokuViewModel.swift
//  SudokuSolver
//
//  Created by rgrg on 2025-05-16.
//

import Foundation
import SwiftUI

class SudokuViewModel: ObservableObject {
    @Published var grid: SudokuGrid
    @Published var selectedCell: (row: Int, col: Int)? = nil
    @Published var isInNoteMode: Bool = false
    @Published var highlightedValue: Int? = nil
    
    // États de l'application
    @Published var isSolving: Bool = false
    @Published var gameCompleted: Bool = false
    
    // Historique des mouvements pour annuler/refaire
    private var history: [SudokuGrid] = []
    private var historyIndex: Int = -1
    
    init(initialGrid: [[Int?]]? = nil) {
        self.grid = SudokuGrid(initialValues: initialGrid)
        saveToHistory()
    }
    
    // Sélectionner une cellule
    func selectCell(row: Int, col: Int) {
        selectedCell = (row, col)
        
        // Mettre à jour la valeur mise en évidence
        if let cell = selectedCell {
            highlightedValue = grid.cell(at: cell.row, cell.col).value
        } else {
            highlightedValue = nil
        }
    }
    
    // Entrer une valeur dans la cellule sélectionnée
    func enterValue(_ value: Int) {
        guard let cell = selectedCell else { return }
        
        if isInNoteMode {
            // Mode notes
            var newGrid = grid
            newGrid.toggleNote(at: cell.row, cell.col, value: value)
            grid = newGrid
        } else {
            // Mode normal
            var newGrid = grid
            
            // Si la même valeur est déjà présente, l'effacer
            let currentValue = grid.cell(at: cell.row, cell.col).value
            if currentValue == value {
                newGrid.setCell(at: cell.row, cell.col, value: nil)
            } else {
                newGrid.setCell(at: cell.row, cell.col, value: value)
            }
            
            grid = newGrid
            highlightedValue = grid.cell(at: cell.row, cell.col).value
            
            // Vérifier si le jeu est terminé
            checkCompletion()
        }
        
        saveToHistory()
    }
    
    // Effacer la valeur de la cellule sélectionnée
    func clearSelectedCell() {
        guard let cell = selectedCell else { return }
        
        var newGrid = grid
        newGrid.setCell(at: cell.row, cell.col, value: nil)
        grid = newGrid
        highlightedValue = nil
        
        saveToHistory()
    }
    
    // Basculer le mode notes
    func toggleNoteMode() {
        isInNoteMode.toggle()
    }
    
    // Vérifier si la grille est complète
    private func checkCompletion() {
        gameCompleted = grid.isComplete()
    }
    
    // Réinitialiser la grille
    func resetGrid() {
        var newGrid = grid
        newGrid.reset()
        grid = newGrid
        gameCompleted = false
        
        saveToHistory()
    }
    
    // Générer une nouvelle grille
    func generateNewGrid(difficulty: Difficulty) {
        var newGrid = SudokuGrid()
        newGrid.generateRandom(difficulty: difficulty)
        grid = newGrid
        gameCompleted = false
        
        // Réinitialiser l'historique
        history.removeAll()
        historyIndex = -1
        saveToHistory()
    }
    
    // Résoudre automatiquement le Sudoku
    func solve() {
        isSolving = true
        
        // Ceci sera implémenté plus tard avec un algorithme de backtracking
        // Pour l'instant, c'est juste un espace réservé
        
        isSolving = false
        checkCompletion()
    }
    
    // Gestion de l'historique pour annuler/refaire
    private func saveToHistory() {
        // Si nous ne sommes pas à la fin de l'historique, supprimez tout ce qui suit
        if historyIndex < history.count - 1 {
            history.removeSubrange((historyIndex + 1)...)
        }
        
        history.append(grid)
        historyIndex = history.count - 1
    }
    
    func canUndo() -> Bool {
        return historyIndex > 0
    }
    
    func canRedo() -> Bool {
        return historyIndex < history.count - 1
    }
    
    func undo() {
        guard canUndo() else { return }
        
        historyIndex -= 1
        grid = history[historyIndex]
        checkCompletion()
    }
    
    func redo() {
        guard canRedo() else { return }
        
        historyIndex += 1
        grid = history[historyIndex]
        checkCompletion()
    }
    
    // Vérifier si une valeur spécifique est valide à une position
    func isValidPlacement(value: Int, at row: Int, col: Int) -> Bool {
        return grid.isValid(value: value, at: row, col)
    }
}
