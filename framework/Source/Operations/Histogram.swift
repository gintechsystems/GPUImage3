import MetalPerformanceShaders

public class Histogram: BasicOperation {
    public var blurRadiusInPixels:Float = 2.0 {
        didSet
        {
            if self.useMetalPerformanceShaders, #available(iOS 9, macOS 10.13, *) {
                //internalMPSImageGaussianBlur = MPSImageGaussianBlur(device: sharedMetalRenderingDevice.device, sigma: blurRadiusInPixels)
            } else {
                fatalError("Histogram not yet implemented on pre-MPS OS versions")
//                uniformSettings["convolutionKernel"] = convolutionKernel
            }
        }
    }
    var internalMPSImageGaussianBlur: NSObject?
    
    public init() {
        super.init(fragmentFunctionName:"passthroughFragment")
        
        self.useMetalPerformanceShaders = true
        
        ({blurRadiusInPixels = 2.0})()
        
        if #available(iOS 9, macOS 10.13, *) {
            self.metalPerformanceShaderPathway = usingMPSImageGaussianBlur
        } else {
            fatalError("Histogram not yet implemented on pre-MPS OS versions")
        }
    }
    
    @available(iOS 9, macOS 10.13, *) func usingMPSImageGaussianBlur(commandBuffer:MTLCommandBuffer, inputTextures:[UInt:Texture], outputTexture:Texture) {
        
        let device = sharedMetalRenderingDevice.device
        
        var histogramInfo = MPSImageHistogramInfo(
            numberOfHistogramEntries: 512,
            histogramForAlpha: true,
            minPixelValue: vector_float4(0,0,0,0),
            maxPixelValue: vector_float4(1,1,1,1)) ;
        
        let calculation = MPSImageHistogram(
            device: device,
            histogramInfo: &histogramInfo)
        
        guard let histogramInfoBuffer = device.makeBuffer(
            bytes: &histogramInfo,
            length: MemoryLayout.size(ofValue: histogramInfo),
            options: []) else {
                print("Unable to make buffer")
                return
        }
        
        calculation.encode(
            to: commandBuffer,
            sourceTexture: inputTextures[0]!.texture,
            histogram: histogramInfoBuffer,
            histogramOffset: 0)
        
        let equalization = MPSImageHistogramEqualization(
            device: device,
            histogramInfo: &histogramInfo)
        
        equalization.encodeTransform(
            to: commandBuffer,
            sourceTexture: inputTextures[0]!.texture,
            histogram: histogramInfoBuffer,
            histogramOffset: 0)
        
        equalization.encode(
            commandBuffer: commandBuffer,
            sourceTexture: inputTextures[0]!.texture,
            destinationTexture: outputTexture.texture)
    }
    
}
