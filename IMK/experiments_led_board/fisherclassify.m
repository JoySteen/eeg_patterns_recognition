% Классификация
function results = fisherclassify(mdl,features)
results = mdl.weights*features > mdl.threshold;
return
