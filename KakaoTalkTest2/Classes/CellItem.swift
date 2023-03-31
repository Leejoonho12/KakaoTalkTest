import Foundation
import UIKit

class CellItem: Codable{
    
    var myText: String
    
    var mycheckNumber: Int
    
    var myDate: String
    
    var myTime: String
    
    var myName: String
    
    var myState: sequenceState
    
    var myImage: Data
    
    var isText: Bool
    
    var isDate: Bool
    
    init(_ text: String, _ num: Int, _ date: String, _ time: String, _ name: String, _ state: sequenceState, _ image: Data, _ istext: Bool, _ isdate: Bool){
        self.myText = text
        self.mycheckNumber = num
        self.myDate = date
        self.myTime = time
        self.myName = name
        self.myState = state
        self.myImage = image
        self.isText = istext
        self.isDate = isdate
    }
}
