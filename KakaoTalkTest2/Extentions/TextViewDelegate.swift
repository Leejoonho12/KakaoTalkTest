import Foundation
import UIKit

extension ViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text: String = textView.text else{ return }
        var space: Bool = false
        _ = text.map{
            if String($0) != " " && String($0) != "\n"{
                 space = true
            }
            return $0
        }
        if text == "" || space == false{
            mySharpButton.isHidden = false
            myUpdateButton.isHidden = true
        }else{
            myUpdateButton.isHidden = false
            mySharpButton.isHidden = true
        }
        
        let contentHeight = textView.contentSize.height
        let lineHeight = textView.font!.lineHeight
        let numberOfLines = Int((contentHeight) / (lineHeight))
        
        if numberOfLines <= 5 {
            myTextViewTop.constant = 2
            myTextViewBottom.constant = 2
            myMiddleCon.constant = myTextView.contentSize.height + 8
            scrollDown()
        } else{
            myTextViewTop.constant = myTextView.font!.lineHeight / 2
            myTextViewBottom.constant = myTextView.font!.lineHeight / 2
        }
    }
}
