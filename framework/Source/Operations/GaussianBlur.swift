import MetalPerformanceShaders

public class GaussianBlur: BasicOperation {
    public var blurRadiusInPixels:Float = 2.0 {
        didSet
        {
            if self.useMetalPerformanceShaders, #available(iOS 9, macOS 10.13, *) {
                internalMPSImageGaussianBlur = MPSImageGaussianBlur(device: sharedMetalRenderingDevice.device, sigma: blurRadiusInPixels)
                (internalMPSImageGaussianBlur as? MPSImageGaussianBlur)?.edgeMode = .clamp
            } else {
                //fatalError("Gaussian blur not yet implemented on pre-MPS OS versions")
//                uniformSettings["convolutionKernel"] = convolutionKernel
            }
        }
    }
    var internalMPSImageGaussianBlur: NSObject?
    
    public init() {
        super.init(fragmentFunctionName:"passthroughFragment")
        
        self.useMetalPerformanceShaders = true
        
        ({blurRadiusInPixels = 2.0})()
        
        if sharedMetalRenderingDevice.metalPerformanceShadersAreSupported,
            #available(iOS 9, macOS 10.13, *) {
            self.metalPerformanceShaderPathway = usingMPSImageGaussianBlur
        } else {
            Log.warning("Gaussian blur is not yet supported on the Simulator.")
        }
    }
    
    @available(iOS 9, macOS 10.13, *) func usingMPSImageGaussianBlur(commandBuffer:MTLCommandBuffer, inputTextures:[UInt:Texture], outputTexture:Texture) {
        (internalMPSImageGaussianBlur as? MPSImageGaussianBlur)?.encode(commandBuffer:commandBuffer, sourceTexture:inputTextures[0]!.texture, destinationTexture:outputTexture.texture)
    }
    
}
