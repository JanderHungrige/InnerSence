# -*- coding: utf-8 -*-
"""
Created on Mon Aug 15 12:05:04 2016

@author: 310122653
"""

# -*- coding: utf-8 -*-
"""
Created on Wed Aug 10 15:01:42 2016

@author: 310122653
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Jun 20 08:47:50 2016

@author: 310122653
"""

from matplotlib import *
from numpy import *
from pylab import *

from Loading_mat_files import *
#from plot_decision_regions import *

from sklearn.cross_validation import *
from sklearn.cross_validation import train_test_split
from sklearn.cross_validation import StratifiedKFold
from sklearn.cross_validation import cross_val_score
from sklearn.cross_validation import KFold

from sklearn import metrics
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix
from sklearn.metrics import roc_curve, auc

from sklearn.discriminant_analysis import LinearDiscriminantAnalysis as LDA
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import Perceptron

from sklearn.svm import SVC
import time

start_time = time.time()
#
F1=features_dict["pNN50_5min"]-1 #-1 because index starts at 0
F2=features_dict["RMSSD_5min"]-1
F3=features_dict["VLF_5min"]-1
#F3=features_dict["SDANN_5min"]-1

classweight=0 # do we want to consider the class imbalance? then =1 

#F1=features_dict["SDNN_5min"]-1
#F2=features_dict["HFnorm_5min"]-1
#F3=features_dict["NN50_3min"]-1

X=FeatureMatrix[:,(F1,F2,F3)]
y=AnnotMatrix


# FINDING THE INDICES FOR THE CHOOSEN LABELS
label=array([1,2])
idx1=where(AnnotMatrix==label[0])
idx2=where(AnnotMatrix==label[1])
idx=np.concatenate((idx1[0],idx2[0]))
idx.sort()

X_selectedAnnot = X[(idx)] 
y_selectedAnnot = y[(idx)]
#
#STANDARDIZE THE FEATURES FOR OPTIMAL PERFORMANCE 
#(The file with the HRV features of all patients together is not standardized, the one for each individual patient is)
#By calling the transform method, we then standardized the training data using those estimated parameters "sample mean" and "std"
sc = StandardScaler()
sc.fit(X_selectedAnnot)
X_std = sc.transform(X_selectedAnnot)
mean_auc_collect=[]


#--------------------------------LEAVE ONE OUT---------------------------------

## Train SVM and validate with leave one out    
#(The file with the HRV features of all patients together is not standardized, the one for each individual patient is)

from sklearn import svm, cross_validation
from sklearn.metrics import roc_curve, auc
selected_babies=[0] # forward
#selected_babies=[7] # backward

#SELECTING THE LABELS FOR SELECTED BABIES
label=array([1,2])
for i in range(1,8): #forward
#for i in range(6,0,-1): # backwards
    selected_babies =append(selected_babies,i) #0-7
    summation=sum(selected_babies)
    
    AnnotMatrix_auswahl=[AnnotMatrix_each_patient[k] for k in selected_babies]              # get the annotation values for selected babies
    FeatureMatrix_auswahl=[FeatureMatrix_each_patient[k] for k in selected_babies]          # get the feature values for the selected patients
    
    idx=[in1d(AnnotMatrix_each_patient[sb],label) for sb in selected_babies]#.values()]     # which are the idices for AnnotMatrix_each_patient == label
    idx=[nonzero(idx[sb])[0] for sb in range(len(selected_babies))]#.values()]              # get the indices where True
    y_each_patient=[val[idx[sb],:] for sb, val in enumerate(AnnotMatrix_auswahl) if sb in range(len(selected_babies))] #get the values for y from idx and label
    
    y_each_patient_dict=dict(zip(selected_babies,y_each_patient)) #combining the values for the babies with the names of the babies
    
    #CREATING THE DATASET WITH F1 F2 F3 WITH SPECIFIC LABELS FOR SELECTED BABIES  
    Xfeat=[val[:,(F1,F2,F3)] for sb, val in enumerate(FeatureMatrix_auswahl)]# if sb in selected_babies]#.values()] #selecting top three fearues F1 F2 F3 datapoints
    Xfeat=[val[idx[sb],:] for sb, val in enumerate(Xfeat)]#.values()]                                               #selecting the datapoints in label
    
    Xfeatdict=dict(zip(selected_babies,Xfeat)) #combining the values for the babies with the names of the babies
    
    #TRAIN CLASSIFIER
    meanaccLOO=[];accLOO=[];testsubject=[];tpr_mean=[];counter=0;
    mean_tpr = 0.0;mean_fpr = np.linspace(0, 1, 100)
    
    #CREATING TEST AND TRAIN SETS
    for j in range(len(selected_babies)):
