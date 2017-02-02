
import Foundation
import UIKit

class SeitenschneiderItem: Item {
    
    private static let IMAGE_NAME = "Zange";

    override init(id: String, displayName: String, pointsPerSecond: Int, dateOfAcquisition: Date, level: Int, itemColor: UIColor){
        super.init(id: id, displayName: displayName, pointsPerSecond: pointsPerSecond, dateOfAcquisition: dateOfAcquisition, level: level, itemColor: itemColor);
        self.imageName = SeitenschneiderItem.IMAGE_NAME;
        self.itemType = Item.TYPE_SEITENSCHNEIDER
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.imageName = SeitenschneiderItem.IMAGE_NAME;
        self.itemType = Item.TYPE_SEITENSCHNEIDER
    }
    
    override func getGameExplanation() -> String{
        return Strings.seitenschneiderExplanation;
    }
    
    override func getAssociatedGameViewController() -> UIViewController {
        return SeitenschneiderViewController(nibName: "SeitenschneiderViewController", bundle: nil) as UIViewController;
    }
    
    static func initNewItem() -> Item{
        return SeitenschneiderItem(id: Item.newId(), displayName: "Zange", pointsPerSecond: Config.seitenschneidBasePointsPerSecond, dateOfAcquisition: Date(), level: 1, itemColor: Item.getRandomItemColor());
    }
    
    override func getInfoString() -> String{
        return Strings.seitenschneiderInfo;
    }
}
