/*
 * MATLAB Compiler: 6.0 (R2015a)
 * Date: Wed Jul 08 13:03:47 2015
 * Arguments: "-B" "macro_default" "-v" "-W" "java:HanningFilter,Class1" "-T" "link:lib" 
 * "-d" 
 * "C:\\Users\\JamesS\\Documents\\MATLAB\\CVX\\MultiTemplate\\Snypr\\HanningFilter\\for_testing" 
 * "class{Class1:C:\\Users\\JamesS\\Documents\\MATLAB\\CVX\\MultiTemplate\\Snypr\\HanningFilter.m}" 
 */

package HanningFilter;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class HanningFilterMCRFactory
{
   
    
    /** Component's uuid */
    private static final String sComponentId = "HanningFilte_807DB63084F701FAD8D7C9D6AB768DBF";
    
    /** Component name */
    private static final String sComponentName = "HanningFilter";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(HanningFilterMCRFactory.class)
        );
    
    
    private HanningFilterMCRFactory()
    {
        // Never called.
    }
    
    public static MWMCR newInstance(MWComponentOptions componentOptions) throws MWException
    {
        if (null == componentOptions.getCtfSource()) {
            componentOptions = new MWComponentOptions(componentOptions);
            componentOptions.setCtfSource(sDefaultComponentOptions.getCtfSource());
        }
        return MWMCR.newInstance(
            componentOptions, 
            HanningFilterMCRFactory.class, 
            sComponentName, 
            sComponentId,
            new int[]{8,5,0}
        );
    }
    
    public static MWMCR newInstance() throws MWException
    {
        return newInstance(sDefaultComponentOptions);
    }
}
