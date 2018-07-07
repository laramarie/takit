public class CUU {
    
    // - MARK: Attributes
    /**
     * The shared ThinkingAloudKit instance.
     */
    public static var thinkingAloudKit: ThinkingAloudKit {
        return ThinkingAloudKit()
    }
    
    public static var featureKit: FeatureKit {
        return FeatureKit()
    }
    
    // - MARK: Methods
    
    /**
     * Starts ThinkingAloudKit.
     */
    public static func start() {
        thinkingAloudKit.start()
        featureKit.start()
    }
    
    /**
     * Stops ThinkingAloudKit.
     */
    public static func stop() {
        thinkingAloudKit.stop()
    }
    
    /**
     *   Open method to handle crumb saving.
     *   @param name: the name of the crumb to be created and stored
     **/
    open static func seed(name: String) {
        let actionCrumb = FKActionCrumb(name: name)
        actionCrumb.send()
        
        featureKit.handleAdditionalCrumbActionsForFeatures(with: actionCrumb)
    }
}
