import UIKit.UIView

protocol BuildingBlock: Identifiable {
    var id: String { get }
    func scrollable() -> Self
}

extension BuildingBlock {
    func scrollable() -> Self {
        return self
    }
}

protocol BuildingBlockAdapter: AnyObject {
    func build(from items: [(any BuildingBlock)], onCompletion: [(()->Void)?]?) -> [UIView]
}

