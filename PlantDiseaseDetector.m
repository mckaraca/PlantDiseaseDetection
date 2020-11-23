%% dataset ve testset olusturma
imgSets = imageDatastore('test','IncludeSubfolders',true,'LabelSource','foldernames');
[dataSets, testSet] = splitEachLabel(imgSets, 0.8, 'randomize'); % rastgele yuzde80 datasete yuzde20 testsete ayrildi 
%% Extract HOG features from the data set.

for i = 1:length(dataSets.Files)
    s = char(dataSets.Files(i));
    img = imread(s);
    [trainingFeatures(i, :), visualization] = extractHOGFeatures(img);
    subplot(1,2,1);
    imshow(img);
    subplot(1,2,2);
    plot(visualization);
end
%% 
trainingLabels = dataSets.Labels;
%% train a classifier 
% fitcecoc uses SVM learners and a 'One-vs-One' encoding scheme.
classifier = fitcecoc(trainingFeatures, trainingLabels);

%% Extract HOG features from the test set.
for i = 1:length(testSet.Files)
    s = char(testSet.Files(i));
    img = imread(s);
    [testFeatures(i, :), visualization] = extractHOGFeatures(img);
    subplot(1,2,1);
    imshow(img);
    subplot(1,2,2);
    plot(visualization);
end
%%
testLabels = testSet.Labels;
%% predict

predictedLabels = predict(classifier, testFeatures);


%% conf matrix
confMat = confusionmat(testLabels, predictedLabels);

helperDisplayConfusionMatrix(confMat)


function helperDisplayConfusionMatrix(confMat)

confMat = bsxfun(@rdivide,confMat,sum(confMat,2));

disp("1: Black Rot");
disp("2: Healthy");
disp("3: Rust");
disp("4: Scab");

digits = '0':'3';
colHeadings = arrayfun(@(x)sprintf('%d',x),1:4,'UniformOutput',false);
format = repmat('%-9s',1,11);
header = sprintf(format,'digit  |',colHeadings{:});
fprintf('\n%s\n%s\n',header,repmat('-',size(header)));

TP = 0;
TN = 0;
FP = 0;
FN = 0;

for idx = 1:numel(digits)
    fprintf('%-9s',   [digits(idx)+1 '      |']);
    fprintf('%-9.2f', confMat(idx,:));
    fprintf('\n')
end
satir1 = confMat(1,1) + confMat(1,2) + confMat(1,3) + confMat(1,4);
satir2 = confMat(2,1) + confMat(2,2) + confMat(2,3) + confMat(2,4);
satir3 = confMat(3,1) + confMat(3,2) + confMat(3,3) + confMat(3,4);
satir4 = confMat(4,1) + confMat(4,2) + confMat(4,3) + confMat(4,4);
sutun1 = confMat(1,1) + confMat(2,1) + confMat(3,1) + confMat(4,1);
sutun2 = confMat(1,2) + confMat(2,2) + confMat(3,2) + confMat(4,2);
sutun3 = confMat(1,3) + confMat(2,3) + confMat(3,3) + confMat(4,3);
sutun4 = confMat(1,4) + confMat(2,4) + confMat(3,4) + confMat(4,4);
total = satir1 + satir2 + satir3 + satir4;
totalSutun = sutun1 + sutun2 + sutun3 + sutun4;
TP = confMat(1,1) + confMat(2,2) + confMat(3,3) + confMat(4,4);
TN = 4*total - (total+totalSutun);
FP = total - confMat(1,1) - confMat(2,2) - confMat(3,3) - confMat(4,4);
FN = totalSutun - confMat(1,1) - confMat(2,2) - confMat(3,3) - confMat(4,4);
accr = (TP + TN)/(TP+TN+FN+FP);
disp(" ");
disp("sensitivity(TP rate) : " + (TP/(TP+FN)));
disp("specificity(TN rate) : " + (TN/(TN+FP)));
disp("accuracy : " + accr);
end