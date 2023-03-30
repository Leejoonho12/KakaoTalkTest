import Foundation
import UIKit

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let imageData = pickedImage.pngData()
            if let myData: Data = imageData{
                let currentDateString = getTime()
                let date: String = getDate()
                setState()
                if contents.last?.myDate != date{
                    contents.append(CellItem(" ", 1, date, currentDateString, name, state, Data(), true, true))
                }
                contents.append(CellItem(" ", 1, date, currentDateString, name, state, myData, false, false))
                tableViewUpDate()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
