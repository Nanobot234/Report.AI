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
    let Udefaults = UserDefaults.standard
    private let geminiModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    let basicPrompt = "If there is a problem that needs to be resolved in this image, Please describe the problem or issue in this image and do so in 4 words or less. If not, just state no problem"
    let complaintPrompt = "Please return a tuple from an analysis of the problem in this image. The first element of the tuple should be the problem stated in 4 words or less. But the second element should be a longer more description of the problem analyzed in the image, but it should be a paragraph or less. keep in mind that the analysis will be submitted as a complaint to authortiies so keep the language direct and informative."
    let additionalImagesPrompt = "The problem as determined from the first image is \(UserDefaults.standard.getAnalyzedProblemName()) use the additonal images provided to provide a new more accurate description of the problem. Make sure to combine details from both the original problem and new insights you gain from the new images to make a complete, detailed but concise problem description"
    let solutionPrompt = "Come up with a solution in about 3 steps that would address the following problem/n"
    
    
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
     

    func generateProblemAndDescriptionFromImage(input: UIImage) async -> (String, String) {
       //the complaint description, statement name,
        //this can be used here!!, and also may need to ask to make it sound more realistic!
        
        var  text = ""
        do {
              let response = try await geminiModel.generateContent(complaintPrompt, input)
              text = response.text!
            print(text)
        } catch {
            print(error.localizedDescription)
        }
         
        //print(text) //want to see what will get
        
        //create and return the tupel here!!
  
        let problemAndDescription = createTupleFromResponseString(with: text)
        
        
        return problemAndDescription
    }
    
    //maek sure all the images are filled before this tho, like all parts in the array
    func updateProblemDescriptionWithImages(input: [UIImage]) async -> String {
        
        var updatedResponse = ""
        do {
            //depending on input size here
            if(input.count == 3) {
                updatedResponse = try await geminiModel.generateContent(additionalImagesPrompt,input[0], input[1], input[2]).text!
                print(updatedResponse)
            } else if(input.count == 2) {
                updatedResponse = try await geminiModel.generateContent(additionalImagesPrompt,input[0], input[1]).text!
                print(updatedResponse)
            } else{
                updatedResponse = try await geminiModel.generateContent(additionalImagesPrompt,input[0]).text!
                print(updatedResponse)
            }
        } catch {
            print(error.localizedDescription)
            updatedResponse = "An error occured please try again"
        }
        
        return updatedResponse
    }
    
    //likkely have function that will serialize the data into an object to be used!
    
        
    //fix this here
    func createTupleFromResponseString(with input: String) -> (String, String) {
        let cleanedString = input.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
        let components = cleanedString.split(separator: ",",maxSplits: 1, omittingEmptySubsequences: true)

        // Ensure the components are properly extracted and trimmed
        print(components.count)
        if components.count == 2 {
            let problemName = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let problemDescription = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            let parsedTuple: (String, String) = (problemName, problemDescription)
            saveProblemAndDescription(data: parsedTuple) //save it to userdefaults
            print("Parsed Tuple from Gemini response: \(parsedTuple)")
            return parsedTuple
        } else {
            print("Failed to parse the string into a tuple")
        }
        
        //save this for the user
        
        return ("","")
        
    }
    
    func saveProblemAndDescription(data: (String, String)) {
        
        Udefaults.set(data.0, forKey: "problemName")
        Udefaults.set(data.1, forKey: "problemDescription")
        
    }
    
 

    
    
    // Remove the parentheses and split the string by the comma
    
}
