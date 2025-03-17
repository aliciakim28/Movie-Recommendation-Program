% This is a program that will interact with the user and let them choose
% where they want to go
while true
    disp('Movie Recommendation System');
    disp('1. Register');
    disp('2. Search by Genre');
    disp('3. Exit');

    choice = input('Enter your choice (1/2/3):');

    switch choice
        case 1
            WelcomePage;
            return; 
        case 2
            newinteractiveMovieSearch();
        case 3
            disp('Exiting program.');
            break;
        otherwise
            disp('Invalid choice, try something else.');
    end

    pause(1);
    
end