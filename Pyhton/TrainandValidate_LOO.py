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

#from sklearn.cross_validation import *
#from sklearn.cross_validation import train_test_split
from sklearn.cross_validation import StratifiedKFold
from sklearn.cross_validation import cross_val_score
from sklearn.cross_validation import KFold

#from sklearn.metrics import *
from sklearn.metrics import accuracy_score 
from sklearn.metrics import confusion_matrix
from sklearn.metrics import roc_curve, auc

from sklearn import svm, cross_validation
#from sklearn.svm import SVC

from sklearn.discriminant_analysis import LinearDiscriminantAnalysis as LDA
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import Perceptron
from compute_class_weight import *   
from itertools import cycle #cycle line styles


import time

start_time = time.time()

classweight=0 # do we want to concider the class imbalance? then =1 
savefig=0
#WHICH FEATURE TO TRAIN AND TEST ON. 
#0.45
#F1=features_dict["pNN50_5min"]-1
#F2=features_dict["RMSSD_5min"]-1
#F3=features_dict["HFnorm_1min"]-1

#0.75 (Without NNx)
#F1=features_dict["pNN50_5min"]-1
#F2=features_dict["RMSSD_5min"]-1
#F3=features_dict["VLF_5min"]-1

#0.87 Top4 CFS (only 5min)
F1=features_dict["NN10_5min"]-1
F2=features_dict["pNN50_5min"]-1
F4=features_dict["pNN10_5min"]-1
F3=features_dict["VLF_5min"]-1

#0.85 CFS+FSMC
#F1=features_dict["NN10_5min"]-1
#F2=features_dict["pNN50_5min"]-1
#F3=features_dict["pNN10_5min"]-1
#F4=features_dict["VLF_5min"]-1
#F5=features_dict["NN50_1min"]-1

F3=features_dict["VLF_5min"]-1
F1=features_dict["HFnorm_5min"]-1
F2=features_dict["totpow_5min"]-1
F4=features_dict["LFnorm_5min"]-1

#F1=features_dict["VLF_5min"]-1
#F2=features_dict["HFnorm_5min"]-1
#F3=features_dict["totpow_5min"]-1
#F4=features_dict["LFnorm_5min"]-1


#F1=features_dict["pNN50_5min"]-1
#F2=features_dict["SDANN_5min"]-1
#F3=features_dict["HFnorm_1min"]-1

#CHANGE HERE FOR DIFFERNT AMOUNT OF FEATURES TO TEST / ALSO CHANGE FURTHER DOWN LINE 93+ ONWARDS
#X=FeatureMatrix[:,(F1,F2,F3)]
##X=FeatureMatrix[:,(F1,F2)]
#y=AnnotMatrix
#
## FINDING THE INDICES FOR THE CHOOSEN LABELS
#label=array([1,2])
#idx1=where(AnnotMatrix==label[0])
#idx2=where(AnnotMatrix==label[1])
#idx=np.concatenate((idx1[0],idx2[0]))
#idx.sort()
#
#X_selectedAnnot = X[(idx)] 
#y_selectedAnnot = y[(idx)]

#STANDARDIZE THE FEATURES FOR OPTIMAL PERFORMANCE 
#(The file with the HRV features of all patients together is not standardized, the one for each individual patient is)
#By calling the transform method, we then standardized the training data using those estimated parameters "sample mean" and "std"
#sc = StandardScaler()
#sc.fit(X_selectedAnnot)
#X_std = sc.transform(X_selectedAnnot)

sc = StandardScaler()
for i in range(len(FeatureMatrix_each_patient)):
    sc.fit(FeatureMatrix_each_patient[i])
    FeatureMatrix_each_patient[i]=sc.transform(FeatureMatrix_each_patient[i])

#--------------------------------LEAVE ONE OUT---------------------------------

## Train SVM and validate with leave one out    
#(The file with the HRV features of all patients together is not standardized, the one for each individual patient is)

#SELECTING THE LABELS FOR SELECTED BABIES
label=array([1,2])
selected_babies =[0,1,2,3,4,5,6,7] #0-7
summation=sum(selected_babies)
AnnotMatrix_auswahl=[AnnotMatrix_each_patient[k] for k in selected_babies]              # get the annotation values for selected babies
FeatureMatrix_auswahl=[FeatureMatrix_each_patient[k] for k in selected_babies]

idx=[in1d(AnnotMatrix_each_patient[sb],label) for sb in selected_babies]#.values()]     # which are the idices for AnnotMatrix_each_patient == label
idx=[nonzero(idx[sb])[0] for sb in range(len(selected_babies))]#.values()]              # get the indices where True
y_each_patient=[val[idx[sb],:] for sb, val in enumerate(AnnotMatrix_auswahl) if sb in range(len(selected_babies))] #get the values for y from idx and label


#CREATING THE DATASET WITH F1 F2 F3 WITH SPECIFIC LABELS FOR SELECTED BABIES  
#Xfeat=[val[:,(F1,F2)] for sb, val in enumerate(FeatureMatrix_auswahl)]# if sb in selected_babies]#.values()] #selecting top three fearues F1 F2 F3 datapoints
#Xfeat=[val[:,(F1,F2,F3)] for sb, val in enumerate(FeatureMatrix_auswahl)]# if sb in selected_babies]#.values()] #selecting top three fearues F1 F2 F3 datapoints
Xfeat=[val[:,(F1,F2,F3,F4)] for sb, val in enumerate(FeatureMatrix_auswahl)]# if sb in selected_babies]#.values()] #selecting top three fearues F1 F2 F3 datapoints
#Xfeat=[val[:,(F1,F2,F3,F4,F5)] for sb, val in enumerate(FeatureMatrix_auswahl)]# if sb in selected_babies]#.values()] #selecting top three fearues F1 F2 F3 datapoints
Xfeat=[val[idx[sb],:] for sb, val in enumerate(Xfeat)]#.values()]                                               #selecting the datapoints in label




