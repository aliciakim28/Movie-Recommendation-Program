% This is a program that will interact with the user and let them choose
% where they want to go
while true % Infinite loop to keep the menu running until the user chooses where they want to go
    % Displaying the menu options
    disp('Movie Recommendation System');
    disp('1. Register');
    disp('2. Search by Genre');
    disp('3. Exit');

    % Asking the user where they want to go
    choice = input('Enter your choice (1/2/3):');

    % Handle the user input if they want to switch their choice
    switch choice
        case 1 % Call the registration page
            WelcomePage;
            return; % Exit the program after registration
        case 2 % Call the movie search function
            newinteractiveMovieSearch();
        case 3
            disp('Exiting program.'); % Exit the loop and terminate the program
            break;
        otherwise % Handle invalid inputs
            disp('Invalid choice, try something else.');
    end

    pause(1); % Pause for a second before redisplaying the menu to improve the user's experience
    
end