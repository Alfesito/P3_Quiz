//
//  quizRow.swift
//  Quiz_P3
//
//  Created by Andrés Alfaro Fernández on 22/9/21.
//

import SwiftUI

struct QuizRowView: View {
    var quizItem: QuizItem
    var body: some View {
        
        let a_url = quizItem.attachment?.url
        let a_nivm=NetworkImageViewModel(url:a_url)
        
        return
            HStack{
                VStack{
                    NetworkImageView(viewModel:a_nivm)
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .shadow(color: Color.gray, radius: 5)
                }
                VStack(alignment: .leading){
                    HStack{
                        Text(quizItem.question)
                            .font(.headline)
                    }.scaledToFill()
                    HStack(alignment: .bottom, spacing: 40){
                        VStack(alignment: .leading){
                            image_star
                        }
                        VStack(alignment: .leading){
                            editor
                        }
                    }
                    
                }
                .padding(10)
            }
    }
    
    private var image_star: some View{
        Image(quizItem.favourite ? "yellow_star" : "grey_star")
            .resizable()
            .frame(width: 20, height: 20)
            .scaledToFit()
            .shadow(color: Color.gray, radius: 5)
    }
    
    private var editor: some View{
        let u_url = quizItem.author?.photo?.url
        let u_nivm=NetworkImageViewModel(url:u_url)
        return
            HStack(alignment: .center, spacing: 5){
                Text(quizItem.author?.username ?? "Anónimo")
                    .font(.custom("Arial", size: 10))
                
                NetworkImageView(viewModel:u_nivm)
                    .scaledToFill()
                    .frame(width: 15, height: 15)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(lineWidth: 3))
            }
    }
}
/*
 struct QuizRow_Previews: PreviewProvider {
 static var previews: some View {
 QuizRow()
 }
 }*/
