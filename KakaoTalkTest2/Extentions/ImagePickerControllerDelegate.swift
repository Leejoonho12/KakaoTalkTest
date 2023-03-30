import Foundation
import UIKit

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let imageData = pickedImage.pngData()
            if let myData = imageData as? Data{
                let formatter = DateFormatter()
                formatter.dateFormat = "HH : mm"
                let currentDateString = formatter.string(from: Date())
                setState()
                contents.append(CellItem(" ", 1, currentDateString, name, state, myData, false))
                tableViewUpDate()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
