function similar_movies(movie_name)

global movies
movie_idx = find(strcmp(movies(0,0), movie_name)); % Finding movie index

if isempty(movie_idx)
    disp('Movie not found!');
    return;
end

movie_genre = (movies{movie_idx, 2});

disp('Movies with similar genre:');
for ii = 1:size(movies, 1)
    if strcmpi(movies{ii, 2}, movie_genre) && ~strcmp(movies{ii, 1}, movie_name)
        fprintf('%s (%.1f)\n', movies{ii, 1}, movies{ii, 5});
    end
end
end