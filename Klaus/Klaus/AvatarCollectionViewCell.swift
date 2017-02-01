
import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: frame.size.width*0.05, y: frame.size.height*0.05, width: frame.size.width * 0.9 , height: frame.size.width * 0.9));
        imageView.contentMode = UIViewContentMode.scaleAspectFit;
        imageView.tintColor = Style.primaryTextColor;
        contentView.addSubview(imageView);
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
