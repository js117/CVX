MATLAB Java Package Read Me

1. Prerequisites for Deployment 

. Verify the MATLAB runtime is installed and ensure you    
  have installed version 8.5 (R2015a). 

. If the MATLAB runtime is not installed, do the following:
  (1) enter
  
      >>mcrinstaller
      
      at MATLAB prompt. The MCRINSTALLER command displays the 
      location of the MATLAB runtime installer.

  (2) run the MATLAB runtime Installer.

Or download the Windows 64-bit version of the MATLAB runtime for R2015a 
from the MathWorks Web site by navigating to

   http://www.mathworks.com/products/compiler/mcr/index.html
   
 
For more information about the MATLAB runtime and the MATLAB runtime installer, see 
Package and Distribute in the MATLAB Compiler SDK documentation  
in the MathWorks Documentation Center. 

. Ensure you have the version 1.7 of the Java Development Kit (JDK) to integrate the 
  component. 

. HanningFilter.jar must be included in your CLASSPATH.

. javabuilder.jar must be included in your CLASSPATH. javabuilder.jar 
  can be found in: 
  
  <mcr_root>*\toolbox\javabuilder\jar\win64\javabuilder.jar
  

NOTE: You will need administrator rights to run MCRInstaller. 
 
2. Files to Deploy and Package

-HanningFilter.jar
-MCRInstaller.exe 
   - if end users are unable to download the MATLAB runtime using the above  
     link, include it when building your component by clicking 
     the "Runtime downloaded from web" link in the Deployment Tool
-Javadoc   
   - javadoc for HanningFilter is in the doc directory. While  
     distributing the javadoc, this entire directory should be distributed.
-This readme file


3. Resources

   - To learn more about Deploying Java applications on the Web, see Web Deployment in 
     the MATLAB Java Package documentation in the MathWorks Documentation Center.   


4. Definitions

For information on deployment terminology, go to 
http://www.mathworks.com/help. Select MATLAB Compiler >   
Getting Started > About Application Deployment > 
Application Deployment Terms in the MathWorks Documentation 
Center.


* NOTE: <mcr_root> is the directory where the MATLAB runtime is installed on the target 
        machine.


5. Appendix 

A. Linux x86-64 systems:   
   On the target machine, add the MATLAB runtime directory to the environment variable 
   LD_LIBRARY_PATH by issuing the following commands:

        NOTE: <mcr_root> is the directory where MATLAB runtime is installed
              on the target machine.         

            setenv LD_LIBRARY_PATH
                $LD_LIBRARY_PATH:
                <mcr_root>/v85/runtime/glnxa64:
                <mcr_root>/v85/bin/glnxa64:
                <mcr_root>/v85/sys/os/glnxa64:
                <mcr_root>/v85/sys/opengl/lib/glnxa64
            setenv XAPPLRESDIR <mcr_root>/v85/X11/app-defaults
 
B. Mac systems: 
   On the target machine, add the MATLAB runtime directory to the environment variable 
   DYLD_LIBRARY_PATH by issuing the following commands:

        NOTE: <mcr_root> is the directory where MATLAB runtime is installed
              on the target machine.         

            setenv DYLD_LIBRARY_PATH
                $DYLD_LIBRARY_PATH:
                <mcr_root>/v85/runtime/maci64:
                <mcr_root>/v85/sys/os/maci64:
                <mcr_root>/v85/bin/maci64


   For more detail information about setting the MATLAB runtime paths, see Package and 
   Distribute in the MATLAB Compiler SDK documentation in the MathWorks Documentation 
   Center.


       
        NOTE: To make these changes persistent after logout on Linux or 
              Mac machines, modify the .cshrc file to include this  
              setenv command.
        NOTE: On Windows, the environment variable syntax utilizes 
              backslashes (\), delimited by semi-colons (;). 
              On Linux or Mac, the environment variable syntax utilizes   
              forward slashes (/), delimited by colons (:).  
        NOTE: On Maci64, ensure you are using 64-bit JVM.
