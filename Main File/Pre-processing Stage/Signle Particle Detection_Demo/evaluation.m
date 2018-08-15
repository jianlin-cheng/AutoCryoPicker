function [ acc,sen,pre,FP_rate,TP_rate,Miss_class,F_1_score] = evaluation( confusion )
%PERFORMANCE evaluate the performance of prediction 
%   against true labels

% calculate the sensitivity = t-pos/pos  /* true positive recognition rate */
TP=confusion(1);
FN=confusion(2);
FP=confusion(3);
TN=confusion(4);
Total=TP+FN+FP+TN;
 
% Sensitivity or true positive rate (TPR).. sen=TP/(TP+FN)
  sen=TP/(TP+FN);

% Precision or positive predictive value (PPV)..prec=TP/(TP+FP)
  pre=TP/(TP+FP);

% True Positive Rate
  TP_rate=TP/(TP+FP);

% False Positive Rate
  FP_rate=FP/(TN+FP);

% Misclassification Rate = (FP+FN)/total 
  Miss_class=(FP+FN)/Total;

% Accuracy
  acc = (TP+TN)/Total;
  
% F1 score  
  F_1_score=(2*TP)/(2*TP+FP+FN);
  
% display(confusion);
fprintf('True  Positive Detection Rate =\t %0.4f\n',TP_rate);
fprintf('False Postive  Detection Rate =\t %0.4f\n',FP_rate);
fprintf('Sensitivity  =\t %0.4f\n',sen);
fprintf('Precision (Recall) =\t %0.4f\n',pre);
fprintf('Misclassification Rate (Overall, how often is it wrong) =\t %0.4f\n',Miss_class);
fprintf('F1 Score =\t %0.4f\n',F_1_score);
fprintf('Accuracy =\t %0.4f\n',acc);
disp(' ');
%
end