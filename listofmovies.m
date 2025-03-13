function movies = listofmovies() %Defined the function, list of movies, with an output named movies
folderPath = 'archive'; %Defined folderPath with 'archive', which is where all the CSV files are stored.
csvFiles = dir(fullfile(folderPath, '*.csv')); %Created a path to store all the CSV files to the variable csvFiles.

movies = {}; %Created an empty array movies to store the datafiles.

for i=1:length(csvFiles) %Created a loop for all the .csv files in the variable csvFiles.
    filename = fullfile(folderPath, csvFiles(i).name); %Stores the names of files in the variable filename.
    opts = detectImportOptions(filename, 'TextType','string','VariableNamingRule','preserve'); %Ensure that texts are read as strings instead of char. Ensure that column names remain the same. Store the result in opts.
    requiredColumns = {'movie_name', 'genre', 'director', 'rating'}; %Extract the columns 'movie_name' 'genre' 'director' and 'rating' from the dataset
    existingColumns = ismember(requiredColumns,opts.VariableNames); %Check if the required columns are in the data files, and store the result in existingColumns as a logical array.

    if all(existingColumns) %If all existingColumns are present in the CSV file
        opts.SelectedVariableNames = requiredColumns; %Read the requiredColumns
        dataTable = readtable(filename, opts); %Store the requiredColumns into a data table.

        movies = [movies;table2cell(dataTable)]; %Change the table to a cell array and stacks it in the variable movies
    end
end
end
function interactiveMovieSearch()

movies = listofmovies(); %load movie data 
if isempty(movies) %check if movies were loaded 
    disp('No movies found in the dataset.'); 
    return; 
end 
%convert movies cell array to table for easier processing 
moviesTable = cell2table(movies, 'VariableNames', {'movie_name', 'genre', 'director'}); 

%ask user for preferences 
userGenre = lower(strtrim(input('Enter preferred genre (or press Enter to skip): ', 's' ))); 
userDirector = lower(strtrim(input('Enter preferred director (or press Enter to skip): ', 's'))); 

%find matching movies with fuzzy search
matches = findMatchingMovies(moviesTable, userGenre, userDirector); %find matching movies 

if isempty(matches)
    disp('No exact matches found. Suggesting alternative recommendations...'); 
    alternativeMatches = findAlternativeRecommendations(moviesTable, userGenre, userDirector); 
    if isempty(alternativeMatches) 
        disp('No alternative movies found.'); 
    else 
        disp('Alternative movie recommendations:'); 
        disp(alternativeMatches.movie_name); 
    end 
else 
    disp('Matching movies:'); 
<<<<<<< HEAD
    disp(matches.movie_name); 
=======
    disp(matches); 
>>>>>>> de5576f632f0757c6f9ef2600ebf85b9fcdbf7e8
end 
end 
function matches = findMatchingMovies(moviesTable, genre, director)
%find movies that match the user's preferred genre and or director 
genreMatches= true(height(moviesTable), 1); 
directorMatches = true(height(moviesTable), 1); 

if ~isempty(genre) 
    genreMatches = contains(lower(moviesTable.genre), genre, 'IgnoreCase', true); 
end 

if ~isempty(director) 
    directorMatches = contains(lower(moviesTable.director), director, 'IgnoreCase', true); 
end 
%apply both filters 
    matches = moviesTable(genreMatches & directorMatches, :); 
end 
 
function recommendations = findAlternativeRecommendations(moviesTable, genre, director)
%suggest alternative recommendations if no exact matches are found 

genreRecommendations = []; 
directorRecommendations = []; 

if ~isempty(genre)
    genreRecommendations = moviesTable(contains(lower(moviesTable.genre), genre, 'IgnoreCase', true), :);  
end
if ~isempty(director)
    directorRecommendations = moviesTable(contains(lower(moviesTable.director), director, 'IgnoreCase', true), :); 
   
end 

recommendations = unique([genreRecommendations; directorRecommendations], 'rows'); 
end 