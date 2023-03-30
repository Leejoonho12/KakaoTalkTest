import Foundation
import UIKit

extension ViewController: UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let chatData = UserDefaults.standard.object(forKey: "chat0") as? Data {
            if let chatObject = try? JSONDecoder().decode([CellItem].self, from: chatData){
                contents = chatObject
            }
        }
        return contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if contents[indexPath.row].isDate{
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? CustomDateCell else { return UITableViewCell() }
            cell3.myCornerView.clipsToBounds = true
            cell3.myCornerView.layer.cornerRadius = cell3.myCornerView.frame.height / 2
            cell3.myDateLabel.text = contents[indexPath.row].myDate
            
            return cell3
        }else if contents[indexPath.row].myName == "리준호"{ //내채팅
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTextCell else { return UITableViewCell() }
            
            //같은시간 채팅은 마지막것만 시간표시
            if indexPath.row != contents.count - 1{
                if contents[indexPath.row + 1].myState == 2{
                    if contents[indexPath.row].myTime == contents[indexPath.row + 1].myTime{
                        cell.myTimeLabel.isHidden = true
                    }else{
                        cell.myTimeLabel.isHidden = false
                    }
                }else{
                    cell.myTimeLabel.isHidden = false
                }
            }else{
                cell.myTimeLabel.isHidden = false
            }
            
            //상대방이 읽었으면 1없애기
            if contents[indexPath.row].mycheckNumber <= 0{
                cell.myCheckLabel.isHidden = true
            } else {
                cell.myCheckLabel.isHidden = false
            }
            
            //이미지인지 텍스트인지 확인
            if contents[indexPath.row].isText{
                cell.myCornerView.isHidden = false
                cell.myPicture.isHidden = true
            }else{
                cell.myCornerView.isHidden = true
                cell.myPicture.isHidden = false
                if let myimage = UIImage(data: contents[indexPath.row].myImage){
                    cell.myPicture.image = myimage
                    let safeareaWidth = view.safeAreaLayoutGuide.layoutFrame.width
                    cell.pictureWidth.constant = safeareaWidth / 100 * 54.133333333333333
                    cell.pictureHeight.constant = myimage.size.height / (myimage.size.width / cell.pictureWidth.constant)
                    cell.myPicture.clipsToBounds = true
                    cell.myPicture.layer.cornerRadius = 10
                }
            }
            cell.myTimeLabel.text = contents[indexPath.row].myTime
            cell.myTimeLabel.textColor = .gray
            cell.myTextLabel.text = contents[indexPath.row].myText
            cell.myCornerView.backgroundColor = .yellow
            cell.myTextLabel.backgroundColor = .yellow
            cell.myTextLabel.textColor = .black
            cell.myCornerView.clipsToBounds = true
            cell.myCornerView.layer.cornerRadius = 10
            
            return cell
        } else if contents[indexPath.row].myName == "이준호"{ //니채팅
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CustomProfileCell else { return UITableViewCell() }
            
            //같은시간 채팅은 마지막것만 시간표시
            if indexPath.row != contents.count - 1{
                if contents[indexPath.row + 1].myState == 4{
                    if contents[indexPath.row].myTime == contents[indexPath.row + 1].myTime{
                        cell2.yourTimeLabel.isHidden = true
                    }else{
                        cell2.yourTimeLabel.isHidden = false
                    }
                }else{
                    cell2.yourTimeLabel.isHidden = false
                }
            }else{
                cell2.yourTimeLabel.isHidden = false
            }
            
            //상대방이 읽었으면 1없애기
            if contents[indexPath.row].mycheckNumber <= 0{
                cell2.myCheckLabel.isHidden = true
            } else {
                cell2.myCheckLabel.isHidden = false
            }
            
            //이미지인지 텍스트인지 확인
            if contents[indexPath.row].isText{
                cell2.yourCornerView.isHidden = false
                cell2.myPicture.isHidden = true
            } else{
                cell2.yourCornerView.isHidden = true
                cell2.myPicture.isHidden = false
                if let myimage = UIImage(data: contents[indexPath.row].myImage){
                    cell2.myPicture.image = myimage
                    let safeareaWidth = view.safeAreaLayoutGuide.layoutFrame.width
                    cell2.pictureWidth.constant = safeareaWidth / 100 * 53.233333333333333 // 아이폰14Pro 에서 이미지뷰width 의 최대값이 SafeArea의 몇%인지 구한 값. 다른 기기에서도 같은 비율로 적용 시키기 위해.
                    cell2.pictureHeight.constant = myimage.size.height / (myimage.size.width / cell2.pictureWidth.constant)
                    cell2.myPicture.clipsToBounds = true
                    cell2.myPicture.layer.cornerRadius = 10
                }
            }
            
            //턴이 넘어오고 첫채팅이 아니면 이름과 프로필사진 히든
            if contents[indexPath.row].myState == 4{
                cell2.myNameLabel.isHidden = true
                cell2.myEmptyLabel.isHidden = false
                cell2.yourImageView.isHidden = true
            }else{
                cell2.myNameLabel.isHidden = false
                cell2.yourImageView.isHidden = false
                cell2.myEmptyLabel.isHidden = true
            }
            cell2.yourTextLabel.text = contents[indexPath.row].myText
            cell2.yourTextLabel.textColor = .white
            cell2.yourImageView.clipsToBounds = true
            cell2.yourImageView.layer.cornerRadius = 20
            cell2.yourCornerView.clipsToBounds = true
            cell2.yourCornerView.layer.cornerRadius = 10
            cell2.yourCornerView.backgroundColor = .gray
            cell2.yourTimeLabel.text = contents[indexPath.row].myTime
            cell2.yourTimeLabel.textColor = .gray
            cell2.yourCornerView.sizeToFit()

            return cell2
        }else{
            return UITableViewCell()
        }
    }
}
