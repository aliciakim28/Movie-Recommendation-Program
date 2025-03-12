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
userGenre = input('Enter preferred genre (or press Enter to skip): ', 's' ); 
userDirector = input('Enter preferred director (or press Enter to skip): ', 's '); 

matches = findMatchingMovies(moviesTable, userGenre, userDirector); %find matching movies 

if isempty(matches)
    disp('No exact matches found. Suggesting alternative recommendations...'); 
    alternativeMatches = findAlternativeRecommendations(moviesTable, userGenre, userDirector); 
    if isempty(alternativeMatches) 
        disp('No alternative movies found.'); 
    else 
        disp('Alternative movie recommendations:'); 
        disp(alternativeMatches); 
    end 
else 
    disp('Matching movies:'); 
    disp(matches); 
end 
end 
function matches = findMatchingMovies(moviesTable, genre, director)
%find movies that match the user's preferred genre and or director 
matches = []; 
if ~isempty(genre) && ~isempty(director) 
    matches = moviesTable(strcmpi(moviesTable.genre, genre) & strcmpi(moviesTable.director, director), :); 
elseif ~isempty(genre) 
    matches = moviesTable(strcmpi(moviesTable.genre, genre), :); 
elseif ~isempty(director) 
    matches = moviesTable(strcmpi(moviesTable.director, director), :); 
end 
end 
function recommendations = findAlternativeRecommendations(moviesTable, genre, director)
%if no exact matches are found, suggest other movies based on genre or
%director 
recommendations = []; 
if ~isempty(genre)
    recommendations = moviesTable(strcmpi(moviesTable.genre, genre), :); 
end
if isempty(recommendations) && ~isempty(director)
    recommendations = moviesTable(strcmpi(moviesTable.director, director), :); 
end 
end 