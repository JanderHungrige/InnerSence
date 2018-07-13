# -*- coding: utf-8 -*-
"""
Created on Thu Jul  7 15:01:01 2016

@author: 310122653
"""

from matplotlib import *
import numpy as np 
from pylab import *

from Loading_mat_files import *
#from plot_decision_regions import *

from sklearn import *
from sklearn.cross_validation import *
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis as LDA
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import Perceptron
from sklearn.svm import SVC
from sklearn.metrics import confusion_matrix

import time

#start_time = time.time()
##
#F1=features_dict["pNN50_5min"]-1
#F2=features_dict["RMSSD_5min"]-1
#F3=features_dict["HFnorm_1min"]-1
#
##F1=features_dict["SDNN_5min"]-1
##F2=features_dict["HFnorm_5min"]-1
#F3=features_dict["NN50_3min"]-1
#
#X=FeatureMatrix[:,(F1,F2,F3)]
#y=AnnotMatrix

# FINDING THE INDICES FOR THE CHOOSEN LABELS
#label=array([1,2])
#idx1=where(AnnotMatrix==label[0])
#idx2=where(AnnotMatrix==label[1])
#idx=np.concatenate((idx1[0],idx2[0]))
#idx.sort()
#
#X_selectedAnnot = X[(idx)] 
#y_selectedAnnot = y[(idx)]
#
#STANDARDIZE THE FEATURES FOR OPTIMAL PERFORMANCE 
#(The file with the HRV features of all patients together is not standardized, the one for each individual patient is)
#By calling the transform method, we then standardized the training data using those estimated parameters "sample mean" and "std"
#sc = StandardScaler()
#sc.fit(X_selectedAnnot)
#X_std = sc.transform(X_selectedAnnot)
##totmeanfpK=[];totmeanatpK=[];totmeanaccK=[];
## TRAIN SVM with strativied-k fold
#stf = StratifiedKFold(y_selectedAnnot,n_folds=10,random_state=42)   
#c=np.linspace(1,1E3,num=10)
#for j in range(len(c)):       
#    clf = SVC(kernel='linear', C=c[j], random_state=42)   
##    meanfp=[];meantp=[];meanacck=[]
#
#    for train, test in stf:
#        clf.fit(X_std[train],y_selectedAnnot[train]) # do svm
#        #CALCULATE THE EVALUATION VALUES
#        #CONFUSION MATRIX
#        y_pred=clf.predict(X_std[test])    
#        confmatSK=confusion_matrix(y_true=y_selectedAnnot[test], y_pred=y_pred)  
#        assert confmatSK.shape == (2,2), "Confusion matrix should be from binary classification only."  
#        #SENSITIVITY SPECIFICITY ACCURACY...
#        tn = confmatSK[0,0]; fp = confmatSK[0,1]; fn = confmatSK[1,0]; tp = confmatSK[1,1];
##        fp=100*fp/(len(test)) #conversion to %
##        tp=100*tp/(len(test)) #conversion to %        
#
#
#        FPrate=(fp/(fp+tn))
#        TPrate=(tp/(tp+fn))
#        fp_coll.append(FPrate)
#        tp_coll.append(FPrate)
#    tpmean=mean(tp_coll)
#    fpmean=mean(fp_coll)
#    meanfp.append(fpmean)   
#    meantp.append(tpmean)
##        score = clf.score(X_std[test], y_selectedAnnot[test])
###        accSK.append(score)
##          
##        meanaccK=mean(score)  
#totmeanfpK.append(meanfp) 
#totmeanatpK.append(meantp)
##totmeanaccK.append(meanaccK) 
#        
#
#
#
#
#plot(meanfp,meantp) 
#xlim(0,1)
#ylim(0,1)  
#title('ROC')
#xlabel('False positive rate')
#ylabel('True positive rate')
## delete   fp_coll tp_coll


 #----------------------LEAVE ONE OUT------------------------------------------     
import time


start_time = time.time()
#
F1=features_dict["pNN50_5min"]-1
F2=features_dict["RMSSD_5min"]-1
F3=features_dict["HFnorm_1min"]-1

from sklearn import svm, cross_validation
from sklearn.metrics import roc_curve, auc

c=np.linspace(1E-5,1E5,num=20)


#SELECTING THE LABELS FOR SELECTED BABIES
label=array([1,2])
selected_babies =[0,1,2,3,4] #SOMETHING WRONG WITH BABIE 7 [15] 
summation=sum(selected_babies)
AnnotMatrix_auswahl=[AnnotMatrix_each_patient[k] for k in selected_babies]              # get the annotation values for selected babies
FeatureMatrix_auswahl=[FeatureMatrix_each_patient[k] for k in selected_babies]
FeatureMatrix_auswahl2=[StandardScaler().fit_transform(X) for X in FeatureMatrix_auswahl] # scale each patient data on all patients with mean/std



