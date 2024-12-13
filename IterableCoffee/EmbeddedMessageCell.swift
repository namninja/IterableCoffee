import UIKit
import IterableSDK

class EmbeddedMessageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var bodyLabel: UILabel!
    
    // Configure the cell with message data
    func configure(with message: IterableEmbeddedMessage) {
        titleLabel.text = message.elements?.title
        bodyLabel.text = message.elements?.body

        if let mediaUrl = message.elements?.mediaUrl, let url = URL(string: mediaUrl) {
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
