% This is a program that will interact with the user and let them choose
% where they want to go
while true
    disp('Movie Recommendation System');
    disp('1. Register');
    disp('2. Search by Genre');
    disp('3. View Genre Ratings');
    disp('4. Exit');

    choice = input('Enter your choice (1/2/3/4/5):');

    switch choice
        case 1
            WelcomePage;
        case 2
            genre = input('Enter genre to search:', 's');
            search_by_genre(genre);
        case 3
            visualize_genre_ratings();
        case 4
            disp('Exiting program.');
            break;
        otherwise
            disp('Invalid choice, try something else.');
    end
end