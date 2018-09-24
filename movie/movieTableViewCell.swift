//
//  movieTableViewCell.swift
//  movie
//
//  Created by Qing Ran on 9/17/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit

class movieTableViewCell: UITableViewCell {

   
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDetail: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
   
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var movieRelease: UILabel!
    
    @IBOutlet weak var movieVote: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
