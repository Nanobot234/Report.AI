import Foundation
import GoogleGenerativeAI
import UIKit

/// Defines functions that interact with Google's Gemini API
class GeminiManager {
    
    static let shared = GeminiManager()
    private let geminiModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    private let Udefaults = UserDefaults.standard
    
    private let basicPrompt = "If there is a problem that needs to be resolved in this image, please describe the problem or issue in this image in 4 words or less. If not, just state no problem."
    private let complaintPrompt = "Analyze the problem in this image. Please return an array with only two elements: 1) the problem statement in 4 words or less, and 2) a brief, direct paragraph describing the issue."
    private let additionalImagesPrompt = "The problem as determined from the first image is \(UserDefaults.standard.getAnalyzedProblemName()). Use the additional images provided to provide a more accurate description of the problem."
    private let solutionPrompt = "Come up with a realistic solution in a maximum of 3 steps in a numbered list to address the following problem."

    // MARK: - Problem Description Methods
    
    /// Generates the problem description from a given image.
    func generateProblemAndDescriptionFromImage(input: UIImage) async -> [String]? {
        var result: [String] = []

        do {
            let response = try await geminiModel.generateContent(complaintPrompt, input)
            let text = response.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            // Extract the problem and description from the response string
            result = createListFromResponseString(with: text)
        } catch {
            print("Error generating problem and description: \(error.localizedDescription)")
        }

        return result.isEmpty ? nil : result
    }

    /// Creates a list from the generated response string.
    private func createListFromResponseString(with input: String) -> [String] {
        // Ensure valid input (the response is in the expected format)
        guard input.hasPrefix("[") && input.hasSuffix("]") else {
            print("Invalid response format, expected a tuple.")
            return []
        }

        // Remove square brackets and split by commas
        let trimmedString = input.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
        let components = trimmedString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: CharacterSet(charactersIn: "'")) }

        // Return the components as a list
        return components
    }
    
    // MARK: - Additional Images Methods
    
    /// Updates the problem description based on additional images.
    func updateProblemDescriptionWithImages(input: [UIImage]) async -> String {
        var updatedResponse = ""
        
        do {
            // Make sure input has at least one image
            guard !input.isEmpty else {
                throw NSError(domain: "GeminiManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No images provided."])
            }
            
            // Use the appropriate prompt based on the number of images
            switch input.count {
            case 3:
                updatedResponse = try await geminiModel.generateContent(additionalImagesPrompt, input[0], input[1], input[2]).text ?? ""
            case 2:
                updatedResponse = try await geminiModel.generateContent(additionalImagesPrompt, input[0], input[1]).text ?? ""
            default:
                updatedResponse = try await geminiModel.generateContent(additionalImagesPrompt, input[0]).text ?? ""
            }
        } catch {
            print("Error updating problem description: \(error.localizedDescription)")
            updatedResponse = "An error occurred, please try again."
        }

        return updatedResponse
    }
    
    // MARK: - Solution Methods
    
    /// Generates a solution for the given problem description.
    func generateSolutionFromProblem(problemDescription: String) async -> String {
        let inputText = solutionPrompt + "\n\n\(problemDescription)"
        
        do {
            let response = try await geminiModel.generateContent(inputText)
            return response.text ?? "No solution found."
        } catch {
            print("Error generating solution: \(error.localizedDescription)")
            return "An error occurred while generating the solution."
        }
    }
    
    // MARK: - Saving Data Methods
    
    /// Saves the problem and description to `UserDefaults`.
    func saveProblemAndDescription(data: (String, String)) {
        Udefaults.set(data.0, forKey: "problemName")
        Udefaults.set(data.1, forKey: "problemDescription")
    }

    // MARK: - Helper Methods
    
    /// Generate a problem statement from the image
    func generateProblemStatementFromImage(input: UIImage, completion: @escaping (String) -> Void) async {
        do {
            let response = try await geminiModel.generateContent(basicPrompt, input)
            completion(response.text ?? "No problem statement generated.")
        } catch {
            print("Error generating problem statement: \(error.localizedDescription)")
            completion("")
        }
    }
}