idx=[in1d(AnnotMatrix_each_patient[sb],label) for sb in selected_babies]#.values()]     # which are the idices for AnnotMatrix_each_patient == label
idx=[nonzero(idx[sb])[0] for sb in range(len(selected_babies))]#.values()]              # get the indices where True
y_each_patient=[val[idx[sb],:] for sb, val in enumerate(AnnotMatrix_auswahl) if sb in range(len(selected_babies))] #get the values for y from idx and label


#CREATING THE DATASET WITH F1 F2 F3 WITH SPECIFIC LABELS FOR SELECTED BABIES  
Xfeat=[val[:,(F1,F2,F3)] for sb, val in enumerate(FeatureMatrix_auswahl)]# if sb in selected_babies]#.values()] #selecting top three fearues F1 F2 F3 datapoints
Xfeat=[val[idx[sb],:] for sb, val in enumerate(Xfeat)]#.values()]                                               #selecting the datapoints in label

#LEAVE ONE OUT VALIDATION
#TRAIN CLASSIFIER
testsubject=[]
totmeanFPLOO=[];totmeanTPLOO=[];totmeanaccLOO=[];
fp_coll=[];tp_coll=[];accLOO=[]

for p in range(len(c)):       
    clf = SVC(kernel='linear', C=c[p], probability=True, random_state=42)   
    meanfp=[];meantp=[];meanaLOO=[];accLOO=[]
    tp_coll=[];fp_coll=[]
    print('wo samma?: c ist bei Wert ',p+1,'von' , len(c))

    for j in range(len(selected_babies)):
        Selected_training=delete(selected_babies,selected_babies[j])# Babies to train on 0-7
        Selected_test=summation-sum(Selected_training) #Babie to test on
        testsubject.append(Selected_test)
        Xfeat_train= [Xfeat[k] for k in Selected_training] # combine only babies to train on in list
        y_train=[y_each_patient[k] for k in Selected_training]
        Xfeat_train = vstack(Xfeat_train) # mergin the data from each list element into one matrix 
        y_train=vstack(y_train)
        
        clf.fit(Xfeat_train,y_train)
        #CALCULATE THE EVALUATION VALUES
        #CONFUSION MATRIX
        y_pred=clf.predict(Xfeat[Selected_test])
#        probas_ = clf.fit(Xfeat_train, y_train).predict_proba(Xfeat[Selected_test])
        confmatloo=confusion_matrix(y_true=y_each_patient[Selected_test], y_pred=y_pred) 
        # Compute ROC curve and area the curve
#        fpr, tpr, thresholds = roc_curve(y_each_patient[Selected_test], probas_[:, 1],pos_label=2)  
 
#        plot(fpr, tpr, lw=1, label='ROC fold %d (area = %0.2f)' % (i, roc_auc))
#        print('Da samma: Wir sind bei patient ', j+1,'von' , len(selected_babies))
        
        if (confmatloo.shape == (2,2)): 
            #SENSITIVITY SPECIFICITY ACCURACY...
            tn = confmatloo[0,0]; fp = confmatloo[0,1]; fn = confmatloo[1,0]; tp = confmatloo[1,1];
            NP = fn+tp;NN = tn+fp; N  = NP+NN; 
#            fp=100*fp/(len(Xfeat[Selected_test])) #conversion to %
#            tp=100*tp/(len(Xfeat[Selected_test])) #conversion to %

            FPrate=(fp/(fp+tn))
            TPrate=(tp/(tp+fn))
            print('fp rate: %3.f' % FPrate)
            print('tp rate: %3.f' % TPrate)                   
            fp_coll.append(FPrate)
            tp_coll.append(TPrate)            
            SPC=tn/(fp+tn)
            Acc=((tp+tn)/N)
            NegPredVal=(1-fn/(fn+tn))
            PosPredVal=(tp/(tp+fp))        
            score = clf.score(Xfeat[Selected_test], y_each_patient[Selected_test]); 
            score_train = clf.score(Xfeat_train, y_train); 
            print('score: %3.f' %score)
            accLOO.append(score)
            meantp=mean(tp_coll)
            meanfp=mean(fp_coll)           
            meanaccLOO=mean(accLOO) 
    
    totmeanFPLOO.append(meanfp) 
    totmeanTPLOO.append(meantp)
    totmeanaccLOO.append(meanaccLOO)     


figure(2);plot(totmeanFPLOO,totmeanTPLOO) 
xlim(0,1)
ylim(0,1)  
title('Cost function')
xlabel('Cost False positive rate')
ylabel('Cost True positive rate')