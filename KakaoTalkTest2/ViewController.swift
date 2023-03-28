import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var myChatView: UIView!
    
    @IBOutlet weak var mySharpButton: UIButton!
    
    @IBOutlet weak var myUpdateButton: UIButton!
    
    @IBOutlet weak var myMiddleCon: NSLayoutConstraint!
    
    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var textViewCon: NSLayoutConstraint!
    
    @IBOutlet weak var myTextViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var myTextViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var myMiddleTop: NSLayoutConstraint!
    
    @IBOutlet weak var myChangeButton: UIButton!
    
    var maxTextHeight: CGFloat = 0
    
    var name: String = "리준호"
    
    var state: Int = 0
    
    var contents: [CellItem] = [
        CellItem("hello", 0, "11 : 09", "리준호", 1),
        CellItem("my", 0, "11 : 09", "리준호", 2),
        CellItem("name", 0, "11 : 09", "리준호", 2),
        CellItem("is", 0, "11 : 09", "리준호", 2),
        CellItem("lee", 0, "11 : 09", "리준호", 2),
        CellItem("joon", 0, "11 : 10", "리준호", 2),
        CellItem("ho", 0, "11 : 10", "리준호", 2),
        CellItem("what", 0, "11 : 25", "리준호", 2),
        CellItem("your", 0, "11 : 25", "리준호", 2),
        CellItem("name", 0, "11 : 25", "리준호", 2),
        CellItem("how", 0, "11 : 26", "리준호", 2),
        CellItem("are", 0, "11 : 27", "리준호", 2),
        CellItem("you", 0, "11 : 27", "리준호", 2),
        CellItem("I", 0, "11 : 41", "리준호", 2),
        CellItem("am", 0, "11 : 41", "리준호", 2),
        CellItem("fine", 0, "11 : 41", "리준호", 2),
        CellItem("thank", 0, "11 : 41", "리준호", 2),
        CellItem("you", 0, "11 : 41", "리준호", 2),
        CellItem("and", 0, "11 : 42", "리준호", 2),
        CellItem("you", 0, "11 : 42", "리준호", 2),
        CellItem("listen", 0, "12 : 01", "리준호", 2),
        CellItem("to", 0, "12 : 01", "리준호", 2),
        CellItem("my", 0, "12 : 01", "리준호", 2),
        CellItem("heart", 0, "12 : 01", "리준호", 2),
        CellItem("beat", 0, "12 : 01", "리준호", 2),
        CellItem("wow", 0, "12 : 39", "리준호", 2),
        CellItem("testtext\ntesttext\ntesttext\ntesttext\ntesttext\ntesttext", 1, "13 : 45", "이준호", 3)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetting()
        addObservers()
        
        middleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        DispatchQueue.main.asyncAfter(deadline:  .now() + 0.1, execute: { self.scrollDown() })
    }
    
    @IBAction func turnChange(_ sender: Any) {
        if name == "리준호"{
            name = "이준호"
            myChangeButton.backgroundColor = .yellow
        }else if name == "이준호"{
            name = "리준호"
            myChangeButton.backgroundColor = .gray
        }
    }
    
    @IBAction func addChat(_ sender: Any) {
        guard let content: String = myTextView.text else{ return }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH : mm"
        let currentDateString = formatter.string(from: Date())
        if name == "리준호"{
            if contents.last?.myState == 3 || contents.last?.myState == 4{
                state = 1
                for seq in 0...(contents.count - 1){
                    contents[seq].mycheckNumber -= 1
                }
            } else if contents.last?.myState == 1{
                state = 2
            } else {
                state = 2
            }
        } else if name == "이준호"{
            if contents.last?.myState == 1 || contents.last?.myState == 2{
                state = 3
                for seq in 0...(contents.count - 1){
                    contents[seq].mycheckNumber -= 1
                }
            } else if contents.last?.myState == 3{
                state = 4
            } else {
                state = 4
            }
        }
        contents.append(CellItem(content, 1, currentDateString, name, state))
//        if name == "리준호"{
//            who = .myturn
//        }else if name == "이준호"{
//            who = .yourturn
//        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(contents){
            UserDefaults.standard.setValue(encoded, forKey: "chat6")
        }
        myTableView.reloadData()
        myTextView.text = ""
        textViewDidChange(myTextView)
        myUpdateButton.isHidden = true
        mySharpButton.isHidden = false
        scrollDown()
    }
    
    private func scrollDown(){
        DispatchQueue.main.async {
            let lastSection = self.myTableView.numberOfSections - 1
            let lastRowInLastSection = self.myTableView.numberOfRows(inSection: lastSection) - 1
            let indexPath = IndexPath(row: lastRowInLastSection, section: lastSection)
            self.myTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    private func UISetting(){
        myTextView.delegate = self
        myChatView.clipsToBounds = true
        myChatView.layer.cornerRadius = myChatView.frame.size.height / 2
        myUpdateButton.isHidden = true
        myChangeButton.backgroundColor = .gray
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func showAnimation(_ height: CGFloat){
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: -height)
            self.middleView.transform = CGAffineTransform(translationX: 0, y: -height)
            // 바텀뷰만 움직이고 테이블뷰는 크기가 줄어들어야 한다.
        })
    }
    
    @objc
    func keyboardWillAppear(noti: NSNotification){
        guard let userInfo = noti.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              case let adjustmentHeight = keyboardFrame.height - self.view.safeAreaInsets.bottom
        else { return }
        myTableView.contentInset.top = adjustmentHeight
        myTableView.verticalScrollIndicatorInsets.top = adjustmentHeight
        showAnimation(adjustmentHeight)
    }

    @objc
    func keyboardWillDisappear(noti: NSNotification){
        myTableView.contentInset.top = 0
        myTableView.verticalScrollIndicatorInsets.top = 0
        showAnimation(0)
    }
    
    @objc
    func handleTap(sender: UITapGestureRecognizer){
        if sender.state == .ended {
            self.view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }

}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let chatData = UserDefaults.standard.object(forKey: "chat6") as? Data {
            if let chatObject = try? JSONDecoder().decode([CellItem].self, from: chatData){
                contents = chatObject
            }
        }
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if contents[indexPath.row].myName == "리준호"{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTextCell else { return UITableViewCell() }
            cell.myTimeLabel.text = contents[indexPath.row].myTime
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
            let textWidth = cell.myTimeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: cell.myTimeLabel.frame.size.height)).width
            cell.myTimeWidth.constant = textWidth
            cell.myTimeLabel.textColor = .gray
            cell.myTextLabel.text = contents[indexPath.row].myText
            cell.myCornerView.backgroundColor = .yellow
            cell.myTextLabel.backgroundColor = .yellow
            cell.myTextLabel.textColor = .black
            cell.myCornerView.clipsToBounds = true
            cell.myCornerView.layer.cornerRadius = 10
            if contents[indexPath.row].mycheckNumber <= 0{
                cell.myCheckLabel.isHidden = true
            } else {
                cell.myCheckLabel.isHidden = false
            }
            return cell
        } else if contents[indexPath.row].myName == "이준호"{
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CustomProfileCell else { return UITableViewCell() }
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
            cell2.yourTextLabel.text = contents[indexPath.row].myText
            cell2.yourTextLabel.textColor = .white
            cell2.yourImageView.clipsToBounds = true
            cell2.yourImageView.layer.cornerRadius = 20
            cell2.yourCornerView.clipsToBounds = true
            cell2.yourCornerView.layer.cornerRadius = 10
            cell2.yourCornerView.backgroundColor = .gray
            cell2.yourTimeLabel.text = contents[indexPath.row].myTime
            cell2.yourTimeLabel.textColor = .gray
            let textWidth = cell2.yourTimeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: cell2.yourTimeLabel.frame.size.height)).width
            cell2.yourTimeWidth.constant = textWidth
            if contents[indexPath.row].mycheckNumber <= 0{
                cell2.myCheckLabel.isHidden = true
            } else {
                cell2.myCheckLabel.isHidden = false
            }
            if contents[indexPath.row].myState == 4{
                cell2.yourImageView.image = .none
                cell2.myNameLabel.isHidden = true
                cell2.myImageHeight.constant = 30
            }else{
                cell2.myNameLabel.isHidden = false
                cell2.yourImageView.image = UIImage(named: "태연")
                cell2.myImageHeight.constant = 50
            }
            return cell2
        }else{
            return UITableViewCell()
        }
    }
}

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
        if text == ""{
            mySharpButton.isHidden = false
            myUpdateButton.isHidden = true
        }else if space == false{
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

class CustomTextCell: UITableViewCell{
    @IBOutlet weak var myTextLabel: PaddingLabel!
    
    @IBOutlet weak var myTextArea: UIStackView!
    
    @IBOutlet weak var myTimeLabel: UILabel!
    
    @IBOutlet weak var myCornerView: UIView!
    
    @IBOutlet weak var myTimeWidth: NSLayoutConstraint!
    
    @IBOutlet weak var myCheckLabel: UILabel!
}

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
}

class PaddingLabel: UILabel{
    var insets: UIEdgeInsets = .zero

        override func drawText(in rect: CGRect) {
            let insetsRect = rect.inset(by: insets)
            super.drawText(in: insetsRect)
        }

        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + insets.left + insets.right,
                          height: size.height + insets.top + insets.bottom)
        }
}

class CellItem: Encodable, Decodable{
    
    var myText: String
    
    var mycheckNumber: Int
    
    var myTime: String
    
    var myName: String
    
    var myState: Int
    
    init(_ text: String, _ num: Int, _ time: String, _ name: String, _ state: Int){
        self.myText = text
        self.mycheckNumber = num
        self.myTime = time
        self.myName = name
        self.myState = state
    }
}
