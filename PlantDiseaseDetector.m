%% 
tic;
%% dataset ve testset olusturma
a = 1
imgSets = imageDatastore('train','IncludeSubfolders',true,'LabelSource','foldernames');
[dataSets, testSet] = splitEachLabel(imgSets, 0.8, 'randomize'); % rastgele yuzde80 datasete yuzde20 testsete ayrildi 

%% Extract HOG features from the data set.
b = 2
for i = 1:length(dataSets.Files)
    s = char(dataSets.Files(i));
    img = imread(s);
    [trainingFeatures(i, :), visualization] = extractHOGFeatures(img);
    %subplot(1,2,1);
    %imshow(img);
    %subplot(1,2,2);
    %plot(visualization);
    i
end
%% 
c = 3
trainingLabels = dataSets.Labels;
%% train a classifier 
% fitcecoc uses SVM learners and a 'One-vs-One' encoding scheme.
d = 4
%t = templateSVM('KernelFunction','gaussian');
classifier = fitcecoc(trainingFeatures, trainingLabels);%,'Learners',t);

%% Extract HOG features from the test set.
e = 5
for j = 1:length(testSet.Files)
    s = char(testSet.Files(j));
    img = imread(s);
    [testFeatures(j, :), visualization] = extractHOGFeatures(img);
    %subplot(1,2,1);
    %imshow(img);
    %subplot(1,2,2);
    %plot(visualization);
    j
end
%%
f = 6
testLabels = testSet.Labels;
%% predict
g = 7
predictedLabels = predict(classifier, testFeatures);


%% conf matrix
h = 8
confMat = confusionmat(testLabels, predictedLabels);

%helperDisplayConfusionMatrix(confMat)

toc;
%% 
helperDisplayConfusionMatrix(confMat);
%%

function helperDisplayConfusionMatrix(confMat)

confMat = bsxfun(@rdivide,confMat,sum(confMat,2));

disp("1: Pepper Bacterial Spot");
disp("2: Pepper Healthy");
disp("3: Potato Early Blight");
disp("4: Potato Healthy");
disp("5: Potato Late Blight");
disp("6: Tomato Bacterial Spot");
disp("7: Tomato Early Blight");
disp("8: Tomato Healthy");
disp("9: Tomato Late Blight");
disp("10: Tomato Leaf Mold");
disp("11: Tomato Leaf Spot");
disp("12: Tomato Spider Mites");
disp("13: Tomato Target Spot");
disp("14: Tomato Mosaic Virus");
disp("15: Tomato Yellow Leaf");


colHeadings = arrayfun(@(x)sprintf('%d',x),1:15,'UniformOutput',false);
format = repmat('%-9s',1,11);
header = sprintf(format,'digit  |',colHeadings{:});
fprintf('\n%s\n%s\n',header,repmat('-',size(header)));

% TP = 0;
% TN = 0;
% FP = 0;
% FN = 0;
% 
i = 1;
for idx = 1:15
        str = idx + "";
     fprintf('%-9s',  str + '      |');
     fprintf('%-9.2f', confMat(idx,:));
     fprintf('\n')
