//
//  ScoresModel.swift
//  Quiz_P1
//
//  Created by Andrés Alfaro Fernández on 30/9/21.
//

import Foundation

class ScoresModel: ObservableObject {
    
    @Published private(set) var acertadas: Set <Int> = []
    @Published private(set) var arrayAcertadas: Array <QuizItem> = []
    @Published private(set) var stringAcertadas: Set <String> = []
    private var kmykey = "MY_KEY"
    
    func check(res: String, quiz: QuizItem){
        let a1 = res.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let a2 = quiz.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(a1 == a2){
            acertadas.insert(quiz.id)
            stringAcertadas.insert(quiz.question)
            
            // Guarda en array acertadas los quizzes acertados
            arrayAcertadas.append(quiz)
            if arrayAcertadas.count != acertadas.count {
                arrayAcertadas.removeLast()
            }
        }
    }
    
    //ADICIONAL - Resetea los arrays y sets para empezar de nuevo el juego
    func reset(){
        acertadas = []
        arrayAcertadas = []
        stringAcertadas = []
    }
    
    //Guarda la puntuacion en las preferencias del usuario, siempre y cuando el score sea
    //mayor al que habia guardado anteriormente
    func score(){
        if(UserDefaults.standard.integer(forKey: kmykey) < acertadas.count){
            UserDefaults.standard.set(acertadas.count, forKey: kmykey)
            UserDefaults.standard.synchronize()
        }
    }
    //ADICIONAL - Elimina la puntuacion guardada en la preferencias del usuario
    func deleteScore(){
        UserDefaults.standard.removeObject(forKey: kmykey)
        UserDefaults.standard.synchronize()
    }
}


