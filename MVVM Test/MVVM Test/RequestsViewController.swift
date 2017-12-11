//
//  RequestsViewController.swift
//  MVVM Test
//
//  Created by Eugene Kuropatenko on 12/09/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController {
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet var blockView: UIView!
    
    public var selectCompletion:((_ request:RequestModel)->())?
    
    let dateFormatter:DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    var dataProvider:RequestViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider = RequestDataProvider(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RequestsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dataProvider?.requestCount ?? 0
        if count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView = blockView
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let request = dataProvider.requestFor(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath)
        cell.detailTextLabel?.text = dateFormatter.string(from: request.date! as Date)
        cell.textLabel?.text = request.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = dataProvider.requestFor(index: indexPath.row)
        selectCompletion?(request)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let request = dataProvider.requestFor(index: indexPath.row)
            dataProvider.deleteRequest(request: request)
        }
    }
}

extension RequestsViewController: RequestView {
    func update(type: RequestDataProvider.RequestViewModelChages, indexPath: IndexPath) {
        switch type {
        case .insert:
            mainTable.insertRows(at: [indexPath], with: .bottom)
        case .delete:
            mainTable.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    func beginUpdates() {
        mainTable.beginUpdates()
    }
    
    func endUpdates() {
        mainTable.endUpdates()
    }

}
