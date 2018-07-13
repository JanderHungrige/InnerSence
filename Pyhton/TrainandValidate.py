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
F1=features_dict["pNN50_5min"]-1
F2=features_dict["RMSSD_5min"]-1
F3=features_dict["HFnorm_1min"]-1
#F3=features_dict["SDANN_5min"]-1



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

#--------------------------- STRATIEFIED K FOLD ------------------------------

# TRAIN SVM with strativied-k fold
stf = StratifiedKFold(y_selectedAnnot,n_folds=10,random_state=42)       
clf = SVC(kernel='linear', C=1.0, random_state=42)   
accuracySK  = cross_val_score(clf, X_std, y_selectedAnnot, cv=stf)-0.001 #old what_right
i=0
wertSK=[0]*10 # iniziiere variable mit 10 zeroes
FPrateSK=[0]*10;TPrateSK=[0]*10;AccSK=[0]*10;NegPredValSK=[0]*10;PosPredValSK=[0]*10;SPCSK=[0]*10
folds=arange(1,11)

meanaccSK=[];fp_coll=[];accSK=[]

for train, test in stf:
    clf.fit(X_std[train],y_selectedAnnot[train]) # do svm
    #CALCULATE THE EVALUATION VALUES
    #CONFUSION MATRIX
    y_pred=clf.predict(X_std[test])    
    confmatSK=confusion_matrix(y_true=y_selectedAnnot[test], y_pred=y_pred)  
    assert confmatSK.shape == (2,2), "Confusion matrix should be from binary classification only."  
    #SENSITIVITY SPECIFICITY ACCURACY...
    tn = confmatSK[0,0]; fp = confmatSK[0,1]; fn = confmatSK[1,0]; tp = confmatSK[1,1];
    NP = fn+tp;NN = tn+fp; N  = NP+NN; 
    FPrate=(fp/(fp+tn));FPrateSK[i]=FPrate
    TPrate=(tp/(tp+fn));TPrateSK[i]=TPrate
    SPC=tn/(fp+tn);SPCSK[i]=SPC
    Acc=((tp+tn)/N);AccSK[i]=Acc
    NegPredVal=(1-fn/(fn+tn)); NegPredValSK[i]=NegPredVal
    PosPredVal=(tp/(tp+fp));PosPredValSK[i]=PosPredVal
    #ACCURACY VIA SCORE
    score = clf.score(X_std[test], y_selectedAnnot[test]); wertSK[i]=clf.score(X_std[test], y_selectedAnnot[test])
    accSK.append(score)
    #PRINT
    print('SK train:' ,len(train),'SK test:',len(test))
    print('SK ACCscore: %.3f' % score)
    print('SK ACCcrossvalscore: %.3f' % accuracySK[i])
    print (confmatSK)
    print('FPrate: %.3f' % FPrateSK[i]);
    print('Sensitivity: %.3f' % TPrateSK[i]);
    print('Specivicity: %.3f' %SPCSK[i])
    print('Acc: %.3f'%AccSK[i]);
    print('NegPredVal: %.3f'%NegPredValSK[i]);
    print('PosPredVal: %.3f'%PosPredValSK[i])
    print('---------')
    i=i+1
    meanaccSK=mean(accSK)   
    print('meanaccsK: %.3f' % meanaccSK) 
figure(1);plot(folds,wertSK,'-r',label='svm.score');plot(folds, accuracySK,'b',label='crossvalscore -0.001');title('SK fold');xlabel('Folds');ylabel('score');grid(True);legend(loc='lower left')
#ROC(meanaccK,meanfp,meantp)

#-------------------------------- K FOLD --------------------------------------
## TRAIN SVM with k fold
kf = KFold(len(X_std), n_folds=10, random_state=42)
clf = SVC(kernel='linear', C=1.0, random_state=42)    
accuracyK = cross_val_score(clf, X_std, y_selectedAnnot, cv=kf) -0.001  #old what_right
i=0
wertK=[0]*10 # iniziiere variable mit 10 zeroes
FPrateK=[0]*10;TPrateK=[0]*10;AccK=[0]*10;NegPredValK=[0]*10;PosPredValK=[0]*10;SPCK=[0]*10
folds=arange(1,11)
meanaccK=[];accK=[]

