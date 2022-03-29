//
//  ButtonsIconList.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 29/03/22.
//

import Foundation
import UIKit

struct VideoButtonIcon{
    let title : String
    let icon : VideoButtonIconEnum
}

protocol ButtonIconListProtocol: AnyObject{
    func didSelectOption(tag : Int)
}

enum VideoButtonIconEnum : String{
    case like = "hand.thumbsup"
    case dislike = "hand.thumbsdown"
    case share = "arrowshape.turn.up.right"
    case download = "arrow.down.to.line.compact"
    case save = "plus.square.on.square"
    case airplay = "airplayaudio"
}

class ButtonsIconList: UIView {
    //MARK: Variables
    private var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    
    private var optionsView : UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.backgroundColor = .clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    weak var delegate : ButtonIconListProtocol?
    var buttonIconsList : [VideoButtonIcon] = []
    
    //MARK: Required Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func buildView(){
        _ = optionsView.arrangedSubviews.map({$0.removeFromSuperview()})
        for (i, button) in buttonIconsList.enumerated(){
            let buttonView = buildButton(buttonObject: button, tag: i)
            optionsView.addArrangedSubview(buttonView)
        }
        scrollView.addSubview(optionsView)
        
        NSLayoutConstraint.activate([
            optionsView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            optionsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            optionsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
    }
    
    private func buildButton(buttonObject: VideoButtonIcon, tag : Int) -> UIView{
        let button = UIButton(type: .custom)
        button.tag = tag
        button.setImage(UIImage(systemName: buttonObject.icon.rawValue), for: .normal)
        button.addTarget(self, action: #selector(didSelectOption(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .whiteColor
        
        let titleLabel = UILabel()
        titleLabel.text = buttonObject.title
        titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        titleLabel.textAlignment = .center
        
        let stackButtons : UIStackView = {
            let stack = UIStackView()
            stack.distribution = .fillProportionally
            stack.axis = .vertical
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(button)
            stack.addArrangedSubview(titleLabel)
            return stack
        }()
        
        NSLayoutConstraint.activate([
            stackButtons.widthAnchor.constraint(equalToConstant: 60.0)
        ])
        return stackButtons
    }
    
    @objc func didSelectOption(_ sender : UIButton){
        delegate?.didSelectOption(tag: sender.tag)
    }
}
