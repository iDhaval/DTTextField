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
    
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
}

public class DTTextField: UITextField {
    
    public enum FloatingDisplayStatus{
        case always
        case never
        case defaults
    }
    
    fileprivate var lblFloatPlaceholder:UILabel             = UILabel()
    fileprivate var lblError:UILabel                        = UILabel()
    
    fileprivate let paddingX:CGFloat                        = 5.0
    
    fileprivate let paddingHeight:CGFloat                   = 10.0
    
    public var dtLayer:CALayer                              = CALayer()
    public var floatPlaceholderColor:UIColor                = UIColor.black
    public var floatPlaceholderActiveColor:UIColor          = UIColor.black
    public var floatingLabelShowAnimationDuration           = 0.3
    public var floatingDisplayStatus:FloatingDisplayStatus  = .defaults
    
    public var errorMessage:String = ""{
        didSet{ lblError.text = errorMessage }
    }
    
    public var animateFloatPlaceholder:Bool = true
    public var hideErrorWhenEditing:Bool   = true
    
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
    
    fileprivate var fontHeight:CGFloat{
        return ceil(font!.lineHeight)
    }
    
    fileprivate var dtLayerHeight:CGFloat{
        return showErrorLabel ? floor(bounds.height - lblError.bounds.size.height - paddingYErrorLabel) : bounds.height
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
    
    fileprivate var placeholderFinal:String{
        if let attributed = attributedPlaceholder { return attributed.string }
        return placeholder ?? " "
    }
    
    fileprivate var isFloatLabelShowing:Bool = false
    
    fileprivate var showErrorLabel:Bool = false{
        didSet{
            
            guard showErrorLabel != oldValue else { return }
            
            guard showErrorLabel else {
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
    
    public override var text: String?{
        didSet{ self.textFieldTextChanged() }
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
    
    public func showError(message:String? = nil) {
        if let msg = message { errorMessage = msg }
        showErrorLabel = true
    }
    
    public func hideError()  {
        showErrorLabel = false
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
        
        lblError.text = errorMessage
        lblError.isHidden = false
        let boundWithPadding = CGSize(width: bounds.width - (x * 2), height: bounds.height)
        let errorLabelSize =  lblError.sizeThatFits(boundWithPadding)
        lblError.frame = CGRect(x: paddingX, y: 0, width: errorLabelSize.width, height: errorLabelSize.height)
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func hideErrorMessage(){
        lblError.text = ""
        lblError.isHidden = true
        lblError.frame = CGRect.zero
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func showFloatingLabel(_ animated:Bool) {
        
        let animations:(()->()) = {
            self.lblFloatPlaceholder.alpha = 1.0
            self.lblFloatPlaceholder.frame = CGRect(x: self.lblFloatPlaceholder.frame.origin.x,
                                                    y: self.paddingYFloatLabel,
                                                    width: self.lblFloatPlaceholder.bounds.size.width,
                                                    height: self.lblFloatPlaceholder.bounds.size.height)
        }
        
        if animated && animateFloatPlaceholder {
            UIView.animate(withDuration: floatingLabelShowAnimationDuration,
                           delay: 0.0,
                           options: [.beginFromCurrentState,.curveEaseOut],
                           animations: animations){ status in
                            DispatchQueue.main.async {
                                self.layoutIfNeeded()
                            }
            }
        }else{
            animations()
        }
    }
    
    fileprivate func hideFlotingLabel(_ animated:Bool) {
        
        let animations:(()->()) = {
            self.lblFloatPlaceholder.alpha = 0.0
            self.lblFloatPlaceholder.frame = CGRect(x: self.lblFloatPlaceholder.frame.origin.x,
                                                    y: self.lblFloatPlaceholder.font.lineHeight,
                                                    width: self.lblFloatPlaceholder.bounds.size.width,
                                                    height: self.lblFloatPlaceholder.bounds.size.height)
        }
        
        if animated && animateFloatPlaceholder {
            UIView.animate(withDuration: floatingLabelShowAnimationDuration,
                           delay: 0.0,
                           options: [.beginFromCurrentState,.curveEaseOut],
                           animations: animations){ status in
                            DispatchQueue.main.async {
                                self.layoutIfNeeded()
                            }
            }
        }else{
            animations()
        }
    }
    
    fileprivate func insetRectForEmptyBounds(rect:CGRect) -> CGRect{
        
        guard showErrorLabel else { return CGRect(x: x, y: 0, width: rect.width - paddingX, height: rect.height) }
        
        let topInset = (rect.size.height - lblError.bounds.size.height - paddingYErrorLabel - fontHeight) / 2.0
        let textY = topInset - ((rect.height - fontHeight) / 2.0)
        
        return CGRect(x: x, y: floor(textY), width: rect.size.width - paddingX, height: rect.size.height)
    }
    
    fileprivate func insetRectForBounds(rect:CGRect) -> CGRect {
        
        guard !(lblFloatPlaceholder.text?.isEmptyStr ?? true) else { return insetRectForEmptyBounds(rect: rect) }
        
        if floatingDisplayStatus == .never {
            return insetRectForEmptyBounds(rect: rect)
        }else{
            
            if let text = text,text.isEmptyStr && floatingDisplayStatus == .defaults {
                return insetRectForEmptyBounds(rect: rect)
            }else{
                let topInset = paddingYFloatLabel + lblFloatPlaceholder.bounds.size.height + (paddingHeight / 2.0)
                let textOriginalY = (rect.height - fontHeight) / 2.0
                var textY = topInset - textOriginalY
                
                if textY < 0 && !showErrorLabel { textY = topInset }
                
                return CGRect(x: x, y: ceil(textY), width: rect.size.width - paddingX, height: rect.height)
            }
        }
    }
    
    @objc fileprivate func textFieldTextChanged(){
        guard hideErrorWhenEditing && showErrorLabel else { return }
        showErrorLabel = false
    }
    
    override public var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        
        let textFieldIntrinsicContentSize = super.intrinsicContentSize
        
        lblError.sizeToFit()
        
        if showErrorLabel {
            lblFloatPlaceholder.sizeToFit()
            return CGSize(width: textFieldIntrinsicContentSize.width,
                          height: textFieldIntrinsicContentSize.height + paddingYFloatLabel + paddingYErrorLabel + lblFloatPlaceholder.bounds.size.height + lblError.bounds.size.height + paddingHeight)
        }else{
            return CGSize(width: textFieldIntrinsicContentSize.width,
                          height: textFieldIntrinsicContentSize.height + paddingYFloatLabel + lblFloatPlaceholder.bounds.size.height + paddingHeight)
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
    
    fileprivate func insetForSideView(forBounds bounds: CGRect) -> CGRect{
        var rect = bounds
        rect.origin.y = 0
        rect.size.height = dtLayerHeight
        return rect
    }
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return insetForSideView(forBounds: rect)
    }
    
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return insetForSideView(forBounds: rect)
    }
    
    override public func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.y = (dtLayerHeight - rect.size.height) / 2
        return rect
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        dtLayer.frame = CGRect(x: bounds.origin.x,
                               y: bounds.origin.y,
                               width: bounds.width,
                               height: dtLayerHeight)
        CATransaction.commit()
        
        if showErrorLabel {
            
            var lblErrorFrame = lblError.frame
            lblErrorFrame.origin.y = dtLayer.frame.origin.y + dtLayer.frame.size.height + paddingYErrorLabel
            lblError.frame = lblErrorFrame
        }
        
        let floatingLabelSize = lblFloatPlaceholder.sizeThatFits(lblFloatPlaceholder.superview!.bounds.size)
        
        lblFloatPlaceholder.frame = CGRect(x: x, y: lblFloatPlaceholder.frame.origin.y,
                                           width: floatingLabelSize.width,
                                           height: floatingLabelSize.height)
        
        lblFloatPlaceholder.textColor = isFirstResponder ? floatPlaceholderActiveColor : floatPlaceholderColor
        
        switch floatingDisplayStatus {
        case .never:
            hideFlotingLabel(isFirstResponder)
        case .always:
            showFloatingLabel(isFirstResponder)
        default:
            if let enteredText = text,!enteredText.isEmptyStr{
                showFloatingLabel(isFirstResponder)
            }else{
                hideFlotingLabel(isFirstResponder)
            }
        }
    }
}