#        Selected_training=delete(selected_babies,selected_babies[j])# Babies to train on 0-7
        Selected_training=delete(selected_babies,j)# Babies to train on 0-7
        Selected_test=summation-sum(Selected_training) #Babie to test on
        testsubject.append(Selected_test)
        X_train=[Xfeatdict[k] for k in Selected_training] # combine only babies to train on in list
        y_train=[y_each_patient_dict[k] for k in Selected_training]
        X_train= vstack(X_train) # mergin the data from each list element into one matrix 
        X_test=Xfeatdict[Selected_test]
        y_train=vstack(y_train)
        y_test=y_each_patient_dict[Selected_test]
        
    #CALCULATE THE WEIGHTS DUE TO CLASS IMBALANCE
        from compute_class_weight import *   
        class_weight='balanced'
        classes=label
        classlabels=ravel(y_test) # y_test has to be a 1d array for compute_class_weight
        if (classweight==1) and (Selected_test!=7) :# as baby 7 does not have two classes, it is not unbalnced
            cW=compute_class_weight(class_weight, classes, classlabels)
            cWdict={1:cW[0]};cWdict={2:cW[1]} #the class weight need to be a dictionarry of the form:{class_label : value}
            print('cW for patient %i: AS %.3f  QS %.3f' %(j+1,cW[0],cW[1]))
        
    #THE SVM
        if (classweight==1) and (Selected_test!=7) and (Selected_training.all !=7):# as baby 7 does not have two classes, it is not unbalnced
             clf = svm.SVC(kernel='linear', class_weight=cWdict, probability=True, random_state=42)
        else:
            clf = svm.SVC(kernel='linear', C=1, probability=True, random_state=42)
            
        
        if (Selected_training !=7): # probas needs two classes      
            probas_=clf.fit(X_train,y_train).predict_proba(X_test)
            
            # ROC and AUC
            fpr, tpr, thresholds = roc_curve(y_test, probas_[:, 1], pos_label=2)
            if isnan(sum(tpr))== False and isnan(sum(fpr))==False: #trp and fpr should exist
                mean_tpr += interp(mean_fpr, fpr, tpr)
                mean_tpr[0] = 0.0
                counter+=1                      
            
        else: # if only baby with one class in train, skip probas and do normal fit
            clf.fit(X_train,y_train)
                
 
#    score = clf.score(X_test, y_test); 
              
    mean_tpr /= counter#len(selected_babies)
    mean_tpr[-1] = 1.0
    mean_auc = auc(mean_fpr, mean_tpr)      
    figure(3); plot(mean_fpr, mean_tpr, label=' %i patients added; Mean ROC (area = %0.2f)' %(i, mean_auc), lw=2)
    
    mean_auc_collect=append(mean_auc_collect,mean_auc)
    figure(6);plot(i,mean_auc_collect[i-1])
    
figure(7);plot(selected_babies[1:8],mean_auc_collect)

score7 = clf.score(Xfeat[Selected_test], y_each_patient[Selected_test]); 


print("--- %s seconds ---" % (time.time() - start_time))
