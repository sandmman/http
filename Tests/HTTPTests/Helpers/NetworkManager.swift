//
//  NetworkManager.swift
//  SwiftServerHTTPPackageDescription
//
//  Created by Aaron Liberatore on 9/18/17.
//

import Foundation

class NetworkManager : NSObject, URLSessionDelegate, URLSessionDataDelegate {

    private var session: URLSession! = nil
    
    private var callback: ((Data) -> ())? = nil
    
    private var chunkCount = 0
    
    private var data = Data()

    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
    }
    
    func send(url: String, with data: Data, callback: @escaping (Data) -> ()) {
        self.callback = callback
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = data
        let task = self.session.uploadTask(with: request, from: data)
        task.resume()
    }

    //
    // Delegate Methods
    //

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        chunkCount += 1
        self.data.append(data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil {
            callback?(self.data)
        }
    }
}
