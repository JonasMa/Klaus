
import Foundation
import UIKit

class SeitenschneiderItem: Item {
    
    private static let IMAGE_NAME = "Zange";
    
    override init(id: String, displayName: String, pointsPerSecond: Int, dateOfAcquisition: Date, level: Int){
        super.init(id: id, displayName: displayName, pointsPerSecond: pointsPerSecond, dateOfAcquisition: dateOfAcquisition, level: level);
        self.imageName = SeitenschneiderItem.IMAGE_NAME;
        itemType = Item.TYPE_SEITENSCHNEIDER
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.imageName = SeitenschneiderItem.IMAGE_NAME;
        itemType = Item.TYPE_SEITENSCHNEIDER
    }
    
    override func getGameExplanation() -> String{
        return Strings.seitenschneiderExplanation;
    }
    
    override func getAssociatedGameViewController() -> UIViewController {
        return SeitenschneiderViewController(nibName: "SeitenschneiderViewController", bundle: nil) as UIViewController;
    }
    
    static func initNewItem() -> Item{
        return SeitenschneiderItem(id: Item.newId(), displayName: "Seitenschneider", pointsPerSecond: 2, dateOfAcquisition: Date(), level: 1);
    }
}
