import Foundation
import UIKit

class CustomProfileCell: UITableViewCell{
    
    @IBOutlet weak var yourTextLabel: UILabel!
    
    @IBOutlet weak var yourImageView: UIImageView!
    
    @IBOutlet weak var yourCornerView: UIView!
    
    @IBOutlet weak var yourTimeLabel: UILabel!
    
    @IBOutlet weak var yourTimeWidth: NSLayoutConstraint!
    
    @IBOutlet weak var myCheckLabel: UILabel!
    
    @IBOutlet weak var myNameLabel: UILabel!
    
    @IBOutlet weak var myImageWidth: NSLayoutConstraint!
    
    @IBOutlet weak var myImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var myPicture: UIImageView!
    
    @IBOutlet weak var pictureHeight: NSLayoutConstraint!
    
    @IBOutlet weak var myEmptyLabel: UILabel!
}
