import Foundation
import UIKit

class CustomTextCell: UITableViewCell{
    @IBOutlet weak var myTextLabel: UILabel!
    
    @IBOutlet weak var myTextArea: UIStackView!
    
    @IBOutlet weak var myTimeLabel: UILabel!
    
    @IBOutlet weak var myCornerView: UIView!
    
    @IBOutlet weak var myTimeWidth: NSLayoutConstraint!
    
    @IBOutlet weak var myCheckLabel: UILabel!
    
    @IBOutlet weak var myPicture: UIImageView!
    
    @IBOutlet weak var pictureHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pictureWidth: NSLayoutConstraint!
}
