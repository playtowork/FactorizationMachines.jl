module TestFMDatasetML100K

using FactorizationMachines
using Base.Test

info("Running tests on ml-100k dataset...")
(ml100kTrain, ml100kTrainRatings) = @time fmReadLibSVM("data/ml-100k.train.libfm")
info("Train dim: $(size(ml100kTrain))")
(ml100kTest, ml100kTestRatings) = @time fmReadLibSVM("data/ml-100k.test.libfm")
info("Test dim: $(size(ml100kTest))")

info("Test ML-100K - Training model...")
fmMl100k = @time fmTrain(ml100kTrain, ml100kTrainRatings, :sgd, 10, (1,1,4), (.0,.0,.0), 0.1 )
#info("FM Model: $fmMl100k")
info("Test ML-100K - Prediction over test dataset...")
p = @time fmPredict(fmMl100k, ml100kTest)

@test length(p) == length(ml100kTestRatings)

rmse = sqrt(sum((p-ml100kTestRatings).^2)/length(p))
info("RMSE on test data: $rmse") 

if isfile("data/ml-100k.output.libfm")
    info("File with output from libfm exists. Bencharking to its result...")
    libfmOutput = readcsv("data/ml-100k.output.libfm")
    rmseWithLibfm = sqrt(sum((p-libfmOutput).^2)/length(p))
    info("RMSE with Libfm output: $rmseWithLibfm")
end

end
