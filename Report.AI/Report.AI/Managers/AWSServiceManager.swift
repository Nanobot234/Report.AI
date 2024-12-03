//
//  AWSManager.swift
//  Report.AI
//
//  Created by Nana Bonsu on 10/17/24.
//

import Foundation
import AWSS3
import Amplify
import Smithy
import ClientRuntime


actor AWSServiceManager {
    
    static let shared = AWSServiceManager()
    
    
    
    
    /// helper function uploads a report to AWS S3 .
    /// - Parameters:
    ///   - report: the report to be uploaded
    ///   - path: the path to upload to
    ///   - completion: a result value determining if the operation succeeded or failed
    func uploadReport(report: Report, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        
        if let reportData = convertReportToData(with: report) {
            Task {
                
                await uploadDatatoS3(path: path, withData: reportData)
                completion(.success("Upload completed"))
            }
        } else {
            completion(.failure(NSError(domain: "DataConversionError", code: 0, userInfo: nil)))
            
        }
    }
    
    
    /// Convert a `Report` object to a Data  object to be stored in s3
    /// - Parameter report: the report object to convert
    /// - Returns:  the data object
    public func convertReportToData(with report: Report) -> Data? {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(report)
            return data
        } catch {
            print("Error encoding report \(error.localizedDescription)")
        }
        
        return nil
    }
    
   //more here to come!!
    public func getUploadedImageURL() {
    }
    /// Uploads data to AWS S3 bucket at the specified path.
    /// - Parameters:
    ///   - path: the path to store th data in the bucket
    ///   - data: the data to be stored
    public func uploadDatatoS3(path: String , withData data: Data) async  {
        
        let uploadTask = Amplify.Storage.uploadData(
            path: .fromString(path),
            data: data
        )
        
        
        Task {
            for await progress in await uploadTask.progress {
                print("Progress: \(progress)")
            }
        }
        do {
            let value = try await uploadTask.value
            print("Completed: \(value)")
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
}
