function interactiveMovieSearch()
%This function performs the interactive movie search function 
movies = listofmovies();
if isempty(movies)
    disp('No movies found in the dataset.'); 
    return; 
end 

%Ensure that the movies dataset is formatted correctly 
if ~iscell(movies) || size(movies, 2) < 3
    error('Invalid movies data format. Expected a cell array with exactly three columns (movie_name, genre, director).');
end 

moviesTable = cell2table(movies(:,1:3), 'VariableNames', {'movie_name', 'genre', 'director'}); 

while true
    %This allows for users to get user preferences for their preferred
    %genre and director
    disp('Enter preferred genre (or press Enter to skip):');
    userGenre = strtrim(string(input('', 's')));

    disp('Enter preferred director (or press Enter to skip):'); 
    userDirector = strtrim(string(input('', 's'))); 

fuzzyGenre = fuzzyMatch(userGenre, string(moviesTable.genre)); %Find a close approximate match to the genre input
fuzzyDirector = fuzzyMatch(userDirector, string(moviesTable.director)); %Find a close approximate to the director input

if userGenre ~= "" && fuzzyGenre ~= "" && userGenre ~= fuzzyGenre %Check if the fuzzy match for the genre is different
    disp(sprintf('Did you mean genre: %s? Showing results...', fuzzyGenre)); %Suggest an alternative genre
end

if userDirector ~= "" && fuzzyDirector ~= "" && userDirector ~= fuzzyDirector %Check if the fuzzy match for the director is different
    disp(sprintf('Did you mean director: %s? Showing results...', fuzzyDirector)); %Suggest an alternative director
end

matches = findMatchingMovies(moviesTable, fuzzyGenre, fuzzyDirector); %Find matching movies

if isempty(matches) %If no exact matches are found
    disp('No exact matches found. Performing fuzzy search for similar director names...'); %Inform user that the program is finding for similar matches
    fuzzyDirector = fuzzyMatch(userDirector, string(moviesTable.director)); %Retry fuzzy matching for the director
end

    if isempty(matches) %If there are still no matches found 
        disp('No exact matches found. Suggesting alternative recommendations...');  %Inform the display of alternative movies
        alternativeMatches = findAlternativeRecommendations(moviesTable, userGenre, userDirector); %Show alternative movie names
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
   
    searchAgain = input('Do you want to search again? (yes/no): ', 's');
    if strcmpi(searchAgain, 'no')
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

function cleanStr = normalizeInput(str) %Normalize the user's input
    str = lower(strtrim(str)); %Remove lowercase and spaces
    str = regexprep(str, '\s+', ''); %Remove extra spaces
    cleanStr = string(str); %Convert to strings
end

function bestMatch = fuzzyMatch(inputStr, itemList) %Find the closest match using fuzzy search algorithm
    if inputStr == "" || isempty(itemList) %If the input is empty
        bestMatch = ""; %Return empty string
        return;
    end

    itemList = string(itemList); %Convert list to string
    itemList = itemList(~ismissing(itemList)); %Remove missing values

    inputStr = normalizeInput(inputStr); %Normalize input string
    minDistance = inf; %Initialize the minimum distance
    bestMatch = ""; %Initialize best match

    for i = 1:length(itemList) %Loop through all existing items
        dist = levenshteinDistance(char(inputStr), char(itemList(i))); %Compute the Levenshtein distance-the min number of character edits required to change one word to another
        if dist < minDistance %If there is a closer match
            minDistance = dist; %Update minimum distance
            bestMatch = string(itemList(i)); %Update best match
        end
    end

    if minDistance > 5  %If match is more different than five character changes, do not consider it
        bestMatch = ""; %Return empty string
    end
end

function d = levenshteinDistance(s1, s2) %Function to compute Levenshtein distance
    s1 = char(s1);%Convert string to characters so that each character is processed individually
    s2 = char(s2);
    
    m = length(s1); %Get the length of the first string
    n = length(s2); %Get the length of the second string
    D = zeros(m+1, n+1); %Initialize the distance matrix

    for i = 1:m+1 %Initialize the first column of the matrix, converting s1 into an empty string
        D(i, 1) = i-1;
    end
    for j = 1:n+1 %Initialize the first row of the matrix, converting s2 to an empty string
        D(1, j) = j-1;
    end

    for i = 2:m+1 %Compute distances
        for j = 2:n+1
            cost = ~(s1(i-1) == s2(j-1)); %Compute cost of the substitution
            D(i, j) = min([D(i-1, j) + 1, D(i, j-1) + 1, D(i-1, j-1) + cost]); %Compute minimum cost
        end
    end

    d = D(m+1, n+1); %Return the final distance value, which is the minimum number of changes required to convert s1 into s2
end