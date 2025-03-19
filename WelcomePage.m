function movie_recommendation_system %Defined the main function, movie_recommendation_system
movie_recommendation_welcome(); %Calls on the function movie_recommendation_welcome to create a welcome page
end

function movie_recommendation_welcome()
fig = figure('Name', 'Movie Recommendation System', 'Position', [500 300 400 250], 'MenuBar','None', 'NumberTitle', 'off', 'Resize', 'off'); %Created a figure for the welcome page 

uicontrol ('Style', 'text','String','Welcome to the Movie Recommendation System!', 'Position', [50 180 300 40], 'FontSize',12,'FontWeight','bold'); %Created a text displaying a welcome message

uicontrol ('Style','text','String','Enter your name:', 'Position',[50 140 100 20], 'FontSize',10, 'HorizontalAlignment','left'); %Created a text label asking the users for their names

nameBox = uicontrol ('Style','edit','Position',[160 140 180 25],'FontSize',10); %To make the system interactive, I created a nameBox for the users to type their names in. The input will be stored in the variable.

uicontrol ('Style','text', 'String','Date of Birth (YYYY-MM-DD):', 'Position',[50 100 150 20], 'FontSize', 10,'HorizontalAlignment','left'); %Created a text label asking the users for their date of birth (D0B).

dobBox = uicontrol('Style', 'edit', 'Position', [210 100 130 25], 'FontSize', 10); %Similar to nameBox, I created a dobBox for the users to type their date of birth in. 

uicontrol ('Style','pushbutton','String','Start','Position',[150 50 100 40], 'FontSize', 12, 'FontWeight','bold','Callback', @(~,~) startMovieSearch(nameBox,dobBox,fig)); %Created a start button that moves onto the next page, with the function startMovieSearch. 
end

function startMovieSearch(nameBox, dobBox, fig) %Defined the function startMovieSearch after the start button is pressed.
username = get(nameBox, 'String'); %Retrieves the variable nameBox for the users' names
userDOB = get(dobBox, 'String'); %Retrieves the variable dobBox for the users' DOB

if isempty(username)||isempty(userDOB)
    msgbox('Please enter your name and date of birth!'); %Prompts the users to put an answer if either nameBox or dobBox is empty.
    return;
end

msgbox(sprintf('Welcome, %s!\nStarting movie search', username), 'Welcome'); %Prints a welcome message with the user's name.

close(fig); %Closes the welcome window.

movie_search_interface(username, userDOB);
end

function movie_search_interface(username, userDOB)
disp(['User:', username, ', DOB: ', userDOB, ' Proceeding to movie search']); %Prints the user name and DOB onto the command window.
interactiveMovieSearch(); %Calls on the search system
end 