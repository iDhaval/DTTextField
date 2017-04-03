//
//  DTTextField.swift
//  Pods
//
//  Created by Dhaval Thanki on 03/04/17.
//
//

import Foundation
import UIKit

public extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
}

public class DTTextField: UITextField {
    
    fileprivate var lblFloatPlaceholder:UILabel = UILabel()
    fileprivate var lblError:UILabel            = UILabel()
    
    fileprivate let paddingX:CGFloat                        = 5.0
    fileprivate let floatingLabelShowAnimationDuration      = 0.3
    
    public var dtLayer:CALayer                         = CALayer()
    public var floatPlaceholderColor:UIColor           = UIColor.black
    public var floatPlaceholderActiveColor:UIColor     = UIColor.black
    
    public var errorMessage:String = ""{
        didSet{ lblError.text = errorMessage }
    }
    
    public var errorFont = UIFont.systemFont(ofSize: 10.0){
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var floatPlaceholderFont = UIFont.systemFont(ofSize: 10.0){
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var paddingYFloatLabel:CGFloat = 3.0{
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var paddingYErrorLabel:CGFloat = 3.0{
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var borderColor:UIColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0){
        didSet{ dtLayer.borderColor = borderColor.cgColor }
    }
    
    public var canShowBorder:Bool = true{
        didSet{ dtLayer.isHidden = !canShowBorder }
    }
    
    public var placeholderColor:UIColor?{
        didSet{
            guard let color = placeholderColor else { return }
            attributedPlaceholder = NSAttributedString(string: placeholderFinal,
                                                       attributes: [NSForegroundColorAttributeName:color])
        }
    }
    
    fileprivate var x:CGFloat {
        
        if let leftView = leftView {
            return leftView.frame.origin.x + leftView.bounds.size.width + paddingX
        }
        
        return paddingX
    }
    
    fileprivate var floatLabelWidth:CGFloat{
        
        var width = bounds.size.width
        
        if let leftViewWidth = leftView?.bounds.size.width{
            width -= leftViewWidth
        }
        
        if let rightViewWidth = rightView?.bounds.size.width {
            width -= rightViewWidth
        }
        
        return width - (self.x * 2)
    }
    
    fileprivate var floatLabelHeight:CGFloat{
        return lblFloatPlaceholder.text!.heightWithConstrainedWidth(width: floatLabelWidth, font: floatPlaceholderFont)
    }
    
    fileprivate var placeholderFinal:String{
        if let attributed = attributedPlaceholder { return attributed.string }
        return placeholder ?? " "
    }
    
    fileprivate var isFloatLabelShowing:Bool = false
    
    public var showError:Bool = false{
        didSet{
            
            guard showError else {
                hideErrorMessage()
                return
            }
            
            guard !errorMessage.isEmptyStr else { return }
            showErrorMessage()
        }
    }
    
    override public var borderStyle: UITextBorderStyle{
        didSet{
            guard borderStyle != oldValue else { return }
            borderStyle = .none
        }
    }
    
    override public var placeholder: String?{
        didSet{
            
            guard let color = placeholderColor else {
                lblFloatPlaceholder.text = placeholderFinal
                return
            }
            attributedPlaceholder = NSAttributedString(string: placeholderFinal,
                                                       attributes: [NSForegroundColorAttributeName:color])
        }
    }
    
    override public var attributedPlaceholder: NSAttributedString?{
        didSet{ lblFloatPlaceholder.text = placeholderFinal }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    
    fileprivate func commonInit() {
        
        dtLayer.cornerRadius        = 4.5
        dtLayer.borderWidth         = 0.5
        dtLayer.borderColor         = borderColor.cgColor
        dtLayer.backgroundColor     = UIColor.white.cgColor
        
        floatPlaceholderColor       = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        floatPlaceholderActiveColor = tintColor
        lblFloatPlaceholder.frame   = CGRect.zero
        lblFloatPlaceholder.alpha   = 0.0
        lblFloatPlaceholder.font    = floatPlaceholderFont
        lblFloatPlaceholder.text    = placeholderFinal
        
        addSubview(lblFloatPlaceholder)
        
        lblError.frame              = CGRect.zero
        lblError.font               = errorFont
        lblError.textColor          = UIColor.red
        lblError.numberOfLines      = 0
        lblError.isHidden           = true
        
        addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        
        addSubview(lblError)
        
        layer.insertSublayer(dtLayer, at: 0)
    }
    
    fileprivate func showErrorMessage(){
        let errorHeight = errorMessage.heightWithConstrainedWidth(width: bounds.width, font: errorFont)
        lblError.text = errorMessage
        lblError.isHidden = false
        lblError.frame = CGRect(x: paddingX, y: 0, width: bounds.width - (paddingX * 2), height: errorHeight)
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func hideErrorMessage(){
        lblError.text = ""
        lblError.isHidden = true
        lblError.frame = CGRect.zero
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func showFloatingLabel() {
        
        let animations:(()->()) = {
            self.lblFloatPlaceholder.alpha = 1.0
            self.lblFloatPlaceholder.frame = CGRect(x: self.x, y: self.paddingYFloatLabel, width: self.floatLabelWidth, height: self.floatLabelHeight)
        }
        
        UIView.animate(withDuration: floatingLabelShowAnimationDuration,
                       delay: 0.0,
                       options: [.beginFromCurrentState,.curveEaseOut],
                       animations: animations){ status in
                        DispatchQueue.main.async {
                            self.layoutIfNeeded()
                        }
        }
    }
    
    fileprivate func hideFlotingLabel() {
        
        let animations:(()->()) = {
            self.lblFloatPlaceholder.alpha = 0.0
            let labelHeight = self.floatLabelHeight
            self.lblFloatPlaceholder.frame = CGRect(x: self.x, y: labelHeight, width: self.floatLabelWidth, height: labelHeight)
        }
        
        UIView.animate(withDuration: floatingLabelShowAnimationDuration,
                       delay: 0.0,
                       options: [.beginFromCurrentState,.curveEaseOut],
                       animations: animations){ status in
                        DispatchQueue.main.async {
                            self.layoutIfNeeded()
                        }
        }
    }
    
    fileprivate func insetRectForEmptyBounds(rect:CGRect) -> CGRect{
        if showError {
            let topInset = ((rect.size.height - lblError.bounds.size.height - paddingYErrorLabel) / 2.0) - (ceil(font!.lineHeight) / 2.0)
            let textY = (rect.height / 2.0) - (ceil(font!.lineHeight) / 2.0) - topInset
            
            return CGRect(x: x, y: -ceil(textY), width: rect.size.width, height: rect.size.height)
        }else{
            return CGRect(x: x, y: 0.0, width: rect.width, height: rect.height)
        }
    }
    
    fileprivate func insetRectForBounds(rect:CGRect) -> CGRect {
        guard !lblFloatPlaceholder.text!.isEmptyStr else {
            return insetRectForEmptyBounds(rect: rect)
        }
        
        if let text = text,text.isEmptyStr {
            return insetRectForEmptyBounds(rect: rect)
        }else{
            let topInset = (paddingYFloatLabel * 2) + lblFloatPlaceholder.bounds.size.height
            let textY = (rect.height / 2.0) - (ceil(font!.lineHeight) / 2.0) - topInset
            return CGRect(x: x, y: -ceil(textY), width: rect.size.width, height: rect.size.height)
        }
    }
    
    @objc fileprivate func textFieldTextChanged(){
        guard showError else { return }
        showError = false
    }
    
    override public var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        
        let textFieldIntrinsicContentSize = super.intrinsicContentSize
        
        lblFloatPlaceholder.sizeToFit()
        lblError.sizeToFit()
        
        if showError {
            return CGSize(width: textFieldIntrinsicContentSize.width,
                          height: textFieldIntrinsicContentSize.height + (paddingYFloatLabel * 3) + paddingYErrorLabel + lblFloatPlaceholder.bounds.size.height + lblError.bounds.size.height)
        }else{
            return CGSize(width: textFieldIntrinsicContentSize.width,
                          height: textFieldIntrinsicContentSize.height + (paddingYFloatLabel * 3) + lblFloatPlaceholder.bounds.size.height)
        }
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return insetRectForBounds(rect: rect)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return insetRectForBounds(rect: rect)
    }
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.y = 0
        rect.size.height = dtLayer.bounds.height
        return rect
    }
    
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.y = 0
        rect.size.height = dtLayer.bounds.height
        return rect
    }
    
    override public func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.y = (dtLayer.bounds.height / 2) - (rect.size.height / 2)
        return rect
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if showError {
            
            dtLayer.frame = CGRect(x: bounds.origin.x,
                                   y: bounds.origin.y,
                                   width: bounds.width,
                                   height: floor(bounds.height - lblError.bounds.size.height - paddingYErrorLabel))
            
            var lblErrorFrame = lblError.frame
            lblErrorFrame.origin.y = dtLayer.frame.origin.y + dtLayer.frame.size.height + paddingYErrorLabel
            lblError.frame = lblErrorFrame
            
        }else{
            dtLayer.frame = CGRect(x: bounds.origin.x,
                                   y: bounds.origin.y,
                                   width: bounds.width,
                                   height: bounds.height)
        }
        
        lblFloatPlaceholder.textColor = isFirstResponder ? floatPlaceholderActiveColor : floatPlaceholderColor
        
        if let enteredText = text,!enteredText.isEmptyStr{
            showFloatingLabel()
        }else{
            hideFlotingLabel()
        }
    }
}
