
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
    disp(matches.movie_name); 
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