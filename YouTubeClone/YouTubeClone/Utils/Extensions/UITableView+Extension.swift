//
//  UITableView+Extension.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 18/03/22.
//

import Foundation
import UIKit

extension UITableView {
    //In order to register a cell, its identifier must be the same as className
    public func register<T: UITableViewCell>(cell: T.Type) {
        register(UINib(nibName: "\(T.self)", bundle: nil), forCellReuseIdentifier: "\(T.self)")
    }
    
    //In order to register a headerFooterView, its identifier must be the same as className
    public func register<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) {
        register(UINib(nibName: "\(T.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(T.self)")
    }
    
    public func registerFromClass<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: "\(T.self)")
        
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(for type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else {
            fatalError("Failed to dequeue cell.")
        }
        return cell
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(for type: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: "\(T.self)") as? T else {
            fatalError("Failed to dequeue footer view.")
        }
        return view
    }
}
