system("kaggle datasets download -d rajugc/imdb-movies-dataset-based-on-genre");

unzip("imdb-movies-dataset-based-on-genre.zip");
disp("Path to dataset files:");
dataset = readtable("imdb-movies-dataset.csv");
disp(dataset(1:5, :));