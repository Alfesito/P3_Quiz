//
//  QuizPlayView.swift
//  Quiz_P3
//
//  Created by Andrés Alfaro Fernández on 30/9/21.
//

import SwiftUI

struct QuizPlayView: View {
    var quizItem: QuizItem
    @EnvironmentObject var scoresModel : ScoresModel
    @EnvironmentObject var quizzesModel : QuizzesModel
    @State var answer: String = ""
    @State var showAlert = false
    @State var showAnswer1 = false
    @State var showAnswer2 = false
    @State var r = 0.0
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact{
            verticalView
        }else{
            horizontalView
        }
    }
    private var verticalView: some View{
        return VStack{
            let s1: String = answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            let s2: String = quizItem.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            HStack{
                Text(quizItem.question)
                    .font(.largeTitle)
                Button(action: {
                    quizzesModel.toggleFavourite(quizItem)
                }){
                    Image(quizItem.favourite ? "yellow_star" : "grey_star")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFit()
                        .shadow(color: Color.gray, radius: 5)
                }
                
            }
            TextField("Respuesta",
                      text: $answer,
                      onCommit: {
                        showAlert = true
                        scoresModel.check(res: answer, quiz: quizItem)
                        quizzesModel.check(res: answer, quiz: quizItem)
                        scoresModel.score()
                      })
                .border(Color(UIColor.separator))
                .alert(isPresented: $showAlert){
                    return Alert(title: Text("Resultado"),
                                 message: Text(s1 == s2 ? "Bien" : "Mal"),
                                 dismissButton: .default(Text("Ok"))
                    )
                }.padding()
            
            Button(action: {
                showAlert = true
                scoresModel.check(res: answer, quiz: quizItem)
                quizzesModel.check(res: answer, quiz: quizItem)
                scoresModel.score()
                if(s1 == s2){
                    withAnimation{
                        r = r + 360
                    }
                }
                
            }) {
                Text("Comprobar")
                Image(systemName: "paperplane.circle.fill")
            }
            
            attachment
                .padding()
            
            HStack(alignment: .bottom, spacing: 100){
                HStack{
                    scores
                        .padding()
                }
                Spacer()
                HStack{
                    author
                        .padding()
                }
            }
        }
    }
    
    private var horizontalView: some View{
        let s1: String = answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let s2: String = quizItem.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return
            HStack{
                attachment
                    .padding()
                VStack{
                    HStack{
                        Text(quizItem.question)
                            .font(.largeTitle)
                        Button(action: {
                            quizzesModel.toggleFavourite(quizItem)
                        }){
                            Image(quizItem.favourite ? "yellow_star" : "grey_star")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .scaledToFit()
                                .shadow(color: Color.gray, radius: 5)
                        }
                    }
                    TextField("Respuesta",
                              text: $answer,
                              onCommit: {
                                showAlert = true
                                scoresModel.check(res: answer, quiz: quizItem)
                                quizzesModel.check(res: answer, quiz: quizItem)
                                scoresModel.score()
                              })
                        .border(Color(UIColor.separator))
                        .alert(isPresented: $showAlert){
                            return Alert(title: Text("Resultado"),
                                         message: Text(s1 == s2 ? "Bien" : "Mal"),
                                         dismissButton: .default(Text("Ok"))
                            )
                        }.padding()
                    
                    Button(action: {
                        showAlert = true
                        scoresModel.check(res: answer, quiz: quizItem)
                        quizzesModel.check(res: answer, quiz: quizItem)
                        scoresModel.score()
                        if(s1 == s2){
                            withAnimation{
                                r = r + 360
                            }
                        }
                        
                    }) {
                        Text("Comprobar")
                        Image(systemName: "paperplane.circle.fill")
                    }
                    HStack(alignment: .bottom){
                        HStack{
                            scores
                        }
                        Spacer()
                        HStack{
                            author
                        }
                    }.padding()
                }
            }
        
    }
    
    private var scores: some View{
        Text("\(scoresModel.acertadas.count)")
            .font(.title)
            .fontWeight(.bold)
    }
    
    private var author: some View{
        let u_url = quizItem.author?.photo?.url
        let u_nivm=NetworkImageViewModel(url:u_url)
        
        return HStack(alignment: .center, spacing: 5){
            Text(quizItem.author?.username ?? "Anónimo")
                .font(.callout)
            
            NetworkImageView(viewModel:u_nivm)
                .scaledToFill()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                .overlay(Circle().stroke(lineWidth: 3))
                .contextMenu{
                    Button(action: {
                        answer = ""
                    }) {
                        Text("Eliminar respuesta")
                        Image(systemName: "trash")
                    }
                    Button(action: {
                        answer = quizItem.answer
                    }) {
                        Text("Ver solución")
                        Image(systemName: "eye")
                    }
                    //Reseteamos los arrays y sets
                    Button(action: {
                        quizzesModel.load()
                        scoresModel.reset()
                        scoresModel.deleteScore()
                        answer = ""
                    }) {
                        Text("Resetear juego")
                        Image(systemName: "backward")
                    }
                    Button(action: {
                        quizzesModel.toggleFavourite(quizItem)
                    }){
                        Text("Favorito")
                        if quizItem.favourite{
                            Image(systemName: "star.fill")
                                .shadow(color: Color.gray, radius: 5)
                        }else{
                            Image(systemName: "star")
                                .shadow(color: Color.gray, radius: 5)
                        }
                    }
                }
        }
    }
    
    private var attachment: some View{
        let a_url = quizItem.attachment?.url
        let a_nivm=NetworkImageViewModel(url:a_url)
        
        return GeometryReader(content: {geometry in
            NetworkImageView(viewModel:a_nivm)
                .scaledToFill()
                .frame( width: geometry.size.width,
                        height: geometry.size.height)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .contentShape(RoundedRectangle(cornerRadius: 20))
                .clipShape(Rectangle())
                .shadow(color: Color.gray, radius: 5)
                //Animations
                .rotationEffect(Angle(degrees: r))
                .saturation(self.showAlert ? 0.1 : 1)
                .animation(.easeInOut, value: self.showAlert)
                .onTapGesture(count: 2) {
                    answer = quizItem.answer
                    showAnswer1 = true
                }.saturation(self.showAnswer1 ? 0.1 : 1)
                //ADICIONAL - Cuando se mantiene pulsado sobre la imagen, se borra la respuesta al quiz
                //          y la imagen se pone como en default
                .onLongPressGesture{
                    if showAnswer1{
                        answer = ""
                        showAnswer1 = false
                        showAnswer2 = true
                    }
                }.saturation(self.showAnswer2 ? 1 : 1)
            
        })
    }
}
/*
 struct QuizPlayView_Previews: PreviewProvider {
 static var previews: some View {
 QuizPlayView()
 }
 }*/
