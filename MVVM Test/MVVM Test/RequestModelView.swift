//
//  RequestModelView.swift
//  MVVM Test
//
//  Created by Eugene Kuropatenko on 12/09/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation

protocol RequestView: class {
    func beginUpdates()
    func endUpdates()
    func update(type:RequestDataProvider.RequestViewModelChages, indexPath:IndexPath)
}

protocol RequestViewModel: class {
    init(_ delegate:RequestView)
    var requestCount:Int {get}
    func requestFor(index:Int) -> RequestModel
    func deleteRequest(request:RequestModel)
    
}

