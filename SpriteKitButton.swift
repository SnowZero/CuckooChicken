//
//  SpriteKitButton.swift
//  FortuneTeller
//
//  Created by appsgaga on 2016/10/17.
//  Copyright © 2016年 AppsGaGa. All rights reserved.
//

import SpriteKit

class SpriteKitButton:SKNode{
    var defaultButton:SKSpriteNode! //還沒有按下按鈕要顯示的圖
    var activeButton:SKSpriteNode!  //按下按鈕要顯示的圖
    var action:()->Void             //按下按鈕要做的事情，要執行的程式碼。(Closeure)
    
    //初始化方法，接受三個參數。還沒按下按鈕的圖檔名; 按下按鈕的圖檔名; 按下按鈕要執行的 closure
    init(defaultButtonImage:String,activeButtonImage:String, buttonAction:@escaping ()->Void) {
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage) //用圖檔名產生還沒按下去的按鈕圖檔
        activeButton = SKSpriteNode(imageNamed: activeButtonImage) //產生按下按鈕要顯示的圖檔
        action = buttonAction //把傳進來要執行的 closure ，存進 action 屬性裡面。
        
        super.init() //呼叫 super init
        isUserInteractionEnabled = true //設定可以跟 user 互動
        addChild(activeButton) //
        addChild(defaultButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init fail")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("button touch began")
        activeButton.isHidden = false
        defaultButton.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("button touch moved")
        for touch in touches{
            let location = touch.location(in: self)
            if defaultButton.contains(location){
                activeButton.isHidden = false
                defaultButton.isHidden = true
            }else{
                activeButton.isHidden = true
                defaultButton.isHidden = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("button touch ended")
        for touch in touches{
            let location = touch.location(in: self)
            if defaultButton.contains(location){
                action()
            }
        }
        activeButton.isHidden = true
        defaultButton.isHidden = false
    }
}
