# MVVM-C primeira parte Coordinator.
 
### O que é um Coordinator?
 
Esta é a última parte do nome desta arquitetura, mas acho que é a parte mais importante. Se você puder implementar apenas uma parte dessa arquitetura como um todo, eu recomendaria que você implementasse esse padrão, pois acho que tem um potencial incrível para melhorar sua estrutura geral de aplicativos.
 
Um Coordinator é um objeto (tipo Classe no Swift) que tem a responsabilidade exclusiva, como o próprio nome indica, de coordenar a navegação do Aplicativo. 
 
Basicamente, qual tela deve ser mostrada, qual tela deve ser mostrada a seguir, etc.
 
Isso basicamente significa que o Coordinator tem que:
 
* Instanciar ViewController e ViewModel
* Instanciar e Injetar dependências no ViewController e no ViewModel
* Apresente ou empurre ViewControllers para a tela
 
 
##### O protocolo do Coordinator
 
```
public protocol Coordinator {
    func start()
}
```
 
##### LoginCoordinator
 
Vamos criar uma classe que vai abrir a tela de Login e quando estiver logado vai para o classe da Home.
 
```
public class LoginCoordinator: Coordinator {
    let navigationController: UINavigationController
   
    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        goViewController()
    }
    
    private func goViewController() {
        let viewController = LoginViewController()
 
        viewController.onTryingToLogin = { user, pwd  in
            
            if user == "Moacir" && pwd == "Lindao" {
                let coordinator = HomeCoordinator(navigationController: self.navigationController)
                coordinator.start()
            }
        }
 
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
 
```
 classe  [LoginViewControler](https://github.com/MoacirParticular/Login-MVVM-C/blob/main/Login-MVVM-C/Login-MVVM-C/Sources/ViewController/Login/LoginViewController.swift)
 
 classe [LoginView](https://github.com/MoacirParticular/Login-MVVM-C/blob/main/Login-MVVM-C/Login-MVVM-C/Sources/ViewController/Login/LoginView.swift)
 
 
> Na classe HomeCoordinator vamos chamar uma ViewController do Sotryboard para dar mais charme.
 
```
public class HomeCoordinator: Coordinator {
    let navigationController: UINavigationController
   
    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        goViewController()
    }
    
    private func goViewController() {
        let storyBoard = getStoryBoard(nameStoryboard: "Main")        
        
        guard let viewController = storyBoard.instantiateViewController(identifier: "ViewController") as? ViewController else { return }
 
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
```
Veja que na view controller do HomeCoordinator nao tem nada implementado
 
classe [ViewController](https://github.com/MoacirParticular/Login-MVVM-C/blob/main/Login-MVVM-C/Login-MVVM-C/Sources/ViewController/Home/ViewController.swift)
 
Assim você navega dentro do App entre as ViewController
 
 
 # MVVM-C segunda parte Model-View-View-Model.
 
 ![](https://github.com/MoacirParticular/Login-MVVM-C/blob/main/Arquivos/mvvm.png)
 
 #### O que é um ViewModel?
Vamos fazer um experimento mental. Pegue um controlador de visão típico e divida-o em duas partes. 
De um lado, deixe todos os métodos específicos do UIKit/UIViewController e tudo o que lida diretamente com visualizações e sub-visões. 
E por outro lado coloque todo o resto, toda a sua lógica de negócios; ou seja, solicitações de rede, validação, preparação de dados de modelo para apresentação, etc...
 
Então, basicamente, a primeira parte (coisas do UIKit) permanecerá, como deveria, no controlador de visualização. Todo o resto, toda a lógica de negócios específica do aplicativo, agora estará no ViewModel.
 
Essa separação ajuda o controlador de visão a aderir ao _princípio da responsabilidade única_. 
 
Agora, o controlador de visualização que faz parte do UIKit, pois é uma subclasse do UIViewController, lida apenas com coisas do UIKit. Manipulando rotação, carregamento de visualizações, restrições, adição de sub-visões, ações de destino, etc.
 
Isso deixa o ViewModel totalmente livre da terra do UIKit. 
O que permite focar na lógica central do negócio, aderindo ao SRP. 
Isso torna muito mais fácil raciocinar e testar, entre outras coisas.
 
O ViewController terá uma relação _um-para-um_ com o ViewModel. 
Haverá um ViewModel por ViewController, e o ViewController será o proprietário do ViewModel. 
Com isso, quero dizer que ele possuirá uma forte referência ao ViewModel, mas não o criará em si, será passado para ele via injeção de dependência. No nosso caso, ele foi criado pelo Coordinator e passado para o ViewController.
 
 
>Este exemplo é só para explicar o conceito do Model, ViewModel, para que você entenda o MVVM, não considere a vida real, pois uma classe de login teria que ter muitos outros cuidados, tratativa e afins, não estamos aqui fazendo um login verdadeiro.
 
 #### Model
 
 Model é a classe que vai receber os dados que podem vir do banco de dados local, de uma api, e assim por diante
 
 ```
 struct LoginModel : Codable {
     let userName : String?
     let userLogin: String?
     let userPassword: String?
 }
```
>_Codable é um alias de tipo para os protocolos codificados e decodificados. Quando você usa Codable como um tipo ou restrição genérica, ele corresponde a qualquer tipo que esteja em conformidade com os dois protocolos. [](https://developer.apple.com/documentation/swift/codable)_
 
_Neste nosso exemplo temos 3 atributos que podem ser nulos nos dados, não estou trazendo o atributo userPassword para mostrar que desta forma não teremos crash, mas se por acaso você tirar o ? do campo userPassword o aplicativo vai crashar(fechar causando uma quebra)_
 
 
#### ViewModel
 
No padrão MVVM 
 
>Toda a lógica de negócios específica do aplicativo, deve estar no ViewModel.
 
No exemplo nossa classe ficou assim:
 
```
struct LoginViewModel {
    private let model : LoginModel    
    
    var userName : String {
        self.model.userName ?? String.empty
    }
    
    var userLogin: String {
        self.model.userLogin ?? String.empty
    }
    
    var userPassword: String {
        self.model.userPassword ?? String.empty
    }
    
    init(withModel model: LoginModel) {
        self.model = model
    }
    
    static func fetchData(user:String, pwd:String, completion: @escaping (Result<LoginViewModel, Error>) -> Void) {
        let networkManager: HTTPManagerProtocol = HTTPManager()
        
        networkManager.get(url: URL(string: "NOURL")!, completionBlock: { result in
            do {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let data):
                    let model = try JSONDecoder().decode(LoginModel.self, from: data)
                    let viewModel = LoginViewModel(withModel: model)
                    completion(.success(viewModel))
                }
            } catch let error as NSError {
                completion(.failure(error))
            }
        })
    }
}
```
 
Criei uma instância do Model para receber os dados, este atributo esta private e só pode ser passado no constructor.
 
Os atributos _userName_, _userLogin_ e _userPassword_ estão expostos para as outras classe, percebam que estou tratando os valores para que as classes não precisem fazer isto, ou seja elas nunca vão receber um valor nulo.

Você pode tratar os valores como data, no formato que desejar, currency e assim por diante.
 
##### Método Static 
>_O Swift permite criar propriedades e métodos que pertencem a um tipo, em vez de instâncias de um tipo. Isso é útil para organizar seus dados de maneira significativa, armazenando dados compartilhados. Swift chama essas propriedades compartilhadas de "propriedades estáticas", e você cria uma apenas usando a palavra-chave estática. Feito isso, você acessa a propriedade usando o nome completo do tipo._
 
Criei um método static para facilitar nossa vida, mas existem outras maneiras de se criar, eu sugiro termos um outro padrão envolvido nesta hora uma Factory e aí podemos ter uma Classe Manager, uma Bussines e uma Provider mas isto é assunto para um outro tutoria.
 
Neste método _fetchData_ estou simulando uma chamada de _API_ que vai me retornar um data que recebo 
 
>let model = try JSONDecoder().decode(LoginModel.self, from: data)
 
e transformo em um ViewModel
 
>let viewModel = LoginViewModel(withModel: model)
 
devolvendo para quem chamou este método.
 
Desta forma o coordinator fez a chamada
 
```
viewController.onTryingToLogin = { user, pwd  in
    
    LoginViewModel.fetchData(user: user, pwd: pwd, completion: {data in
        switch data {
        case .failure: fatalError()
        case .success(let loginViewModel):
            print("Nome do Usuario: \(loginViewModel.userName)")
            
            self.goToHome(loginViewModel: loginViewModel)
        }
    })
}
```
 
Passando para o Coordinator da Home o resultado
 
```
private func goToHome(loginViewModel: LoginViewModel) {
    let coordinator = HomeCoordinator(navigationController: self.navigationController, loginViewModel: loginViewModel)
    coordinator.start()
}
 
```
 
Que por sua vez atualiza a view que vai apresentar o resultado
 
```
private func goViewController() {
    let storyBoard = getStoryBoard(nameStoryboard: "Main")        
    
    guard let viewController = storyBoard.instantiateViewController(identifier: "ViewController") as? ViewController else { return }
    
    viewController.initialize(loginViewModel: self.loginViewModel)
 
    self.navigationController.pushViewController(viewController, animated: true)
}
```
 
e a ViewController ficou com a unica função que é apresentar este dado:
 
```
func initialize(loginViewModel: LoginViewModel) {
    nomeUsuarioLabel.text = loginViewModel.userName
}
```
 
É um exemplo simples para exemplificar uma coisa simples, claro que no dia a dia estas coisas podem se complicar, mas basicamente o que você tem que ter em mente é nunca fazer com que as classe façam o que é para outra classe fazer.
 
ViewModel cuida de toda regra de negócio, nunca vai apresentar um dado na tela por exemplo.
ViewController cuida da parte visual mostrar valores e pegar valores, nunca vai salvar os dados no banco ou mandar para uma api ela vai mandar para a ViewModel que fará isto.


![](https://github.com/MoacirParticular/Login-MVVM-C/blob/main/Arquivos/euNaoAcredito.png)
 

>_nunca deixe de acreditar em si mesmo, você pode, você consegue, basta você acreditar, praticar e fazer_
 
Existe muito material falando sobre este assunto na internet, basta um pouco de paciência e dedicação.
 
Eu procuro sempre ler, tento entender e pratico, pratico muito para fixar a ideia na minha cabeça dura.
 
boa sorte, espero ter ajudado você a entender....
 
 
 

