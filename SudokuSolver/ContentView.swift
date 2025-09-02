//
//  ContentView.swift
//  SudokuSolver
//
//  Created by Rafael Rodriguez on 2025-05-16.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SudokuViewModel()
    @State private var showNewGame = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Titre et boutons principaux
                Text("Sudoku Solver")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Interface principale de la grille
                SudokuGridView(viewModel: viewModel)
                    .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showNewGame = true
                    }) {
                        Label("Nouvelle partie", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {
                            viewModel.resetGrid()
                        }) {
                            Label("Réinitialiser", systemImage: "arrow.counterclockwise")
                        }
                        
                        Button(action: {
                            // Fonction à implémenter
                        }) {
                            Label("Indice", systemImage: "lightbulb")
                        }
                        
                        Button(action: {
                            // Fonction à implémenter
                        }) {
                            Label("Vérifier les erreurs", systemImage: "checkmark.circle")
                        }
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                    }
                }
            }
            .confirmationDialog("Nouvelle partie", isPresented: $showNewGame) {
                Button("Facile") {
                    viewModel.generateNewGrid(difficulty: .easy)
                }
                Button("Moyen") {
                    viewModel.generateNewGrid(difficulty: .medium)
                }
                Button("Difficile") {
                    viewModel.generateNewGrid(difficulty: .hard)
                }
                Button("Expert") {
                    viewModel.generateNewGrid(difficulty: .expert)
                }
                Button("Annuler", role: .cancel) { }
            } message: {
                Text("Choisissez le niveau de difficulté")
            }
        }
    }
}

#Preview {
    ContentView()
}
