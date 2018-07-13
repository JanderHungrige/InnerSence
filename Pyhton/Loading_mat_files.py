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

# Loading the Anotation Matrix from Matlab
folder=('C://Users//310122653//Documents//PhD//InnerSense Data//Matlab//saves//Matrizen//')
dateien="AnnotMatrixfull", "SW_feature_Matrix_noNaN","AnnotationMatrix_nonNaN"
#dateien_each_patient="SW_feature_scaledMatrix_noNaN_","AnnotationMatrix_noNaN_" # scaled values Matrix=scaledMatrix; AnnotMatrix=AnnotationMatrix in matlabfile.get()
dateien_each_patient="SW_feature_Matrix_patient_","AnnotationMatrix_" #non scaled values. The values should be scaled over all patient and not per patient. Therfore this is better

Neonate='3','4','5','6','7','9','13','15'
FeatureMatrix_each_patient=[0]*len(Neonate)
AnnotMatrix_each_patient=[0]*len(Neonate)
for j in range(len(dateien)):
    #datei=("{j}".format("AnnotMatrixfull", "SW_feature_Matrix"))
    Dateipfad=folder+dateien[j] 
    sio.absolute_import   
    matlabfile=sio.loadmat(r'{}'.format(Dateipfad)) 
    
    #rewriting the Annotation MAtrix
    if j==0:
        AnnotMatrixfull=matlabfile.get('AnnotMatrixfull')
    elif j==1:
        FeatureMatrix=matlabfile.get('Matrix')
    elif j==2:
        AnnotMatrix=matlabfile.get('AnnotationMatrix')  
        AnnotMatrix=AnnotMatrix.conj().transpose() # transpose the Annotmatrix from row to column
        AnnotMatrix=np.array(AnnotMatrix[1,:]) #take only the first column

for j in range(len(dateien_each_patient)):
    for k in range(len(Neonate)):
        Dateipfad=folder+dateien_each_patient[j]+Neonate[k]
        sio.absolute_import   
        matlabfile=sio.loadmat(r'{}'.format(Dateipfad)) 
    
        #rewriting the Annotation MAtrix

        if j==0:
            FeatureMatrix_each_patient[k]=matlabfile.get('Matrix') 
            FeatureMatrix_each_patient[k]=FeatureMatrix_each_patient[k].transpose() # transpose to datapoints,features
            FeatureMatrix_each_patient[k]=FeatureMatrix_each_patient[k][~np.isnan(FeatureMatrix_each_patient[k]).any(axis=1)]#deleting NAN and turning Matrix to datapoints,Features
#            FeatureMatrix_patients=pd.DataFrame(data=FeatureMatrix_each_patient,index=Neonate)
#            del FeatureMatrix_each_patient
        elif j==1:
            AnnotMatrix_each_patient[k]=matlabfile.get('AnnotationMatrix')  
            AnnotMatrix_each_patient[k]=AnnotMatrix_each_patient[k].transpose() # transpose to datapoints,annotations
            AnnotMatrix_each_patient[k]= np.delete(AnnotMatrix_each_patient[k],(1,2), axis=1) #Reduce AnnotationMatrix to Nx1
            AnnotMatrix_each_patient[k]=AnnotMatrix_each_patient[k][~np.isnan(AnnotMatrix_each_patient[k]).any(axis=1)]#deleting NAN and turning Matrix to datapoints,Features
#   
#            AnnotMatrix_patients=pd.DataFrame(data=AnnotMatrix_each_patient,index=Neonate)                 
#            del AnnotMatrix_each_patient
            
            
            
#create feature dictionary with all names and the indices
features_indx={"totpow":    [1,19,37],
               "VLF":       [2,20,38],
               "LF":        [3,21,39],
               "LFnorm":    [4,22,40],
               "HF":        [5,23,41],  
               "HFnorm":    [6,24,42],
               "ratioLFHF": [7,25,43],
               "SDNN":      [8,26,44],
               "SDANN":     [9,27,45],
               "RMSSD":     [10,28,46],
               "NN10":      [11,29,47],
               "NN20":      [12,30,48],
               "NN30":      [13,31,49],
               "NN50":      [14,32,50],
               "pNN10":     [15,33,51],
               "pNN20":     [16,34,52],
               "pNN30":     [17,35,53],
               "pNN50":     [18,36,54]}    
                   
Class_dict={1:'AS',2:'QS',3:'AW',4:'QW' ,5:'Trans' ,6:'Pos',7:'Not_reliable'} #AS:active sleep   QS:Quiet sleep  AW:Active wake  QW:Quiet wake  Trans:Transition  Pos:Position         

features_dict={"totpow_1min":1,"VLF_1min":2,"LF_1min":3,"LFnorm_1min":4,"HF_1min":5,"HFnorm_1min":6,"ratioLFHF_1min":7,"SDNN_1min":8,"SDANN_1min":9,"RMSSD_1min":10,"NN10_1min":11,"NN20_1min":12,"NN30_1min":13,"NN50_1min":14,"pNN10_1min":15,"pNN20_1min":16,"pNN30_1min":17,"pNN50_1min":18,
              "totpow_3min":19,"VLF_3min":20,"LF_3min":21,"LFnorm_3min":22,"HF_3min":23,"HFnorm_3min":24,"ratioLFHF_3min":25,"SDNN_3min":26,"SDANN_3min":27,"RMSSD_3min":28,"NN10_3min":29,"NN20_3min":30,"NN30_3min":31,"NN50_3min":32,"pNN10_3min":33,"pNN20_3min":34,"pNN30_3min":35,"pNN50_3min":36,
              "totpow_5min":37,"VLF_5min":38,"LF_5min":39,"LFnorm_5min":40,"HF_5min":41,"HFnorm_5min":42,"ratioLFHF_5min":43,"SDNN_5min":44,"SDANN_5min":45,"RMSSD_5min":46,"NN10_5min":47,"NN20_5min":48,"NN30_5min":49,"NN50_5min":50,"pNN10_5min":51,"pNN20_5min":52,"pNN30_5min":53,"pNN50_5min":54}     


feature_idx = dict((y,x) for x,y in features_dict.items())

              
#return (AnnotMatrix, FeatureMatrix, Class_dict, features_dict, features_indx)