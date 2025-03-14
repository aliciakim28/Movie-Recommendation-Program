% This is a program that will interact with the user and let them choose
% where they want to go
while true
    disp('Movie Recommendation System');
    disp('1. Register');
    disp('2. Login');
    disp('3. Search by Genre');
    disp('4. View Genre Ratings');
    disp('5. Exit');

    choice = input('Enter your choice (1/2/3/4/5):');

    switch choice
        case 1
            WelcomePage;
        case 2
            user = login_user();
            if isempty(user)
                continue;
            end
        case 3
            genre = input('Enter genre to search:', 's');
            search_by_genre(genre);
        case 4
            visualize_genre_ratings();
        case 5
            disp('Exiting program.');
            break;
        otherwise
            disp('Invalid choice, try something else.');
    end
end