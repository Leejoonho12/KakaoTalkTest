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
    
    var maxTextHeight: CGFloat = 0
    
    var contents: [CellItem] = [
        MyCustomCellItem(myText: "hello", mycheckNumber: 1, myTime: "11 : 09"),
        MyCustomCellItem(myText: "my", mycheckNumber: 1, myTime: "11 : 09"),
        MyCustomCellItem(myText: "name", mycheckNumber: 1, myTime: "11 : 09"),
        MyCustomCellItem(myText: "is", mycheckNumber: 1, myTime: "11 : 09"),
        MyCustomCellItem(myText: "lee", mycheckNumber: 1, myTime: "11 : 09"),
        MyCustomCellItem(myText: "joon", mycheckNumber: 1, myTime: "11 : 10"),
        MyCustomCellItem(myText: "ho", mycheckNumber: 1, myTime: "11 : 10"),
        MyCustomCellItem(myText: "what", mycheckNumber: 1, myTime: "11 : 25"),
        MyCustomCellItem(myText: "your", mycheckNumber: 1, myTime: "11 : 25"),
        MyCustomCellItem(myText: "name", mycheckNumber: 1, myTime: "11 : 25"),
        MyCustomCellItem(myText: "how", mycheckNumber: 1, myTime: "11 : 26"),
        MyCustomCellItem(myText: "are", mycheckNumber: 1, myTime: "11 : 27"),
        MyCustomCellItem(myText: "you", mycheckNumber: 1, myTime: "11 : 27"),
        MyCustomCellItem(myText: "I", mycheckNumber: 1, myTime: "11 : 41"),
        MyCustomCellItem(myText: "am", mycheckNumber: 1, myTime: "11 : 41"),
        MyCustomCellItem(myText: "fine", mycheckNumber: 1, myTime: "11 : 41"),
        MyCustomCellItem(myText: "thank", mycheckNumber: 1, myTime: "11 : 41"),
        MyCustomCellItem(myText: "you", mycheckNumber: 1, myTime: "11 : 41"),
        MyCustomCellItem(myText: "and", mycheckNumber: 1, myTime: "11 : 42"),
        MyCustomCellItem(myText: "you", mycheckNumber: 1, myTime: "11 : 42"),
        MyCustomCellItem(myText: "listen", mycheckNumber: 1, myTime: "12 : 01"),
        MyCustomCellItem(myText: "to", mycheckNumber: 1, myTime: "12 : 01"),
        MyCustomCellItem(myText: "my", mycheckNumber: 1, myTime: "12 : 01"),
        MyCustomCellItem(myText: "heart", mycheckNumber: 1, myTime: "12 : 01"),
        MyCustomCellItem(myText: "beat", mycheckNumber: 1, myTime: "12 : 01"),
        MyCustomCellItem(myText: "wow", mycheckNumber: 1, myTime: "12 : 39"),
        YourCustomCellItem(myText: "testtext\ntesttext", mycheckNumber: 1, myTime: "13 : 45", myName: "이준호")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetting()
        addObservers()
        
        middleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        DispatchQueue.main.asyncAfter(deadline:  .now() + 0.1, execute: { self.scrollDown() })
    }
    
    @IBAction func addChat(_ sender: Any) {
        guard let content: String = myTextView.text else{ return }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH : mm"
        let currentDateString = formatter.string(from: Date())
        contents.append(MyCustomCellItem(myText: content, mycheckNumber: 1, myTime: currentDateString))
        myTableView.reloadData()
        myTextView.text = ""
        textViewDidChange(myTextView)
//        showAnimation(0)
//        self.view.endEditing(true)
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
        contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((contents[indexPath.row] as? MyCustomCellItem) != nil){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTextCell else { return UITableViewCell() }
            cell.myTimeLabel.text = contents[indexPath.row].myTime
            if indexPath.row != contents.count - 1{
                if contents[indexPath.row].myTime == contents[indexPath.row + 1].myTime{
                    cell.myTimeLabel.isHidden = true
                } else{
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
            return cell
        } else if ((contents[indexPath.row] as? YourCustomCellItem) != nil){
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CustomProfileCell else { return UITableViewCell() }
            cell2.yourTextLabel.text = contents[indexPath.row].myText
            cell2.yourTextLabel.textColor = .white
            cell2.yourImageView.clipsToBounds = true
            cell2.yourImageView.layer.cornerRadius = 25
            cell2.yourCornerView.clipsToBounds = true
            cell2.yourCornerView.layer.cornerRadius = 10
            cell2.yourCornerView.backgroundColor = .gray
            cell2.yourTimeLabel.text = contents[indexPath.row].myTime
            cell2.yourTimeLabel.textColor = .gray
            return cell2
        }else{
            return UITableViewCell()
        }
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTextCell else { return UITableViewCell() }
//        cell.myTimeLabel.text = contents[indexPath.row].myTime
//        if indexPath.row != contents.count - 1{
//            if contents[indexPath.row].myTime == contents[indexPath.row + 1].myTime{
//                cell.myTimeLabel.isHidden = true
//            } else{
//                cell.myTimeLabel.isHidden = false
//            }
//        }else{
//            cell.myTimeLabel.isHidden = false
//        }
//        let textWidth = cell.myTimeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: cell.myTimeLabel.frame.size.height)).width
//        cell.myTimeWidth.constant = textWidth
//        cell.myTimeLabel.textColor = .gray
//        cell.myTextLabel.text = contents[indexPath.row].myText
//        cell.myCornerView.backgroundColor = .yellow
//        cell.myTextLabel.backgroundColor = .yellow
//        cell.myTextLabel.textColor = .black
//        cell.myCornerView.clipsToBounds = true
//        cell.myCornerView.layer.cornerRadius = 10
//        return cell
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
}

class CustomProfileCell: UITableViewCell{
    
    @IBOutlet weak var yourTextLabel: UILabel!
    
    @IBOutlet weak var yourImageView: UIImageView!
    
    @IBOutlet weak var yourCornerView: UIView!
    
    @IBOutlet weak var yourTimeLabel: UILabel!
    
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

protocol CellItem{
    var myText: String { get set }
    var mycheckNumber: Int { get set }
    var myTime: String { get set }
}

struct MyCustomCellItem: CellItem{
    var myText: String
    var mycheckNumber: Int
    var myTime: String
}

struct YourCustomCellItem: CellItem{
    var myText: String
    var mycheckNumber: Int
    var myTime: String
    var myName: String
}
