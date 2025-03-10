function movie_recommendation_system
movie_recommendation_welcome();
end

function movie_recommendation_welcome()
fig = figure('Name', 'Movie Recommendation System', 'Position', [500 300 400 250], 'MenuBar','None', 'NumberTitle', 'off', 'Resize', 'off');

uicontrol ('Style', 'text','String','Welcome to the Movie Recommendation System!', 'Position', [50 180 300 40], 'FontSize',12,'FontWeight','bold');

uicontrol ('Style','text','String','Enter your name:', 'Position',[50 140 100 20], 'FontSize',10, 'HorizontalAlignment','left');

nameBox = uicontrol ('Style','edit','Position',[160 140 180 25],'FontSize',10);

uicontrol ('Style','text', 'String','Date of Birth (YYYY-MM-DD):', 'Position',[50 100 150 20], 'FontSize', 10,'HorizontalAlignment','left');

dobBox = uicontrol('Style', 'edit', 'Position', [210 100 130 25], 'FontSize', 10);

uicontrol ('Style','pushbutton','String','Start','Position',[150 50 100 40], 'FontSize', 12, 'FontWeight','bold','Callback', @(~,~) startMovieSearch(nameBox,dobBox,fig));
end

function startMovieSearch(nameBox, dobBox, fig)
username = get(nameBox, 'String');
userDOB = get(dobBox, 'String');

if isempty(username)||isempty(userDOB)
    msgbox('Please enter your name and date of birth!');
    return;
end

msgbox(sprintf('Welcome, %s!\nStarting movie search', username), 'Welcome');

close(fig);

movie_search_interface(username, userDOB);
end

function movie_search_interface(username, userDOB)
disp(['User:', username, ', DOB: ', userDOB, ' Proceeding to movie search']);
end 
