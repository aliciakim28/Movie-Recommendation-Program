function interactiveMovieSearch()
movies = listofmovies();
if isempty(movies)
    disp('No movies found in the dataset.'); 
    return; 
end 

if ~iscell(movies) || size(movies, 2) < 3
    error('Invalid movies data format. Expected a cell array with exactly three columns (movie_name, genre, director).');
end 

moviesTable = cell2table(movies(:,1:3), 'VariableNames', {'movie_name', 'genre', 'director'}); 

while true
    disp('Enter preferred genre (or press Enter to skip):');
    userGenre = strtrim(string(input('', 's')));

    disp('Enter preferred director (or press Enter to skip):'); 
    userDirector = strtrim(string(input('', 's'))); 

fuzzyGenre = fuzzyMatch(userGenre, string(moviesTable.genre));
fuzzyDirector = fuzzyMatch(userDirector, string(moviesTable.director));

if userGenre ~= "" && fuzzyGenre ~= "" && userGenre ~= fuzzyGenre
    disp(sprintf('Did you mean genre: %s? Showing results...', fuzzyGenre));
end

if userDirector ~= "" && fuzzyDirector ~= "" && userDirector ~= fuzzyDirector
    disp(sprintf('Did you mean director: %s? Showing results...', fuzzyDirector));
end

matches = findMatchingMovies(moviesTable, fuzzyGenre, fuzzyDirector); 

if isempty(matches)
    disp('No exact matches found. Performing fuzzy search for similar director names...');
    
    fuzzyDirector = fuzzyMatch(userDirector, string(moviesTable.director));
    
    if fuzzyDirector ~= ""
        disp(['Did you mean: ', fuzzyDirector, '? Showing results...']);
        matches = findMatchingMovies(moviesTable, userGenre, fuzzyDirector);
    end
end

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
        disp(unique(matches.movie_name, 'stable')); 
    end
   
    searchAgain = input('Do you want to search again? (y/n): ', 's');
    if strcmpi(searchAgain, 'n')
        disp('Returning to main menu...');
        return;
    end
end
end

function matches = findMatchingMovies(moviesTable, genre, director)
movieGenres = string(moviesTable.genre); 
movieDirectors = string(moviesTable.director);

genreMatches = true(height(moviesTable), 1); 
directorMatches = true(height(moviesTable), 1);

if genre ~= ""
    genreMatches = contains(movieGenres, genre, 'IgnoreCase', true); 
end 

if director ~= ""
    directorMatches = contains(movieDirectors, director, 'IgnoreCase', true);
end 

matches = moviesTable(genreMatches & directorMatches, :); 

if genre == "" && director == "" 
    matches = moviesTable([],:); 
end 
end 


function recommendations = findAlternativeRecommendations(moviesTable, genre, director) 

movieGenres = string(moviesTable.genre); 
movieDirectors = string(moviesTable.director); 

genreRecommendations = moviesTable([],:); 
directorRecommendations = moviesTable([],:); 

if genre ~= ""
    genreRecommendations = moviesTable(contains(movieGenres, genre, 'IgnoreCase', true), :); 
end 
if director ~= "" 
    directorRecommendations = moviesTable(contains(movieDirectors, director, 'IgnoreCase', true), :); 

end 
recommendations = [genreRecommendations; directorRecommendations]; 
[~, uniqueIdx] = unique(recommendations.movie_name, 'stable');
recommendations = recommendations(uniqueIdx,:);
end 

function cleanStr = normalizeInput(str)
    str = lower(strtrim(str)); 
    str = regexprep(str, '\s+', '');
    cleanStr = string(str);
end

function bestMatch = fuzzyMatch(inputStr, itemList)
    if inputStr == "" || isempty(itemList)
        bestMatch = "";
        return;
    end

    itemList = string(itemList);
    itemList = itemList(~ismissing(itemList)); 

    inputStr = normalizeInput(inputStr);
    minDistance = inf;
    bestMatch = "";

    for i = 1:length(itemList)
        dist = levenshteinDistance(char(inputStr), char(itemList(i)));
        if dist < minDistance
            minDistance = dist;
            bestMatch = string(itemList(i));
        end
    end

    if minDistance > 5  
        bestMatch = "";
    end
end

function d = levenshteinDistance(s1, s2)
    s1 = char(s1);
    s2 = char(s2);
    
    m = length(s1);
    n = length(s2);
    D = zeros(m+1, n+1);

    for i = 1:m+1
        D(i, 1) = i-1;
    end
    for j = 1:n+1
        D(1, j) = j-1;
    end

    for i = 2:m+1
        for j = 2:n+1
            cost = ~(s1(i-1) == s2(j-1));
            D(i, j) = min([D(i-1, j) + 1, D(i, j-1) + 1, D(i-1, j-1) + cost]);
        end
    end

    d = D(m+1, n+1);
end