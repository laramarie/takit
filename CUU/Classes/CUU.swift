public class CUU {
    
    // - MARK: Attributes
    /**
     * The shared ThinkingAloudKit instance.
     */
    public static var thinkingAloudKit: ThinkingAloudKit {
        return ThinkingAloudKit()
    }
    
    // - MARK: Methods
    
    /**
     * Starts ThinkingAloudKit.
     */
    public static func start() {
        thinkingAloudKit.start()
    }
    
    /**
     * Stops ThinkingAloudKit.
     */
    public static func stop() {
        thinkingAloudKit.stop()
    }
}
