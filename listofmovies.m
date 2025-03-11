<<<<<<< Updated upstream
=======
<<<<<<< HEAD
=======
>>>>>>> Stashed changes
import kagglehub

pip install kaggle

% Download latest version
path = kagglehub.dataset_download("rajugc/imdb-movies-dataset-based-on-genre");

print("Path to dataset files:", path)

system("kaggle datasets download -d rajugc/imdb-movies-dataset-based-on-genre");

unzip("imdb-movies-dataset-based-on-genre.zip");
disp("Path to dataset files:");
dataset = readtable("imdb-movies-dataset.csv");
disp(dataset(1:10, :));

dir('*.zip')
<<<<<<< Updated upstream
=======
>>>>>>> 7ad9bde7c8f1dec3eb971c42805cbc73800203a4
>>>>>>> Stashed changes
