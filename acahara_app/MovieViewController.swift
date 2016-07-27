//
//  MovieViewController.swift
//  acahara_app
//
//  Created by RIho OKubo on 2016/07/13.
//  Copyright © 2016年 RIho OKubo. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary
import Photos
import AVFoundation

class MovieViewController: UIViewController,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate {
    
    // MARK:一戸コメント
    // 詳細ページの中で何番目の動画が選ばれたか保存するプロパティ
    var movSelectedIndex = -1
    var numOfSelectedMovie = -1
    
    // MARK:一戸追加
    // 記事一覧で何番目の記事が選ばれているか保存するプロパティ
    var postSelectedIndex = -1
    
    // MARK:一戸追加
    // 動画が再生中か表すフラグ
    var playFlag = false
    
    @IBOutlet weak var movieView: AVPlayerView!
    
    // MARK:一戸追加
    // 再生用のアイテム.
    var playerItem : AVPlayerItem!
    
    // 再生するURL
    var movieURL:String!
    
    // AVPlayer.
    var videoPlayer : AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //   UIViewのレイヤーをAVPlayerLayerにする。普通のviewをカスタマイズしてる
        
        let layer = movieView.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravityResizeAspect
        
//        layer.player = videoPlayer//なぜここでエラー？
//        データをセットすべき箇所で、今、それがないから？
        
        

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
        let path = NSBundle.mainBundle().pathForResource("posts", ofType: "txt")
        let jsondata = NSData(contentsOfFile: path!)
        
        
        
        
        
        //MARK:一戸変更
        //let jsonArray = (try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: [])) as! NSArray
        let jsonArray = (try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: [])) as! NSArray
        //let dic = jsonArray[picSelectedIndex]
        let dic = jsonArray[postSelectedIndex] as! NSDictionary
        
        //var selectedPicture = "picture" + String(numOfSelectedPicture)
        
        
        //pictureImageView.image = UIImage(named: dic["selectedPicture"] as! String)
        
        //選択したpostのassetsURLの配列を取得
        let picArray = dic["movie"] as! NSArray
        
        //assetsURLの取り出し
        //一戸変更
        //var strUrl = picArray[movSelectedIndex] as! String
        //var url = NSURL(string: strUrl)
        
        movieURL = picArray[movSelectedIndex] as! String
        
        var url = NSURL(string: movieURL)
        
        let avAsset = AVURLAsset(URL: url!)
        
        // AVPlayerに再生させるアイテムを生成.
        playerItem = AVPlayerItem(asset: avAsset)
        
        // AVPlayerを生成.
        videoPlayer = AVPlayer(playerItem: playerItem)

        
        // Viewを生成.
        //MARK:一戸変更
        // Viewを生成.
        //let videoPlayerView = AVPlayerView(frame: movieView.frame)
        
        // UIViewのレイヤーをAVPlayerLayerにする.
        let layer = movieView.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer.player = videoPlayer
 
        // レイヤーを追加する.
        //self.view.MovieView.layer.addSublayer(layer)
        //movieView = videoPlayerView
        
        //再生の終わりを感知する
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: "onVideoEnd",
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: nil)
        //MARK:一戸変更終了
    }

    //MARK:一戸追加
    override func viewDidDisappear(animated: Bool) {
        //再生の終わりを感知する
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    @IBAction func tapPlay(sender: UIButton) {
        //TODO:この再生ボタンを実装すべし！
        //この一行で再生する、ここにボタンを置いて、押したら、この一行が効くようにすれば良い。
        
        // MARK:一戸追加
        var layer:AVPlayerLayer = AVPlayerLayer()
        
        
        layer = movieView.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
        //TODO:
        layer.player = videoPlayer//なぜここでエラー？
            

        
        let status : AVPlayerItemStatus = self.playerItem.status as AVPlayerItemStatus

        if status == .ReadyToPlay {
            // 再生準備完了
            print("ReadyToPlay")
            layer.player?.play()
            playFlag = true
            
        }
        else if status == .Failed {
            print("Failed")
        }
        else if status == .Unknown {
            print("Unknown")
        }
        
    }
    
    // MARK:一戸追加
    // 動画再生終了時
    func onVideoEnd()
    {
        print("Play End")
        
        //PlayerLayerを作りなおす
        addLayer()
        
        

    }
    
    //MARK:一戸追加
    //URLから動画再生するViewのレイヤーを作成し追加
    func addLayer(){
        //assetsURLの取り出し
        var url = NSURL(string: movieURL)
        
        let avAsset = AVURLAsset(URL: url!)
        
        // AVPlayerに再生させるアイテムを生成.
        playerItem = AVPlayerItem(asset: avAsset)
        
        // AVPlayerを生成.
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        
        var layer:AVPlayerLayer = AVPlayerLayer()
        
        
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        layer.player = videoPlayer
        movieView.layer.addSublayer(layer)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// レイヤーをAVPlayerLayerにする為のラッパークラス.vieのクラスにこれを指定することでAVViewに形成する　クラス指定を忘れないで！
class AVPlayerView : UIView{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override class func layerClass() -> AnyClass{
        return AVPlayerLayer.self
    }
    
}