#TRAIN CLASSIFIER
meanaccLOO=[];accLOO=[];testsubject=[];tpr_mean=[];counter=0;
mean_tpr = 0.0;mean_fpr = np.linspace(0, 1, 100)

print ('initialisation process complete')

#CREATING TEST AND TRAIN SETS
for j in range(len(selected_babies)):
    Selected_training=delete(selected_babies,selected_babies[j])# Babies to train on 0-7
    Selected_test=summation-sum(Selected_training) #Babie to test on
    testsubject.append(Selected_test)
    X_train= [Xfeat[k] for k in Selected_training] # combine only babies to train on in list
    y_train=[y_each_patient[k] for k in Selected_training]
    X_train= vstack(X_train) # mergin the data from each list element into one matrix 
    X_test=Xfeat[Selected_test]
    y_train=vstack(y_train)
    y_test=y_each_patient[Selected_test]
    print ('create test and training set for preterm: ', j+1)
#CALCULATE THE WEIGHTS DUE TO CLASS IMBALANCE
    class_weight='balanced'
    classes=label
    classlabels=ravel(y_test) # y_test has to be a 1d array for compute_class_weight
    if (classweight==1) and (Selected_test!=7):# as baby 7 does not have two classes, it is not unbalnced
        cW=compute_class_weight(class_weight, classes, classlabels)
        cWdict={1:cW[0]};cWdict={2:cW[1]} #the class weight need to be a dictionarry of the form:{class_label : value}
        print('cW for patient %i: AS %.3f  QS %.3f' %(j+1,cW[0],cW[1]))   
#THE SVM
    if (classweight==1) and (Selected_test!=7):# as baby 7 does not have two classes, it is not unbalnced
         clf = svm.SVC(kernel='linear', class_weight=cWdict, probability=True, random_state=42)
    else:
        clf = svm.SVC(kernel='linear', C=1, probability=True, random_state=42)
    print('SVM setup for preterm: ',j+1 ,' complete' )          
    probas_=clf.fit(X_train,y_train).predict_proba(X_test)  
    print('probas calculated for preterm: ', j+1)
# ROC and AUC
    fpr, tpr, thresholds = roc_curve(y_test, probas_[:, 1], pos_label=2)
    if isnan(sum(tpr))== False and isnan(sum(fpr))==False:
        mean_tpr += interp(mean_fpr, fpr, tpr)
        mean_tpr[0] = 0.0
        counter+=1

    roc_auc = auc(fpr, tpr)
    print('ROC and AUC calculated for preterm: ', j+1)
 
    lines = ["-","--","-.",":","-*","-+-"]
    linecycler = cycle(lines)
#    
#    figure(1,facecolor="white");
#    plot(fpr, tpr, lw=1, ls=next(linecycler), label='ROC fold %d (area = %0.2f)' % (j, roc_auc)) 
#    plt.xlim([-0.05, 1.05])
#    plt.ylim([-0.05, 1.05])
#    plt.xlabel('False Positive Rate')
#    plt.ylabel('True Positive Rate')        
#    plt.legend(loc="lower right")
#    plt.show()
#    plt.rcParams.update({'font.size': 16})
#    print ('next preterm or end')
#    if savefig==1:
#        plt.savefig('C:/Users/310122653/Documents/PhD/Article 1/FIgures/Autosave/ROC 0.91.svg',format='svg', dpi=600)
#        plt.savefig('C:/Users/310122653/Documents/PhD/Article 1/FIgures/Autosave/ROC 0.91.eps', format='eps', dpi=1000)
#        plt.savefig('C:/Users/310122653/Documents/PhD/Article 1/FIgures/Autosave/ROC 0.91.tiff', format='tiff', dpi=600)
#

mean_tpr /= counter#len(selected_babies)
mean_tpr[-1] = 1.0
mean_auc = auc(mean_fpr, mean_tpr)      

#figure(facecolor="white"); plot(mean_fpr, mean_tpr, label='Mean ROC (area = %0.2f)' % mean_auc, lw=2)
#plt.xlabel('Mean False Positive Rate')
#plt.ylabel('Mean True Positive Rate') 
#legend(loc=4) 
#plt.rcParams.update({'font.size': 16})
if savefig==1:
    plt.savefig('C:/Users/310122653/Documents/PhD/Article 1/FIgures/Autosave/meanROC 0.91.svg',format='svg', dpi=600)
    plt.savefig('C:/Users/310122653/Documents/PhD/Article 1/FIgures/Autosave/meanROC 0.91.eps', format='eps', dpi=1000)
    plt.savefig('C:/Users/310122653/Documents/PhD/Article 1/FIgures/Autosave/meanROC 0.91.tiff', format='tiff', dpi=600)

#loo = cross_validation.LeaveOneOut(len(FeatureMatrix_each_patient))
#Accuracy = cross_validation.cross_val_score(clf, X_std, y_selectedAnnot, cv=loo)
#total_acc = np.mean(was_right)
print('total_acc')
print("--- %s seconds ---" % (time.time() - start_time))
