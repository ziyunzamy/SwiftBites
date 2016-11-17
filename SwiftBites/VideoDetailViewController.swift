//
//  VideoDetailViewController.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/14/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
class VideoDetailViewController: UIViewController {
    @IBOutlet weak var back: UIButton!

    @IBOutlet weak var video: YTPlayerView!
    @IBOutlet weak var videoName: UILabel!
    var viewModel: VideoDetailViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        video.load(withVideoId: (viewModel?.videoId())!)
        videoName.text = viewModel?.name()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
