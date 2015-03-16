# libSoxXamarin

It's file for functions that are tight up with libSox and iOS. I'm using this project for bindings to libsox. 
To build use build.sh script.

It have only reduce noise function for now. To use it you must put libXamarinSoxBindings.a into your project and put
"-gcc_flags "-force_load ${ProjectDir}/libXamarinSoxBindings.a"" into xamarin ios project build config as additional argument.
 
 To import this function in Xamarin you should write in any class like this:
 
 ```
 [DllImport("__Internal")]
private extern static void reduce_noise([MarshalAs(UnmanagedType.LPStr)]string inputPath, 
    [MarshalAs(UnmanagedType.LPStr)]string outputPath, 
    [MarshalAs(UnmanagedType.LPStr)]string noiseProfilePath, 
    [MarshalAs(UnmanagedType.LPStr)]string reductionFactor);
  ```
