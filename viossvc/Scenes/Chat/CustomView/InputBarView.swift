//
//  InputBarView.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

 protocol  InputBarViewProcotol : OEZViewActionProtocol{
    
    func inputBarDidKeyboardShow(inputBar inputBar: InputBarView,userInfo : [NSObject : AnyObject]?)
    
    func inputBarDidKeyboardHide(inputBar inputBar: InputBarView,userInfo : [NSObject : AnyObject]?)
    
    func inputBarDidSendMessage(inputBar inputBar: InputBarView ,message: String)
    
    func inputBarDidChangeHeight(inputBar inputBar: InputBarView,height: CGFloat)
    
}



class InputBarView: OEZBaseView ,UITextViewDelegate {

    @IBOutlet weak var faceButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: CustomTextView!
    var inputDelegate : InputBarViewProcotol?
    var isKVO : Bool = false
//    var isChangeTextViewHeight = false
    
    
    let inputBarHeight : CGFloat = 50
    
    let sendLayer: CALayer = CALayer.init()
    override func awakeFromNib() {
        
        super.awakeFromNib()
        sendLayerSetting()
        addNotification()
        textViewSetting()
       
       
    }
    func textViewSetting() {
        textView.delegate = self
        textView.setPlaceHolder("输入要说的话...")
        textView.settingPlaceHolderTextColor(UIColor(RGBHex: 0xbdbdbd))
        
        let  top = (self.textView.bounds.size.height - UIFont.HEIGHT(14)) / 2.0;
        textView.settingScrollIndicatorInsets(UIEdgeInsetsMake(top, 5, 0, 5))
        
        
        textView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
    }
    
    func  addNotification()  {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputBarView.didKeyboardShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputBarView.didKeyboardHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func  registeredDelegate(sender : InputBarViewProcotol)  {
     
        inputDelegate = sender
    }
    
    
    
    func didKeyboardShow( notification: NSNotification) {
        
        if (textView.isFirstResponder()) {
//            _keyboardShow = YES;
//            _isActionEmoji = NO;
//
             inputDelegate?.inputBarDidKeyboardShow(inputBar: self, userInfo: notification.userInfo)
//
            
        }
    }
    func didKeyboardHide(notification: NSNotification) {
        
        if ( textView.isFirstResponder())
        {
            if( textView.inputView != nil )
            {
                textView.inputView = nil;
            }
//            if (![self isTouchEmoji]) {
//                _keyboardShow = NO;
            
            inputDelegate?.inputBarDidKeyboardHide(inputBar: self, userInfo: notification.userInfo)
                    self.faceButton.selected = false;

//            }
            
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentSize" && object === textView {
            
            let contentH = getHeight()
            let viewHeight = self.bounds.height
            if !isKVO && viewHeight != contentH  {
                inputDelegate?.inputBarDidChangeHeight(inputBar: self, height: contentH)
            }
            textView.scrollRectToVisible(CGRectMake(0, textView.contentSize.height - UIFont.HEIGHT(14), textView.contentSize.width,UIFont.HEIGHT(14)), animated: false)
        }

    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            
            didSendMessage()
            return false;
        }
        return true;
    }
    
    func textViewDidChange(textView: UITextView) {
        sendLayerChangeColor(textView.text.length() > 0)
        isKVO = false
    }
    
    func didSendMessage() {
        let  inputText = textView.text;
//        inputText = [[EmojiFaceHelper shared] faceReplaceHex:inputText];
        inputDelegate?.inputBarDidSendMessage(inputBar: self, message: inputText)
        textView.text = nil;
        sendLayerChangeColor(false)
        isKVO = true
//        [self didChangeHeight:kInputBarHeight];
//        [self emojiClose];
    }

    @IBAction func emojiFaceAction(sender : UIButton) {
        
        
    }
    
    @IBAction func sendButtonAction(sender : UIButton) {
        didSendMessage()
        
    }
    
    func sendLayerSetting() {
        
        sendLayer.frame = CGRectMake(0, 10, sendButton.bounds.width, 30)
        sendLayer.masksToBounds = true
        sendLayer.cornerRadius = 3
        sendLayer.backgroundColor = UIColor(RGBHex: 0xE0E1E2).CGColor
        sendButton.layer.addSublayer(sendLayer)
    }
    
    func sendLayerChangeColor(canSend: Bool) {
        if sendButton.userInteractionEnabled != canSend {
            sendLayer.backgroundColor = canSend ? UIColor(RGBHex: 0x141F33).CGColor :UIColor(RGBHex: 0xE0E1E2).CGColor
            sendButton.userInteractionEnabled = canSend
        }
    }
    
    
    
    func getHeight() -> CGFloat {
    var height = inputBarHeight
        if textView.text.length() != 0 {
           
            height =  ceil(textView.sizeThatFits(textView.frame.size).height)
            height = height > 73 ? 73 : height
            height += 20
        }
        //    else
        //    {
        //        //全选剪贴的情况
        //        height = kInputBarHeight;
        //    }
        height = height > inputBarHeight ? height : inputBarHeight;
        return height;
    }

    
    
    
        
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        textView.removeObserver(self, forKeyPath: "contentSize")
    }
    
}
