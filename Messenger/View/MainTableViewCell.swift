

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    func set(thread: ThreadModel) {
        self.titleLabel.text = thread.partners[0].name
        self.textView.text = thread.lastMessage
        self.timeLabel.text = thread.lastMessageTimeStamp
        self.textView.textColor = UIColor.lightGray
    }
        
}


