
import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: frame.size.height/5, width: frame.size.width , height: frame.size.width*2/5));
        imageView.contentMode = UIViewContentMode.scaleAspectFit;
        imageView.tintColor = Style.primaryTextColor;
        contentView.addSubview(imageView);
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
