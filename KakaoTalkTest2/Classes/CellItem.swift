import Foundation
import UIKit

class CellItem: Encodable, Decodable{
    
    var myText: String
    
    var mycheckNumber: Int
    
    var myTime: String
    
    var myName: String
    
    var myState: Int
    
    var myImage: Data
    
    var isText: Bool
    
    init(_ text: String, _ num: Int, _ time: String, _ name: String, _ state: Int, _ image: Data, _ istext: Bool){
        self.myText = text
        self.mycheckNumber = num
        self.myTime = time
        self.myName = name
        self.myState = state
        self.myImage = image
        self.isText = istext
    }
}
