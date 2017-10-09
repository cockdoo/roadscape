import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!


    let presenter = Presenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        let disposable = presenter.event.subscribe(
            onNext: { value in
                // 通常イベント発生時の処理
                print("hoge")
        },
            onError: { error in
                // エラー発生時の処理
        },
            onCompleted: {
                // 完了時の処理
        }
        )

        presenter.doSomething()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


class Presenter {
    private let eventSubject = PublishSubject<Int>()

    var event: Observable<Int> { print("return eventSubject"); return eventSubject }

    func doSomething() {
        print("do something")
        // 略
        eventSubject.onNext(1)  // イベント発行
    }
}
