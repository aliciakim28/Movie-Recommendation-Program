function searchMovies(movies)
    genreInput = input('Enter Genre (or leave blank):', 's');
    directorInput = input('Enter Director (or leave blank):', 's');

    similarityThreshold = 2;

    titles = movies(:, 1);  
    genres = movies(:, 2); 
    directors = movies(:, 3);
    ratings = cell2mat(movies(:, 4)); 


    genreMatches = fuzzySearch(genreInput, genres, similarityThreshold);
    directorMatches = fuzzySearch(directorInput, directors, similarityThreshold);

    if ~isempty(genreInput) && ~isempty(directorInput)
        finalMatches = intersect(genreMatches, directorMatches);
    elseif ~isempty(genreInput)
        finalMatches = genreMatches;
    elseif ~isempty(directorInput)
        finalMatches = directorMatches;
    else
        disp('Please enter at least a genre or a director.');
        return;
    end

    if isempty(finalMatches)
        disp('No movies found.');
    else
        disp('Matching Movies:');
        for i = 1:length(finalMatches)
            idx = finalMatches(i);
            if isnan(ratings(idx))
                fprintf('%s (Rating: N/A)\n', titles{idx});
            else
                fprintf('%s (Rating: %.1f)\n', titles{idx}, ratings(idx));
            end
        end
    end
end

function matches = fuzzySearch(inputStr, list, threshold)
    if isempty(inputStr)
        matches = 1:length(list); 
        return;
    end

    if ischar(list)
        list = cellstr(list); 
    end

    matches = find(strcmpi(inputStr, list));

    if isempty(matches)
        distances = cellfun(@(x) levenshtein(inputStr, x), list);
        matches = find(distances <= threshold);
    end
end

function d = levenshtein(s1, s2)
    m = length(s1);
    n = length(s2);
    D = zeros(m + 1, n + 1);

    for i = 1:m + 1
        D(i, 1) = i - 1;
    end
    for j = 1:n + 1
        D(1, j) = j - 1;
    end

    for i = 2:m + 1
        for j = 2:n + 1
            cost = (s1(i - 1) ~= s2(j - 1));
            D(i, j) = min([D(i - 1, j) + 1, D(i, j - 1) + 1, D(i - 1, j - 1) + cost]);
        end
    end

    d = D(m + 1, n + 1);
end