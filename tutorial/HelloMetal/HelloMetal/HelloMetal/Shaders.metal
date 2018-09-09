//
//  File.metal
//  HelloMetal
//
//  Created by Sharon Liu on 9/3/18.
//  Copyright © 2018 Sharon Liu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

/*
 All vertex shaders must begin with the keyword vertex. The function must return (at least) the final position of the vertex – you do so here by indicating float4 (a vector of 4 floats). You then give the name of the vertex shader; you will look up the shader later using this name.

 The first parameter a pointer to an array of packed_float3 (a packed vector of 3 floats) – i.e. the position of each vertex.
 
 The [[ ... ]] syntax is used to declare attributes which can be used to specify additional information such as resource locations, shader inputs, and built-in variables. Here you mark this parameter with [[ buffer(0) ]], to indicate that this parameter will be populated by the first buffer of data that you send to your vertex shader from your Metal code.
 
 The vertex shader will also take a special parameter with the vertex_id attribute, which means it will be filled in with the index of this particular vertex inside the vertex array.
 
 Here you look up the position inside the vertex array based on the vertex id and return that. You also convert the vector to a float4, where the final value is 1.0 (long story short, this is required for 3D math purposes).
 

*/

vertex float4 basic_vertex(                           // 1
                           const device packed_float3* vertex_array [[ buffer(0) ]], // 2
                           unsigned int vid [[ vertex_id ]]) {                 // 3
    return float4(vertex_array[vid], 1.0);              // 4
}

{
    /*
     5) Create a Fragment Shader
     After the vertex shader completes, another shader is called for each fragment (think pixel) on the screen: the fragment shader.
     
     The fragment shader gets its input values by interpolating the output values from the vertex shader. For example, consider the fragment between the bottom two vertices of the triangle:
     The input value for this fragment will be a 50/50 blend of the output value of the bottom two vertices.
     
     The job of a fragment shader is to return the final color for each fragment. To keep things simple, you will make each fragment white.
     
     All fragment shaders must begin with the keyword fragment. The function must return (at least) the final color of the fragment. You do so here by indicating half4 (a 4-component color value RGBA). Note that half4 is more memory efficient than float4 because you are writing to less GPU memory.
     
     Here you return (1, 1, 1, 1) for the color (which is white).


     */
    fragment half4 basic_fragment() { // 1
        return half4(1.0);              // 2
    }

}

{
    /*
     6) Create a Render Pipeline
     Now that you’ve created a vertex and fragment shader, you need to combine them (along with some other configuration data) into a special object called the render pipeline.
     
     One of the cool things about Metal is that the shaders are precompiled, and the render pipeline configuration is compiled after you first set it up. This makes everything extremely efficient.
     
     
     */
}

