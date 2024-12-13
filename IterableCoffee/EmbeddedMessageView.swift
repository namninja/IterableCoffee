import UIKit
import IterableSDK

class EmbeddedMessageView: UIView {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let actionButton = UIButton()

    var message: IterableEmbeddedMessage? {
        didSet {
            updateView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.backgroundColor = .white

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(bodyLabel)
        addSubview(actionButton)

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        bodyLabel.font = UIFont.systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        actionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            // Button constraints
            actionButton.topAnchor.constraint(greaterThanOrEqualTo: bodyLabel.bottomAnchor, constant: 8),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    private func updateView() {
        guard let message = message else { return }

        titleLabel.text = message.elements?.title
        bodyLabel.text = message.elements?.body

        if let mediaUrl = message.elements?.mediaUrl {
            if let url = URL(string: mediaUrl) {
                let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                    guard let self = self, let data = data else { return }
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }

        // Button configuration
        if let button = message.elements?.buttons?.first {
            actionButton.isHidden = false
            var config = UIButton.Configuration.plain()
            config.baseBackgroundColor = .systemPink
            config.title = button.title ?? "Info"
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)

            actionButton.configuration = config
            actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        } else {
            actionButton.isHidden = true
        }
    }

    @objc private func buttonTapped() {
        guard let buttonAction = message?.elements?.buttons?.first?.action, buttonAction.type == "openUrl", let urlString = buttonAction.data, let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}
