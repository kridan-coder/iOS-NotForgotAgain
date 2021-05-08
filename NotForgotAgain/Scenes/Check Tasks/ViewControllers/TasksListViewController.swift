//
//  TasksListPageViewController.swift
//  NotForgotAgain
//
//  Created by KriDan on 22.04.2021.
//

import Foundation
import UIKit

class TasksListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addTaskBigButton: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let tableViewCellTaskId = "TableViewCellTask"
    let tableViewCellCategoryId = "TableViewCellCategory"
    var tasksCollection: [CellTaskGather] = []
    
    var viewModel: TasksListViewModel!
    
    func setTableTasks(tasks: [Task]?){
        
        guard let safeTasks = tasks else {return}
        var collection = [CellTaskGather]()
        

        
        for i in 0..<safeTasks.count {
            var category = CellCategory()
            let task = CellTask()
            let gather = CellTaskGather()
            task.checked = false
            task.description = safeTasks[i].description
            task.header = safeTasks[i].title
            task.id = Int(safeTasks[i].id!)
            category.id = Int(safeTasks[i].category?.id ?? 1)
            category.name = safeTasks[i].category?.name
            gather.task = task
            if !collection.contains { $0.category?.name == safeTasks[i].category?.name }
            {
                let gather = CellTaskGather()
                gather.category = category
                collection.append(gather)
                
            }
            collection.append(gather)
        }
        
        tasksCollection = collection
        initTableView()
        loadingDone()
    }
    
    func getAndLoadTasksFromAPI(){
        viewModel.apiClient?.getTasks(onSuccess: {tasks in
            self.setTableTasks(tasks: tasks)
        }, onFailure: {_ in
            print("Unexpected Error!")
        })
    }
    
    func hideLayout(){
        tableView.isHidden = true
        stackView.isHidden = true
        addTaskBigButton.isHidden = true
    }
    
    func loadingDone(){
        loader.stopAnimating()
    }
    
    func initTableView(){
        tableView.isHidden = false
        
        tableView.register(UINib.init(nibName: tableViewCellTaskId, bundle: nil), forCellReuseIdentifier: tableViewCellTaskId)
        tableView.register(UINib.init(nibName: tableViewCellCategoryId, bundle: nil), forCellReuseIdentifier: tableViewCellCategoryId)
        
        //tableView.shows = false
        
        //tableView.separatorColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLayout()
        viewModel.viewWasLoaded()

        //temp

        getAndLoadTasksFromAPI()


        
    }

}

extension TasksListViewController: UITableViewDelegate{
    
}

extension TasksListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tasksCollection[indexPath.item].category != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellCategoryId, for: indexPath) as! TableViewCellCategory
            
            cell.header.text = tasksCollection[indexPath.item].category?.name
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellTaskId, for: indexPath) as! TableViewCellTask
            
            
            cell.header.text = tasksCollection[indexPath.item].task?.header
            
            cell.subHeader.text = tasksCollection[indexPath.item].task?.description
            
            
            return cell
        
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tasksCollection[indexPath.item].category != nil{
            return 74
        }
        else{
            return 90
        }
        
    }
    
}