end
satir1 = 0;
satir2 = 0;
satir3 = 0;
satir4 = 0;
satir5 = 0;
satir6 = 0;
satir7 = 0;
satir8 = 0;
satir9 = 0;
satir10 = 0;
satir11 = 0;
satir12 = 0;
satir13 = 0;
satir14 = 0;
satir15 = 0;
sutun1 = 0;
sutun2 = 0;
sutun3 = 0;
sutun4 = 0;
sutun5 = 0;
sutun6 = 0;
sutun7 = 0;
sutun8 = 0;
sutun9 = 0;
sutun10 = 0;
sutun11 = 0;
sutun12 = 0;
sutun13 = 0;
sutun14 = 0;
sutun15 = 0;
for i = 1:15
    satir1 = satir1 + confMat(1,i);
    satir2 = satir2 + confMat(2,i);
    satir3 = satir3 + confMat(3,i);
    satir4 = satir4 + confMat(4,i);
    satir5 = satir5 + confMat(5,i);
    satir6 = satir6 + confMat(6,i);
    satir7 = satir7 + confMat(7,i);
    satir8 = satir8 + confMat(8,i);
    satir9 = satir9 + confMat(9,i);
    satir10 = satir10 + confMat(10,i);
    satir11 = satir11 + confMat(11,i);
    satir12 = satir12 + confMat(12,i);
    satir13 = satir13 + confMat(13,i);
    satir14 = satir14 + confMat(14,i);
    satir15 = satir15 + confMat(15,i);
    sutun1 = sutun1 + confMat(i,1);
    sutun2 = sutun2 + confMat(i,2);
    sutun3 = sutun3 + confMat(i,3);
    sutun4 = sutun4 + confMat(i,4);
    sutun5 = sutun5 + confMat(i,5);
    sutun6 = sutun6 + confMat(i,6);
    sutun7 = sutun7 + confMat(i,7);
    sutun8 = sutun8 + confMat(i,8);
    sutun9 = sutun9 + confMat(i,9);
    sutun10 = sutun10 + confMat(i,10);
    sutun11 = sutun11 + confMat(i,11);
    sutun12 = sutun12 + confMat(i,12);
    sutun13 = sutun13 + confMat(i,13);
    sutun14 = sutun14 + confMat(i,14);
    sutun15 = sutun15 + confMat(i,15);
end
total = satir1 + satir2 + satir3 + satir4 + satir5 + satir6 + satir7 + satir8 + satir9 + satir10 + satir11 + satir12 + satir13 + satir14 + satir15;
totalSutun = sutun1 + sutun2 + sutun3 + sutun4 + sutun5 + sutun6 + sutun7 + sutun8 + sutun9 + sutun10 + sutun11 + sutun12 + sutun13 + sutun14 + sutun15;
TP = confMat(1,1) + confMat(2,2) + confMat(3,3) + confMat(4,4) + confMat(5,5) + confMat(6,6) + confMat(7,7) + confMat(8,8) + confMat(9,9) + confMat(10,10) + confMat(11,11) + confMat(12,12) + confMat(13,13) + confMat(14,14) + confMat(15,15);
TN = 4*total - (total+totalSutun);
FP = total - TP;
FN = totalSutun - TP;
accr = (TP + TN)/(TP+TN+FN+FP);

disp(" ");
disp("sensitivity(TP rate) : " + (TP/(TP+FN)));
disp("specificity(TN rate) : " + (TN/(TN+FP)));
disp("accuracy : " + accr);
%satir1 = confMat(1,1) + confMat(1,2) + confMat(1,3) + confMat(1,4);
% satir2 = confMat(2,1) + confMat(2,2) + confMat(2,3) + confMat(2,4);
% satir3 = confMat(3,1) + confMat(3,2) + confMat(3,3) + confMat(3,4);
% satir4 = confMat(4,1) + confMat(4,2) + confMat(4,3) + confMat(4,4);
% sutun1 = confMat(1,1) + confMat(2,1) + confMat(3,1) + confMat(4,1);
% sutun2 = confMat(1,2) + confMat(2,2) + confMat(3,2) + confMat(4,2);
% sutun3 = confMat(1,3) + confMat(2,3) + confMat(3,3) + confMat(4,3);
% sutun4 = confMat(1,4) + confMat(2,4) + confMat(3,4) + confMat(4,4);
% total = satir1 + satir2 + satir3 + satir4;
% totalSutun = sutun1 + sutun2 + sutun3 + sutun4;
% TP = confMat(1,1) + confMat(2,2) + confMat(3,3) + confMat(4,4);
% TN = 4*total - (total+totalSutun);
% FP = total - confMat(1,1) - confMat(2,2) - confMat(3,3) - confMat(4,4);
% FN = totalSutun - confMat(1,1) - confMat(2,2) - confMat(3,3) - confMat(4,4);
% accr = (TP + TN)/(TP+TN+FN+FP);
% disp(" ");
% disp("sensitivity(TP rate) : " + (TP/(TP+FN)));
% disp("specificity(TN rate) : " + (TN/(TN+FP)));
% disp("accuracy : " + accr);
end