% Function to visualize the average ratings of different movie genres
function genre_ratings()

global movies

% If the movie does not have a rating (NaN), then the result should display
% an error
if isempty(movies)
    error("This movie does not yet have a rating.");
end

genres = unique(movies(1:5,:));
avg_ratings = zeros(1, length(genres));

for ii = 1:length(genres)
    genre_ratings = [];
    for jj = 1:size(movies,1)
        if strcmp(movies{jj,2}, genres{ii})
            genre_ratings = [genre_ratings, movies{jj,5}];
        end
    end
    avg_ratings(ii) = mean(genre_ratings);
end

% Showing an image of the average ratings of movie genres
bar(avg_ratings);
set(gca, 'XTickLabel', genres);
title('Average Ratings by Genre');
xlabel('Genre');
ylabel('Average Rating');
end