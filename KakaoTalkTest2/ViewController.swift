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
    
    var maxTextHeight: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetting()
        addObservers()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func UISetting(){
        myTextView.delegate = self
        maxTextHeight = 5 * myTextView.font!.lineHeight + 16 //- 0.212890625
        print(myTextView.font!.lineHeight)
        myMiddleCon.constant = myTextView.font!.lineHeight + 18 // 텍스트뷰의 마진, 패딩 = 16
        myChatView.frame.size.height = myTextView.font!.lineHeight + 16 // 텍스트뷰의 패딩 = 8
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
            self.view.transform = CGAffineTransform(translationX: 0, y: -height)
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

extension ViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text: String = textView.text else{ return }
        var space: Bool = false
        var arr = text.map{
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
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        let clNum = (myTextView.text as NSString).substring(to: myTextView.selectedRange.location).components(separatedBy: .newlines).count
        let height = newSize.height//- 16.212890625
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: min(height, maxTextHeight))
        textView.frame = newFrame
        myTextView.frame = newFrame
        myChatView.frame.size = CGSize(width: myChatView.frame.size.width, height: myTextView.frame.size.height) // +16
        bottomView.frame.size = CGSize(width: bottomView.frame.size.width, height: myChatView.frame.size.height) // + 4
        myMiddleCon.constant = bottomView.frame.size.height
        print(myTextView.frame.size.height)
        print(myChatView.frame.size.height)
        print(bottomView.frame.size.height)
        print(myMiddleCon.constant)
        print(clNum)
    }
}

