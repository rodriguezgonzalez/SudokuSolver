//
//  SudokuGrid.swift
//  SudokuSolver
//


import Foundation

struct SudokuGrid {
    // Une grille 9x9 standard
    private(set) var grid: [[SudokuCell]] = []
    
    // Dimensions de la grille
    static let dimensions = 9
    static let boxSize = 3
    
    init(initialValues: [[Int?]]? = nil) {
        // Initialiser une grille vide
        grid = Array(repeating: Array(repeating: SudokuCell(), count: SudokuGrid.dimensions), count: SudokuGrid.dimensions)
        
        // Si des valeurs initiales sont fournies, les appliquer
        if let initialValues = initialValues {
            for row in 0..<min(initialValues.count, SudokuGrid.dimensions) {
                for col in 0..<min(initialValues[row].count, SudokuGrid.dimensions) {
                    if let value = initialValues[row][col] {
                        grid[row][col].value = value
                        grid[row][col].isGiven = true
                    }
                }
            }
        }
    }
    
    // Accesseur pour obtenir une cellule
    func cell(at row: Int, _ col: Int) -> SudokuCell {
        guard isValidIndex(row, col) else { return SudokuCell() }
        return grid[row][col]
    }
    
    // Mutateur pour mettre à jour une cellule
    mutating func setCell(at row: Int, _ col: Int, value: Int?) {
        guard isValidIndex(row, col) && !grid[row][col].isGiven else { return }
        grid[row][col].value = value
    }
    
    // Vérifier si un indice est valide
    private func isValidIndex(_ row: Int, _ col: Int) -> Bool {
        return row >= 0 && row < SudokuGrid.dimensions && col >= 0 && col < SudokuGrid.dimensions
    }
    
    // Vérifier si un nombre est valide à une position donnée
    func isValid(value: Int, at row: Int, _ col: Int) -> Bool {
        guard isValidIndex(row, col) && value >= 1 && value <= 9 else { return false }
        
        // Vérifier la ligne
        for c in 0..<SudokuGrid.dimensions {
            if c != col && grid[row][c].value == value {
                return false
            }
        }
        
        // Vérifier la colonne
        for r in 0..<SudokuGrid.dimensions {
            if r != row && grid[r][col].value == value {
                return false
            }
        }
        
        // Vérifier le carré 3x3
        let boxRow = row / SudokuGrid.boxSize
        let boxCol = col / SudokuGrid.boxSize
        for r in (boxRow * SudokuGrid.boxSize)..<((boxRow + 1) * SudokuGrid.boxSize) {
            for c in (boxCol * SudokuGrid.boxSize)..<((boxCol + 1) * SudokuGrid.boxSize) {
                if r != row && c != col && grid[r][c].value == value {
                    return false
                }
            }
        }
        
        return true
    }
    
    // Vérifier si la grille est complète et valide
    func isComplete() -> Bool {
        for row in 0..<SudokuGrid.dimensions {
            for col in 0..<SudokuGrid.dimensions {
                if grid[row][col].value == nil || !isValid(value: grid[row][col].value!, at: row, col) {
                    return false
                }
            }
        }
        return true
    }
    
    // Réinitialiser la grille (ne conserve que les valeurs données)
    mutating func reset() {
        for row in 0..<SudokuGrid.dimensions {
            for col in 0..<SudokuGrid.dimensions {
                if !grid[row][col].isGiven {
                    grid[row][col].value = nil
                    grid[row][col].notes = []
                }
            }
        }
    }
    
    // Générer une grille aléatoire (sera implémentée plus tard)
    mutating func generateRandom(difficulty: Difficulty) {
        // À implémenter
    }
    
    // Ajout des notes à une cellule
    mutating func toggleNote(at row: Int, _ col: Int, value: Int) {
        guard isValidIndex(row, col) && !grid[row][col].isGiven && grid[row][col].value == nil else { return }
        
        if grid[row][col].notes.contains(value) {
            grid[row][col].notes.removeAll { $0 == value }
        } else {
            grid[row][col].notes.append(value)
        }
    }
}

// Structure pour une cellule individuelle
struct SudokuCell {
    var value: Int? = nil
    var isGiven: Bool = false  // Indique si c'est une valeur initiale
    var notes: [Int] = []  // Pour les notes de l'utilisateur
}

// Niveaux de difficulté
enum Difficulty {
    case easy
    case medium
    case hard
    case expert
}