for train, test in kf:
    clf.fit(X_std[train],y_selectedAnnot[train]) # do svm
    #CALCULATE THE EVALUATION VALUES
    #CONFUSION MATRIX
    y_predK=clf.predict(X_std[test])    
    confmatK=confusion_matrix(y_true=y_selectedAnnot[test], y_pred=y_predK)  
    if (confmatK.shape == (2,2)): 
        #SENSITIVITY SPECIFICITY ACCURACY...
        tn = confmatK[0,0]; fp = confmatK[0,1]; fn = confmatK[1,0]; tp = confmatK[1,1];
        NP = fn+tp;NN = tn+fp; N  = NP+NN; 
        FPrate=(fp/(fp+tn));FPrateK[i]=FPrate
        TPrate=(tp/(tp+fn));TPrateK[i]=TPrate
        SPC=tn/(fp+tn);SPCK[i]=SPC
        Acc=((tp+tn)/N);AccK[i]=Acc
        NegPredVal=(1-fn/(fn+tn)); NegPredValK[i]=NegPredVal
        PosPredVal=(tp/(tp+fp));PosPredValK[i]=PosPredVal          
        #ACCURACY VIA SCORE
        score = clf.score(X_std[test], y_selectedAnnot[test]); wertSK[i]=clf.score(X_std[test], y_selectedAnnot[test])
        accK.append(score)
        #PRINT
        print('K train:' ,len(train),'K test:',len(test))
        print('K ACCscore: %.3f' % score)
        print('K ACCcrossvalscore: %.3f' % accuracyK[i])
        print (confmatK)
        print('FPrate: %.3f' % FPrateK[i]);
        print('Sensitivity: %.3f' % TPrateK[i]);
        print('Specivicity: %.3f' %SPCK[i])
        print('Acc: %.3f'%AccK[i]);
        print('NegPredVal: %.3f'%NegPredValK[i]);
        print('PosPredVal: %.3f'%PosPredValK[i])
        print('---------')
    else:
        #ACCURACY VIA SCORE
        score = clf.score(X_std[test], y_selectedAnnot[test]); wertSK[i]=clf.score(X_std[test], y_selectedAnnot[test])
        accK.append(score)

        #PRINT
        print('K train:' ,len(train),'K test:',len(test))
        print('K ACCscore: %.3f' % score)
        print('K ACCcrossvalscore: %.3f' % accuracyK[i])
        print (confmatK)
        print('---------') 
    i=i+1
    meanaccK=mean(accK)   
    print('meanaccK: %.3f' % meanaccK) 
#figure(2);plot(folds,wertK,'-r',label='svm.score');plot(folds, accuracyK,'b',label='crossvalscore -0.001');title('K fold');xlabel('Folds');ylabel('score');grid(True);legend(loc='lower left')

#--------------------------------LEAVE ONE OUT---------------------------------

## Train SVM and validate with leave one out    
#(The file with the HRV features of all patients together is not standardized, the one for each individual patient is)

from sklearn import svm, cross_validation
from sklearn.metrics import roc_curve, auc

clf = svm.SVC(kernel='linear', C=1, probability=True, random_state=42)

#SELECTING THE LABELS FOR SELECTED BABIES
label=array([1,2])
selected_babies =[0,1,2,3,4,5,6,7] #SOMETHING WRONG WITH BABIE 7 [15] 
AnnotMatrix_auswahl=[AnnotMatrix_each_patient[k] for k in selected_babies]              # get the annotation values for selected babies
FeatureMatrix_auswahl=[FeatureMatrix_each_patient[k] for k in selected_babies]

idx=[in1d(AnnotMatrix_each_patient[sb],label) for sb in selected_babies]#.values()]     # which are the idices for AnnotMatrix_each_patient == label
idx=[nonzero(idx[sb])[0] for sb in range(len(selected_babies))]#.values()]              # get the indices where True
y_each_patient=[val[idx[sb],:] for sb, val in enumerate(AnnotMatrix_auswahl) if sb in range(len(selected_babies))] #get the values for y from idx and label


#CREATING THE DATASET WITH F1 F2 F3 WITH SPECIFIC LABELS FOR SELECTED BABIES  
Xfeat=[val[:,(F1,F2,F3)] for sb, val in enumerate(FeatureMatrix_auswahl)]# if sb in selected_babies]#.values()] #selecting top three fearues F1 F2 F3 datapoints
Xfeat=[val[idx[sb],:] for sb, val in enumerate(Xfeat)]#.values()]                                               #selecting the datapoints in label

#TRAIN CLASSIFIER
meanaccLOO=[];accLOO=[];testsubject=[]
mean_tpr = 0.0;mean_fpr = np.linspace(0, 1, 100)

