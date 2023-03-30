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
    
    @IBOutlet weak var myFindTextField: UITextField!
    
    var name: String = "리준호"
    
    var state: Int = 0
    
    let imagePicker = UIImagePickerController()
    
    var findNumber: Int = 0
    
    var findLength: Int = 0
    
    var contents: [CellItem] = [
        CellItem(" ", 0, "2023년 03월 29일 수요일", "11 : 09", "리준호", 1, Data(), true, true),
        CellItem("hello", 0, "2023년 03월 29일 수요일", "11 : 09", "리준호", 1, Data(), true, false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetting()
        addObservers()
        atherSetting()
        //UserDefaults.standard.removeObject(forKey: "chat0")
        chatDataSetting()
        
    }
    
    @IBAction
    func findString(_ sender: Any) {
        var row: [Int] = []
        guard let text: String = myFindTextField.text else { return }
        for num in 0..<contents.count{
            if contents[num].myText.contains(text){
                row.append(num)
            }
        }
        if row.count > 0{
            let indexPath = IndexPath(row: row[findNumber], section: 0)
            myTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
        findNumber = findNumber == (findLength - 1) ? 0 : findNumber + 1
    }
    
    @IBAction
    func imagePick(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction
    func turnChange(_ sender: Any) {
        if name == "리준호"{
            name = "이준호"
            myChangeButton.backgroundColor = .yellow
        }else if name == "이준호"{
            name = "리준호"
            myChangeButton.backgroundColor = .gray
        }
    }
    
    @IBAction
    func addChat(_ sender: Any) {
        guard let content: String = myTextView.text else{ return }
        let currentDateString = getTime()
        let date: String = getDate()
        setState()
        if contents.last?.myDate != date{
            print("날짜바뀜")
            contents.append(CellItem(" ", 1, date, currentDateString, name, state, Data(), true, true))
            print("날짜변경추가")
        }
        contents.append(CellItem(content, 1, date, currentDateString, name, state, Data(), true, false))
        tableViewUpDate()
    }
    
    func chatDataSetting(){
        if let chatData = UserDefaults.standard.object(forKey: "chat0") as? Data {
            if let chatObject = try? JSONDecoder().decode([CellItem].self, from: chatData){
                contents = chatObject
            }
        }
    }
    
    func getTime() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH : mm"
        return formatter.string(from: Date())
    }
    
    func getDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 "
        var date: String = formatter.string(from: Date())
        formatter.dateFormat = "EEEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        date += "\(formatter.string(from: Date()))요일"
        return date
    }
    
    func scrollDown(){
        DispatchQueue.main.async {
            let lastSection = self.myTableView.numberOfSections - 1
            let lastRowInLastSection = self.myTableView.numberOfRows(inSection: lastSection) - 1
            let indexPath = IndexPath(row: lastRowInLastSection, section: lastSection)
            if self.contents.count > 0{
                self.myTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func tableViewUpDate(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(contents){
            UserDefaults.standard.setValue(encoded, forKey: "chat0")
        }
        myTableView.reloadData()
        myTextView.text = ""
        textViewDidChange(myTextView)
        myUpdateButton.isHidden = true
        mySharpButton.isHidden = false
        scrollDown()
    }
    
    func setState(){
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
        })
    }
    
    private func atherSetting(){
        myFindTextField.addTarget(self, action: #selector(textFildDidChange(_:)), for: .editingChanged)
        middleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        DispatchQueue.main.asyncAfter(deadline:  .now() + 0.1, execute: { self.scrollDown() })
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        myTableView.dataSource = self
    }
    
    @objc
    func textFildDidChange(_ textField: UITextField){
        if let inputText = textField.text {
            findNumber = 0
            findLength = contents.filter{$0.myText.contains(inputText)}.count
        }
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
