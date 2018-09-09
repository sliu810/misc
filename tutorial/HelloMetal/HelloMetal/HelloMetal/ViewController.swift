//
//  ViewController.swift
//  HelloMetal
//
//  Created by Sharon Liu on 9/3/18.
//  Copyright © 2018 Sharon Liu. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState! //This will keep track of the compiled render pipeline you are about to create.
    var commandQueue: MTLCommandQueue! //Think of this as an ordered list of commands that you tell the GPU to execute, one at a time.
    
    // Rendering
    var timer: CADisplayLink! //1) Create a Display Link



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        device = MTLCreateSystemDefaultDevice()
        
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = device           // 2
        metalLayer.pixelFormat = .bgra8Unorm // 3
        metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = view.layer.frame  // 5
        view.layer.addSublayer(metalLayer)   // 6
        let vertexData:[Float] = [
            0.0, 1.0, 0.0,
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0]

        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 1
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: []) // 2
        
        /*
         You can access any of the precompiled shaders included in your project through the MTLLibrary object you get by calling device.newDefaultLibrary()!. Then you can look up each shader by name.
         You set up your render pipeline configuration here. It contains the shaders you want to use, and the pixel format for the color attachment — i.e. the output buffer you are rendering to, which is the CAMetalLayer itself.
         Finally you compile the pipeline configuration into a pipeline state that is efficient to use here on out.
         */
        // 1
        let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // 3
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)

        // command q
        commandQueue = device.makeCommandQueue()


        timer = CADisplayLink(target: self, selector: #selector(ViewController.gameloop))
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func render() {
        // TODO
        guard let drawable = metalLayer?.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        
        //3) Create a Command Buffer
        let commandBuffer = commandQueue.makeCommandBuffer()//The next step is to create a command buffer. Think of this as the list of render commands that you wish to execute for this frame. The cool thing is nothing actually happens until you commit the command buffer, giving you fine-grained control over when things occur.
        
        //4) Create a Render Command Encoder
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()
        //5) Commit your Command Buffer
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }
    
    func gameloop() {
        autoreleasepool {
            self.render()
        }
    }

}

