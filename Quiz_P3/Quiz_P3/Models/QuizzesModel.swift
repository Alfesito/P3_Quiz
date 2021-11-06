//
//  QuizzesModel.swift
//  P3 Quiz SwiftUI
//
//  Created by Santiago Pavón Gómez on 17/09/2021.
//

import Foundation
import SwiftUI
//ObservableObject: permite que se actualice si hay cambios
class QuizzesModel: ObservableObject {
    // Los datos
    @Published private(set) var quizzes: Array = [QuizItem]()
    @Published private(set) var author = [QuizItem.Author]()
    @Published private(set) var arrayAcertadas: Array <QuizItem> = []
    @Published private(set) var arrayNoAcertadas: Array <QuizItem> = []
    @Published private(set) var acertadas: Set <Int> = []
    @Published private(set) var stringAcertadas: Set <String> = []
    let urlBase = "https://core.dit.upm.es"
    let TOKEN = "72dfbad36c2571dae715"
    
    //Se utiliza cuando se pulsa al botton de generar 10 qizzess random
    func load() {
        //Sacos de ficheros(bundle)
        let urlString = "\(urlBase)/api/quizzes/random10wa?token=\(TOKEN)"
        
        guard let url = URL(string: urlString) else {
            print("No existe la URL")
            return
        }
        let session = URLSession.shared.dataTask(with: url) { (data, res, error) in
            if error != nil{
                print("Error")
                return
            }
            
            if (res as! HTTPURLResponse).statusCode != 200{
                print("Response")
                return
            }
            
            if let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data!){
                print("Load...")
                DispatchQueue.main.async {
                    self.quizzes = quizzes
                    self.arrayNoAcertadas = quizzes
                }
            }
        }
        session.resume()
    }
    
    //Descargar los quizzes 10 quizzes desde el servidor
    func download(){
        let urlString = "\(urlBase)/api/quizzes/random10wa?token=\(TOKEN)"
        
        guard let url = URL(string: urlString) else {
            print("No existe la URL")
            return
        }
        if quizzes.count <= 0{
            let session = URLSession.shared.dataTask(with: url) { (data, res, error) in
                if error != nil{
                    print("Error")
                    return
                }
                
                if (res as! HTTPURLResponse).statusCode != 200{
                    print("Response")
                    return
                }
                
                if let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data!){
                    print("Downloading...")
                    DispatchQueue.main.async {
                        self.quizzes = quizzes
                        self.arrayNoAcertadas = quizzes
                    }
                }
            }
            session.resume()
        }else{
            //Elimina los quizzes acertados del arrayNoAcertadas
            print("Loading...")
            var cont = -1
            for q2 in arrayNoAcertadas{
                cont=cont+1
                for q1 in arrayAcertadas{
                    if(q1.id == q2.id){
                        arrayNoAcertadas.remove(at: cont)
                        cont=cont-1
                        break
                    }
                }
            }
            print("Quizzes no acertados cargados")
            print("arrayAcertadas: \(arrayAcertadas.count)")
            print("arrayNoAcertadas: \(arrayNoAcertadas.count)")
        }
    }
    
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
    
    func reset(){
        arrayNoAcertadas = []
        arrayAcertadas = []
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: MEJORA 1
    func toggleFavourite( _ quizItem: QuizItem){
        
        guard let index = quizzes.firstIndex(where: {$0.id == quizItem.id}) else {
            print("Fallo 5 index")
            return
        }
        
        let urlString = "\(urlBase)/api/users/tokenOwner/favourites/\(quizItem.id)?token=\(TOKEN)"
        
        guard let url = URL(string: urlString) else{
            print(urlString)
            print("Fallo al crear la url")
            return
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = quizItem.favourite ? "DELETE" : "PUT"
        req.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        let session = URLSession.shared.uploadTask(with: req, from: Data()) {(data, res, error) in
            
            if error != nil{
                print("Fallo en error")
                return
            }
            
            if (res as! HTTPURLResponse).statusCode != 200{
                print("Fallo en response")
                return
                
            }
            
            DispatchQueue.main.async {
                self.quizzes[index].favourite.toggle()
                self.arrayNoAcertadas[index].favourite.toggle()
            }
        }
        session.resume()
    }
    
}

