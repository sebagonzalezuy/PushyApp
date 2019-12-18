import Foundation
import Swinject

private class DependencyResolver{
    static let shared = DependencyResolver()
    private var _container : Container?
    
    var container : Container {
        get {
            if let currentContainer = _container {
                return currentContainer
            }
            else{
                _container = setupDefaultContainer()
                return _container!
            }
        }
        set{
            _container = newValue
        }
    }
    
    private func setupDefaultContainer() -> Container{
        let container = Container()
        
        //Singletons
        container.register(RemoteNotificationManagerProtocol.self) { _ in RemoteNotificationManager() }.inObjectScope(.container)
        
        //Individual Instances
//        container.register(DemoManagerProtocol.self) { _ in DemoManager() }.inObjectScope(.transient)
        
        return container
    }
    
    private init() { }
}

/// Resolves dependency based on the registered type
///
/// - Parameter type: the type to resolve
/// - Returns: resolved instance
func resolve<T>(type: T.Type) -> T? {
    return DependencyResolver.shared.container.resolve(T.self)
}

/// Resolves dependency based on the registered type on a thread safe container
///
/// - Parameter type: the type to resolve
/// - Returns: resolved instance
func resolveThreadSafe<T>(type: T.Type) -> T? {
    let threadSafeContainer: Resolver = DependencyResolver.shared.container.synchronize()
    return threadSafeContainer.resolve(T.self)
}


/// Sets the container
/// - Parameter container: Container with the developer desired dependencies
func setDependencyContainer(container: Container) {
    DependencyResolver.shared.container = container
}
