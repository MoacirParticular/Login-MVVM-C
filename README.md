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

Assim você navega dentro do App entre as ViewController, claso esse é
 o básico.
 
 # MVVM-C segunda parte Model-View-View-Model.
 
 #### O que é um ViewModel?
Vamos fazer um experimento mental. Pegue um controlador de visão típico e divida-o em duas partes. 
De um lado, deixe todos os métodos específicos do UIKit/UIViewController e tudo o que lida diretamente com visualizações e subvisões. 
E por outro lado coloque todo o resto, toda a sua lógica de negócios; ou seja, solicitações de rede, validação, preparação de dados de modelo para apresentação, etc...

Então, basicamente, a primeira parte (coisas do UIKit) permanecerá, como deveria, no controlador de visualização. Todo o resto, toda a lógica de negócios específica do aplicativo, agora estará no ViewModel.

Essa separação ajuda o controlador de visão a aderir ao _princípio da responsabilidade única_. 

Agora, o controlador de visualização que faz parte do UIKit, pois é uma subclasse do UIViewController, lida apenas com coisas do UIKit. Manipulando rotação, carregamento de visualizações, restrições, adição de subvisões, ações de destino, etc.

Isso deixa o ViewModel totalmente livre da terra do UIKit. 
O que permite focar na lógica central do negócio, aderindo ao SRP. 
Isso torna muito mais fácil raciocinar e testar, entre outras coisas.

O ViewController terá uma relação _um-para-um_ com o ViewModel. 
Haverá um ViewModel por ViewController, e o ViewController será o proprietário do ViewModel. 
Com isso, quero dizer que ele possuirá uma forte referência ao ViewModel, mas não o criará em si, será passado para ele via injeção de dependência. No nosso caso, ele será criado pelo Coordenador e passado para o ViewController.
 
