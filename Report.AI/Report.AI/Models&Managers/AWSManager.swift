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
    var configuration: S3Client.S3ClientConfiguration?
    var client: S3Client?
    let bucket:String =  "reportaidata"
    
   //
    
    
    public init()  {
        
        }
    
    public func setup() async throws{
        do {
            configuration = try await S3Client.S3ClientConfiguration()
            
            let config = AWS
            print(configuration?.appID!)
         //   configuration.region = "us-east-2" // Uncomment this to set the region programmatically.
            client = S3Client(config: configuration!)
        }
        catch {
            print("ERROR: ", dump(error, name: "Initializing S3 client"))
             throw error
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
    
    func uploadReport(report: Report, key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        
        if let reportData = convertReportToData(with: report) {
            Task {
                do {
                    try await createFile(bucket: bucket, key: key, withData: reportData)
                 
                } catch {
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(NSError(domain: "DataConversionError", code: 0, userInfo: nil)))

        }
       }
    
    /// Creates report file for the current user and
    /// - Parameters:
    ///   - bucket: <#bucket description#>
    ///   - key: <#key description#>
    ///   - data: <#data description#>
    public func createFile(bucket: String, key: String, withData data: Data) async throws {
        
        //key is likely going to be the userID
        //key is the id of the person likely!
        
            let dataStream = ByteStream.data(data)

            let input = PutObjectInput(
                body: dataStream,
                bucket: bucket,
                key: key
            )

            do {
                
                _ = try await client!.putObject(input: input)
            }
            catch {
                print("ERROR: ", dump(error, name: "Putting an object."))
                throw error
            }
        }
    

//    func uploadData(report: Report, completion: @escaping (Result<Bool, Error>) -> Void) {
//        
//        
//        
//    }
}
