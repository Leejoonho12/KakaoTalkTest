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
    
    var maxTextHeight: CGFloat = 0
    
    var chatContents: [String] = ["hello", "my", "name", "is", "l", "e", "e", "j", "o", "o", "n", "h", "o", "my", "name", "is", "l", "e", "e", "j", "o", "o", "n", "h", "o", "가나다라마바사아자차카타파하 이건 긴 텍스트를 출력하는 테스트 입니다. 텍스트의 길이에 따라 라벨의 크기가 바뀌어야 합니다. 그리고 더 늘어나야 하는데 왜 안늘어나는지 알 수가 없네요 진짜 개빡치네 아아아아아아아아아아아앙 왜이래","dajshfakjfgbiuafbgidlfbkjvbdfjnaoifjbanefkjblsdkjfbnjsfbnifjbnvlskfjnbsiojbaoijfbnvlijdfbnvksjdfbnksjfdnbvlisdjfnbiajnbfoindfblkvjadnfsijsndfklvjdfn!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetting()
        addObservers()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        DispatchQueue.main.asyncAfter(deadline:  .now() + 0.1, execute: { self.scrollDown() })
    }
    
    @IBAction func addChat(_ sender: Any) {
        guard let content: String = myTextView.text else{ return }
        chatContents.append(content)
        myTableView.reloadData()
        myTextView.text = ""
        textViewDidChange(myTextView)
        showAnimation(0)
        self.view.endEditing(true)
        myUpdateButton.isHidden = true
        mySharpButton.isHidden = false
        DispatchQueue.main.asyncAfter(deadline:  .now() + 0.1, execute: { self.scrollDown() })
    }
    
    private func scrollDown(){
        let bottomOffset = CGPoint(x: 0, y: myTableView.contentSize.height - myTableView.bounds.height)
        myTableView.setContentOffset(bottomOffset, animated: false)
    }
    
    private func UISetting(){
        myTextView.delegate = self
        myChatView.clipsToBounds = true
        myChatView.layer.cornerRadius = myChatView.frame.size.height / 2
        myUpdateButton.isHidden = true
        myTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        
        showAnimation(adjustmentHeight)
    }

    @objc
    func keyboardWillDisappear(noti: NSNotification){
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
        chatContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTextCell else { return UITableViewCell() }
        cell.myTextLabel.text = chatContents[indexPath.row]
        cell.myTextLabel.backgroundColor = .yellow
        cell.myTextLabel.textColor = .black
        cell.myTextLabel.clipsToBounds = true
        cell.myTextLabel.layer.cornerRadius = 10
        cell.myTextLabel.insets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        
        return cell
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
        print(numberOfLines)
        
        if numberOfLines <= 5 {
            if numberOfLines == 1{
                myTextViewBottom.constant = 2
//                myMiddleCon.constant = resultHeight + 1
            }
            else{
                myTextViewBottom.constant = 2
//                myMiddleCon.constant = resultHeight + 1
            }
            myTextViewTop.constant = 2
            myTextViewBottom.constant = 2
            myMiddleCon.constant = myTextView.contentSize.height + 8
        } else{
            myTextViewTop.constant = myTextView.font!.lineHeight / 2
            myTextViewBottom.constant = myTextView.font!.lineHeight / 2
        }
    }
}

class CustomTextCell: UITableViewCell{
    @IBOutlet weak var myTextLabel: PaddingLabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 15))
    }
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

