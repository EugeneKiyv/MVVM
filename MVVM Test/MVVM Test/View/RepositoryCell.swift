//
//  RepositoryCell.swift
//  MVVM Test
//
//  Created by Eugene Kuropatenko on 12/09/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

protocol RepositoryCellProtocol {
    var title:String? {get set}
    var descr:String? {get set}
    var stars:Int16? {get set}
}

class RepositoryCell: UITableViewCell, RepositoryCellProtocol {
    var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }
    
    var descr: String? {
        didSet {
            descriptionLabel?.text = descr
        }
    }
    
    var stars: Int16? {
        didSet {
            starLabel?.text = "\(stars ?? 0)"
        }
    }
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var starLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