for j in range(len(selected_babies)):
    Selected_training=delete(selected_babies,selected_babies[j])# Babies to train on 0-7
    Selected_test=28-sum(Selected_training) #Babie to test on
    testsubject.append(Selected_test)
    X_train= [Xfeat[k] for k in Selected_training] # combine only babies to train on in list
    y_train=[y_each_patient[k] for k in Selected_training]
    X_train= vstack(X_train) # mergin the data from each list element into one matrix 
    X_test=Xfeat[Selected_test]
    y_train=vstack(y_train)
    y_test=y_each_patient[Selected_test]
    
    probas_=clf.fit(X_train,y_train).predict_proba(X_test)
    print('len probas: %f' % len(probas_[:,1]))
    print('len test: %f' % len(X_test))
    
    # ROC and AUC
    fpr, tpr, thresholds = roc_curve(y_test, probas_[:, 1], pos_label=2)
    if isnan(sum(tpr))== False and isnan(sum(fpr))==False:
        mean_tpr += interp(mean_fpr, fpr, tpr)
        mean_tpr[0] = 0.0
#        fpr_collect=hstack((fpr_collect,fpr));tpr_collect=hstack((tpr_collect,tpr));thresholds_collect=hstack((thresholds_collect,thresholds))#create matrices for mean ROC/AUC
        
    print('len fpr: %f' %len(fpr))
    roc_auc = auc(fpr, tpr)
    plot(fpr, tpr, lw=1, label='ROC fold %d (area = %0.2f)' % (j, roc_auc)) 
    plt.xlim([-0.05, 1.05])
    plt.ylim([-0.05, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver operating characteristic')
    plt.legend(loc="lower right")
    plt.show()    
    
    #CALCULATE THE EVALUATION VALUES
    #CONFUSION MATRIX
#    y_pred=clf.predict(X_test)    
#    confmatloo=confusion_matrix(y_true= y_test, y_pred=y_pred)  
#    if (confmatloo.shape == (2,2)): 
#        #SENSITIVITY SPECIFICITY ACCURACY...
#        tn = confmatloo[0,0]; fp = confmatloo[0,1]; fn = confmatloo[1,0]; tp = confmatloo[1,1];
#        NP = fn+tp;NN = tn+fp; N  = NP+NN; 
#        FPrate=(fp/(fp+tn))
#        TPrate=(tp/(tp+fn))
#        SPC=tn/(fp+tn)
#        Acc=((tp+tn)/N)
#        NegPredVal=(1-fn/(fn+tn))
#        PosPredVal=(tp/(tp+fp))        
#        
#        score = clf.score(X_test,  y_test); 
#        score_train = clf.score(X_train, y_train); 
#    
#        #PRINT
##        print('train:' ,len(X_train),'test:',len(X_test))
##        print (confmatloo)
##        print('FPrate: %.3f' % FPrate)
##        print('Sensitivity: %.3f' % TPrate)
##        print('Specivicity: %.3f' %SPC)
##        print('Acc: %.3f'%Acc)
##        print('train_ACC: %.3f' % score_train)    
##        print('NegPredVal: %.3f'%NegPredVal)
##        print('PosPredVal: %.3f'%PosPredVal)
##        print('---------')
#     
#    score = clf.score(X_test, y_test); 
#    accLOO.append(score)
#    meanaccLOO=mean(accLOO)
#    print('meanACC LOO: %.3f' %meanaccLOO)   

# calculating the mean ROC/AUC

mean_tpr /= len(selected_babies)
mean_tpr[-1] = 1.0
mean_auc = auc(mean_fpr, mean_tpr)

import matplotlib.pyplot as plt #cycle line styles
from itertools import cycle
lines = ["-","--","-.",":","-*","-+-"]
linecycler = cycle(lines)

figure(2); plot(mean_fpr, mean_tpr, next(linecycler), label='Mean ROC (area = %0.2f)' % mean_auc, lw=2)
#meanfpr=mean(fpr_collect,axis=1)
#meantpr=mean(tpr_collect,axis=1)   
#meanthreshold=mean(threshold_collect,axis=1) 
#roc_auc = auc(meanfpr, meantpr)
#figure;plot(meanfpr, meantpr, lw=1, label='AUC = %0.2f' % roc_auc) 
#plt.xlim([-0.05, 1.05])
#plt.ylim([-0.05, 1.05])
#plt.xlabel('False Positive Rate')
#plt.ylabel('True Positive Rate')
#plt.title('Mean receiver operating characteristic')
#plt.legend(loc="lower right")
#plt.show() 

#loo = cross_validation.LeaveOneOut(len(FeatureMatrix_each_patient))
#Accuracy = cross_validation.cross_val_score(clf, X_std, y_selectedAnnot, cv=loo)
#total_acc = np.mean(was_right)
print('total_acc')
print("--- %s seconds ---" % (time.time() - start_time))
