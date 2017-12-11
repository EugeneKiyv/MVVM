//
//  SearchProvider.swift
//  MVVM Test
//
//  Created by Eugene Kuropatenko on 12/09/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation

protocol SearchProtocol {
    var storedRequest:RequestModel? {get set}
    var isSearching:Bool {get}
    var results:[Result] {get set}
    
    init(updateCloser: @escaping ()->(), storageProvider:StorageProviderModel)
    func search(_ text:String)
    func stopSearch()
}

class SearchProvider: NSObject, SearchProtocol {
    fileprivate enum Keys:String {
        case title = "full_name"
        case path = "html_url"
        case stars = "stargazers_count"
        case descr = "description"
    }
    
    var storedRequest:RequestModel? {
        didSet {
            if storedRequest != nil {
                (storedRequest as? NSObject)?.addObserver(self, forKeyPath: "results", options: .new, context: nil)
                results = storedRequest?.results?.sorted(by: { (r1, r2) -> Bool in
                    return (r1 as! Result).stars > (r2 as! Result).stars
                }) as! [Result]
            } else {
                results = []
            }
            DispatchQueue.main.async {
                self.updateCloser()
            }
        }
    }
    var results:[Result] = []
    var isSearching: Bool {
        return storedRequest == nil
    }

    fileprivate var task: URLSessionDataTask?
    fileprivate var updateCloser:(()->())
    fileprivate var storageProvider:StorageProviderModel!
    
    required init(updateCloser: @escaping () -> (), storageProvider:StorageProviderModel) {
        self.updateCloser = updateCloser
        self.storageProvider = storageProvider
    }

    func search(_ text:String) {
        search(text, language: "swift")
    }

    fileprivate func clearCurrentResults() {
        storedRequest = nil
        results = []
        updateCloser()
    }
    
    fileprivate func search(_ text:String, language:String) {
        storedRequest = nil
        results = []
        updateCloser()
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var urlComponent = URLComponents(string: "https://api.github.com/search/repositories") else { return }
        let items = [
            URLQueryItem(name: "q", value: "\(text), language:\(language)"),
            //            URLQueryItem(name: "q", value: "socket, language:Objective-C"),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: "desc")
        ]
        urlComponent.queryItems = items
        guard let url = urlComponent.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        task = session.dataTask(with: request, completionHandler: {[weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                guard let strongSelf = self else { return }
                // Success
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        let dbRequest = strongSelf.storageProvider.createRequest(text: text)
                        if let resultsDict = json["items"] as? [[String:Any]] {
                            for element in resultsDict {
                                let result = strongSelf.storageProvider.createResult(title: (element[Keys.title.rawValue] as? String) ?? "",
                                                                                     path: (element[Keys.path.rawValue] as? String) ?? "",
                                                                                     description: (element[Keys.descr.rawValue] as? String) ?? "",
                                                                                     stars: (element[Keys.stars.rawValue] as? Int16) ?? 0)
                                strongSelf.storageProvider.addResult(result, toRequest: dbRequest)
                            }
                        }
                        strongSelf.storageProvider.saveContext()
                        self?.storedRequest = dbRequest
                    }
                } catch {
                    print(error)
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task?.resume()
        session.finishTasksAndInvalidate()
    }
    
    internal override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let request = object as? Request {
            if request.results?.count != 0 {
                return
            }
        }
        clearCurrentResults()
    }
    
    func stopSearch() {
        task?.cancel()
        results = []
        updateCloser()
    }
}
