//
//  VideoDetailViewController.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/14/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
class VideoDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var back: UIButton!

    @IBOutlet weak var video: YTPlayerView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: VideoDetailViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor .clear
        video.load(withVideoId: (viewModel?.videoId())!)
        videoName.text = viewModel?.name()
        viewModel?.refresh { [unowned self] in
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.numberOfIngredients())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = viewModel?.titleForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        return cell
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
