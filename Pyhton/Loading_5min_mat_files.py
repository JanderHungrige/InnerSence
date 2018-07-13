# -*- coding: utf-8 -*-
"""
Created on Sat Dec 17 21:10:17 2016

@author: 310122653
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Apr 25 14:02:00 2016

@author: 310122653
"""

#def loadingMatrizen():
    #When importing a file, Python only searches the current directory, 
    #the directory that the entry-point script is running from, and sys.path 
    #which includes locations such as the package installation directory 
import scipy.io as sio
import pandas as pd
from matplotlib import pyplot as plt
import numpy as np
import math

folder=('C://Users//310122653//Documents//PhD//InnerSense Data//Matlab//saves//Matrizen//')

# ONLY 5 MIN FEATURES AND ANNOTATIONS
dateien_each_patient="SW_5min_feature_Matrix_patient_","SW_5min_annotation_Matrix_patient_" #non scaled values. The values should be scaled over all patient and not per patient. Therfore this is better

Neonate='3','4','5','6','7','9','13','15'
FeatureMatrix_each_patient=[0]*len(Neonate)
AnnotMatrix_each_patient=[0]*len(Neonate)

# IMPORTING *.MAT FILES
for j in range(len(dateien_each_patient)): # j=1 Features  j=1 Annotations
    for k in range(len(Neonate)):
        Dateipfad=folder+dateien_each_patient[j]+Neonate[k]
        sio.absolute_import   
        matlabfile=sio.loadmat(r'{}'.format(Dateipfad)) 
    
# REWRITING FEATURES AND ANNOTATIONS    
    #NANs should already be deleted. Not scaled.
        if j==0:
            FeatureMatrix_each_patient[k]=matlabfile.get('Matrix') 
            FeatureMatrix_each_patient[k]=FeatureMatrix_each_patient[k].transpose() # transpose to datapoints,features
            FeatureMatrix_each_patient[k]=FeatureMatrix_each_patient[k][~np.isnan(FeatureMatrix_each_patient[k]).any(axis=1)]#deleting NAN and turning Matrix to datapoints,Features

        elif j==1:
            AnnotMatrix_each_patient[k]=matlabfile.get('AnnotationMatrix')  
            AnnotMatrix_each_patient[k]=AnnotMatrix_each_patient[k].transpose() # transpose to datapoints,annotations
            AnnotMatrix_each_patient[k]= np.delete(AnnotMatrix_each_patient[k],(1,2), axis=1) #Reduce AnnotationMatrix to Nx1
            AnnotMatrix_each_patient[k]=AnnotMatrix_each_patient[k][~np.isnan(AnnotMatrix_each_patient[k]).any(axis=1)]#deleting NAN and turning Matrix to datapoints,Features

            
            
#            
##create feature dictionary with all names and the indices
features_indx={"totpow":    [1],
               "VLF":       [2],
               "LF":        [3],
               "LFnorm":    [4],
               "HF":        [5],  
               "HFnorm":    [6],
               "ratioLFHF": [7],
               "SDNN":      [8],
               "RMSSD":     [9],
               "NN10":      [10],
               "NN20":      [11],
               "NN30":      [12],
               "NN50":      [13],
               "pNN10":     [14],
               "pNN20":     [15],
               "pNN30":     [16],
               "pNN50":     [17]}    
#                   
Class_dict={1:'AS',2:'QS',3:'AW',4:'QW' ,5:'Trans' ,6:'Pos',7:'Not_reliable'} #AS:active sleep   QS:Quiet sleep  AW:Active wake  QW:Quiet wake  Trans:Transition  Pos:Position         
#
features_dict={
                1:"totpow",
                2:"VLF",
                3:"LF",
                4:"LF",
                5:"HF",
                6:"HF",
                7:"ratioLFHF",
                8:"SDNN",
                9:"RMSSD",
                10:"NN10",
                11:"NN20",
                12:"NN30",
                13:"NN50",
                14:"pNN10",
                15:"pNN20",
                16:"pNN30",
                17:"pNN50",
              }     

#
feature_idx = dict((y,x) for x,y in features_dict.items())

              
#return (AnnotMatrix_each_patient, FeatureMatrix_each_patient, Class_dict, features_dict, features_indx)