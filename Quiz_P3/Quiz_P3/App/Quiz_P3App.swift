//
//  Quiz_P3App.swift
//  Quiz_P3
//
//  Created by Andrés Alfaro Fernández on 4/11/21.
//

import SwiftUI

@main
struct Quiz_P3App: App {
    let quizzesModel = QuizzesModel()
    let scoresModel = ScoresModel()
    var body: some Scene {
        WindowGroup {
            QuizzesListView()
                .environmentObject(quizzesModel)
                .environmentObject(scoresModel)
        }
    }
}
