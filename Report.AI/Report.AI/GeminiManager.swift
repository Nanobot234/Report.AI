//
//  GeminiManager.swift
//  Report.AI
//
//  Created by Nana Bonsu on 8/27/24.
//

import Foundation
import GoogleGenerativeAI
import UIKit

/// Defines functions that will be used to make call to Google's Gemini API
class GeminiManager {
    
    static let shared = GeminiManager()
    private let geminiModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    let basicPrompt = "Please describe the problem or issue in this image and do so in 4 words or less"
    let complaintPrompt = "Please return a tuple from an analysis of the problem in this image. The first element of the tuple should be the problem stated in 4 words or less. But the second element should be a longer more description of the problem analyzed in the image, but it should be a paragraph or less. keep in mind that the analysis will be submitted as a complaint to authortiies so keep the language direct and informative."
    
    
    //
    
    //likely a test function of the api
    func generateProblemStatementFromImage(input: UIImage, completion: @escaping (String) -> Void) async {
        
        do {
            let response = try await geminiModel.generateContent(basicPrompt, input)
            completion(response.text!)
        } catch {
            print(error.localizedDescription)
            completion("")
        }
    }
     

    func generateProblemAndDescriptionFromImage(input: UIImage) async {
       //the complaint description, statement name,
        //this can be used here!!, and also may need to ask to make it sound more realistic!
        
        var  text = ""
        do {
              let response = try await geminiModel.generateContent(complaintPrompt, input)
              text = response.text!
        } catch {
            print(error.localizedDescription)
        }
         
        //print(text) //want to see what will get
        
        //create and return the tupel here!!
        
    }
    
    //likkely have function that will serialize the data into an object to be used!
    

    func createTupleFromResponseString() {
        
    }
    
    
}
