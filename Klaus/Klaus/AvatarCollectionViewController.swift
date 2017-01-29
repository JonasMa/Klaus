
import UIKit

private let reuseIdentifier = "AvatarCell"

class AvatarCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var chosenAvatar = ""
    var chooseAvatarLabel: UILabel!;
    var chooseAvatarDescriptionLabel: UILabel!;
    var swipeLabel: UILabel!;
    var pageIndex = 2;
    
    var avatarCollectionView: UICollectionView!
    
    var avatarImages = ["axe", "zange", "alarm", "zange", "zange", "alarm","zange", "alarm","zange", "alarm","zange", "alarm", "zange", "alarm", "zange", "zange", "alarm"]
    
    let avatarsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 110, left: 15.0, bottom: 0.0, right: 15.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.bg;
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        let paddingSpace = sectionInsets.left * (avatarsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / avatarsPerRow
        layout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        
        avatarCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        avatarCollectionView.delegate = self
        avatarCollectionView.dataSource = self
        avatarCollectionView.register(AvatarCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        avatarCollectionView.backgroundColor = Style.bg
        avatarCollectionView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(avatarCollectionView)

        chooseAvatarLabel = UILabel();
        chooseAvatarLabel.text = Strings.chooseAvatarText
        chooseAvatarLabel.textAlignment = .center;
        chooseAvatarLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(chooseAvatarLabel);
        
        chooseAvatarDescriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50));
        chooseAvatarDescriptionLabel.text = Strings.chooseAvatarDescriptionText
        chooseAvatarDescriptionLabel.textAlignment = .center;
        chooseAvatarDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        chooseAvatarDescriptionLabel.numberOfLines = 4
        chooseAvatarDescriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        chooseAvatarLabel.sizeToFit()
        self.view.addSubview(chooseAvatarDescriptionLabel);
        
        swipeLabel = UILabel()
        swipeLabel.text = Strings.tutorialSwipeText
        swipeLabel.textAlignment = .center
        swipeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(swipeLabel)
        
        addConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AvatarCollectionViewCell
    
        let avatar = avatarImages[indexPath.row]
        cell.imageView.image = UIImage(named: avatar)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenAvatar = avatarImages[indexPath.row]
        print(chosenAvatar)
        AppModel.sharedInstance.player.setAvatar(avatar: chosenAvatar)
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return sectionInsets.left
        }
    
    
    func addConstraints(){
        chooseAvatarLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true;
        chooseAvatarLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        
        chooseAvatarDescriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        chooseAvatarDescriptionLabel.centerYAnchor.constraint(equalTo: chooseAvatarLabel.bottomAnchor, constant: 20).isActive = true;
        
        swipeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        swipeLabel.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
        
        avatarCollectionView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        avatarCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        avatarCollectionView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
        avatarCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
    }
}
