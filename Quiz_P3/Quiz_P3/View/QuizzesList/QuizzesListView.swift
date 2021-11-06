//
//  ContentView.swift
//  Quiz_P3
//
//  Created by Andrés Alfaro Fernández on 22/9/21.
//

import SwiftUI

struct QuizzesListView: View {
    @EnvironmentObject var quizzesModel : QuizzesModel
    @EnvironmentObject var scoresModel : ScoresModel
    @State var showNoResueltosView: Bool = false
    @State var showResueltos: Bool = false
    @State var showAlert: Bool = false
    private var kmykey = "MY_KEY"
    var body: some View {
        NavigationView{
            if(showNoResueltosView){
                SubView2(showNoResueltosView2 : $showNoResueltosView)
                    .toolbar{
                        ToolbarItem(placement: .cancellationAction){
                            //Boton Random
                            Button(action: {
                                scoresModel.reset()
                                quizzesModel.reset()
                                quizzesModel.load()
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath.circle")
                            }
                        }
                    }
            }else{
                SubView1(showNoResueltosView1 : $showNoResueltosView)
                    .toolbar{
                        ToolbarItem(placement: .cancellationAction){
                            //Boton Random
                            Button(action: {
                                scoresModel.reset()
                                quizzesModel.reset()
                                quizzesModel.load()
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath.circle")
                            }
                        }
                    }
            }
            
        }
    }
}

//Muestra los quizzes resueltos
struct SubView1: View {
    @EnvironmentObject var quizzesModel : QuizzesModel
    @EnvironmentObject var scoresModel : ScoresModel
    @Binding var showNoResueltosView1: Bool
    var kmykey = "MY_KEY"
    var body: some View{
        List{
            Toggle("Quizzes no resueltos", isOn: $showNoResueltosView1)
            ForEach(quizzesModel.quizzes){
                qi in
                NavigationLink(destination: QuizPlayView(quizItem:qi)){
                    QuizRowView(quizItem: qi)
                }
            }
        }
        .padding()
        .navigationBarTitle(Text("Quiz P3 SwiftIU"))
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                HStack{
                    Text("Record:")
                    Text("\(UserDefaults.standard.integer(forKey: kmykey))")
                        .font(.largeTitle)
                }
            }
        }
        
        .onAppear(perform: {
            quizzesModel.download()
        })
    }
}

//Muestra los quizzes no resueltos
struct SubView2: View {
    @EnvironmentObject var scoresModel : ScoresModel
    @EnvironmentObject var quizzesModel : QuizzesModel
    @Binding var showNoResueltosView2: Bool
    var kmykey = "MY_KEY"
    var body: some View{
        List{
            Toggle("Quizzes no resueltos", isOn: $showNoResueltosView2)
            ForEach(quizzesModel.arrayNoAcertadas){
                qi in
                NavigationLink(destination: QuizPlayView(quizItem:qi)){
                    QuizRowView(quizItem: qi)
                }
            }
        }
        .padding()
        .navigationBarTitle(Text("Quiz P3 SwiftIU"))
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                HStack{
                    Text("Record:")
                    Text("\(UserDefaults.standard.integer(forKey: kmykey))")
                        .font(.largeTitle)
                }
            }
        }
        .onAppear(perform: {
            quizzesModel.download()
        })
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuizzesListView()
//    }
//}
