function interactiveMovieSearch()
listofmovies; 
if isempty(movies)
    disp('No movies found in the dataset.'); 
    return; 
end 
moviesTable = cell2table(movies, 'VariableNames', {'movie_name', 'genre', 'director'}); 
userGenre = input('Enter preferred genre (or press Enter to skip): ', 's' ); 

userDirector = input('Enter preferred director (or press Enter to skip): ', 's '); 
matches = findMatchingMovies(moviesTable, userGenre, userDirector); 
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
recommendations = []; 
if ~isempty(genre)
    recommendations = moviesTable(strcmpi(moviesTable.genre, genre), :); 
end
if isempty(recommendations) && ~isempty(director)
    recommendations = moviesTable(strcmpi(moviesTable.director, director), :); 
end 
end 