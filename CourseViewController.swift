//
//  CourseViewController.swift
//  DIUIKit
//
//  Created by 潘博石 on 09/04/2024.
//

import UIKit

public protocol DataFetchable {
    func fetchCoursesName(completion: @escaping (([String]) -> Void))
}

struct Course {
    let name: String
}

public class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dataFetchable: DataFetchable
    var courses: [Course] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    public init(dataFetchable: DataFetchable) {
        self.dataFetchable = dataFetchable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        dataFetchable.fetchCoursesName { names in
            self.courses = names.map { Course(name: $0) }
            print(self.courses)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //This function is important to show the table view
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = courses[indexPath.row].name
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
