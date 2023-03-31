import Foundation
import UIKit

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: false, completion: {
                DispatchQueue.main.async {
                    let imageData = image.jpegData(compressionQuality: 0.1)
                    if let myData: Data = imageData{
                        let currentDateString = self.getTime()
                        let date: String = self.getDate()
                        self.setState()
                        if self.contents.last?.myDate != date{
                            self.contents.append(CellItem(" ", 1, date, currentDateString, self.name, self.state, Data(), true, true))
                        }
                        self.contents.append(CellItem(" ", 1, date, currentDateString, self.name, self.state, myData, false, false))
                        self.tableViewUpDate()
                    }
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
