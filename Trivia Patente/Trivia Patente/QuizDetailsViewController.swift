//
//  QuizDetailsViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 08/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit
import CollieGallery

class QuizDetailsViewController: BaseViewController, QuizSummaryHeaderViewDelegate {
    
    /* HEADER */
    var quizStaticHeader: QuizSummaryHeaderViewController!
    
    internal var item : Int = -1
    internal var questions = [1, 2, 3]
    
    @IBOutlet weak var tableView: UITableView!
    
    var imageAnimationStartView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultBackgroundGradient()
        // Do any additional setup after loading the view.
        self.quizStaticHeader.delegate = self
        self.tableView.register(UINib(nibName: "QuizQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        
        self.tableView.reloadData()
    }
    
    func presentImage(image: UIImage?) {
        if let i = image {
            let picture = CollieGalleryPicture(image: i)
            let gallery = CollieGallery(pictures: [picture])
            let zoomTransition = CollieGalleryTransitionType.zoom(fromView: self.imageAnimationStartView!, zoomTransitionDelegate: self)
            gallery.presentInViewController(self, transitionType: zoomTransition)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadItem(item: Int) {
        self.item = item
//        quizStaticHeader.setItem(item: item)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller
        if let id = segue.identifier {
            switch id {
            case "quizHeader":
                self.quizStaticHeader = segue.destination as! QuizSummaryHeaderViewController
            default: break
                
            }
        }
        
    }
}

extension QuizDetailsViewController : CollieGalleryZoomTransitionDelegate {
    
    func zoomTransitionContainerBounds() -> CGRect {
        return self.view.frame
    }
    func zoomTransitionViewToDismissForIndex(_ index: Int) -> UIView? {
        return self.imageAnimationStartView
    }
}

extension QuizDetailsViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuizQuestionTableViewCell
        cell.setQuestion(question: self.questions[indexPath.row])
        cell.parentController = self
        return cell
    }
}

extension QuizDetailsViewController : UITableViewDelegate
{
    
}
