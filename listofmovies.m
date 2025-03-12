function movies = listofmovies() %Defined the function, list of movies, with an output named movies
folderPath = 'archive'; %Defined folderPath with 'archive', which is where all the CSV files are stored.
csvFiles = dir(fullfile(folderPath, '*.csv')); %Created a path to store all the CSV files to the variable csvFiles.

movies = {}; %Created an empty array movies to store the datafiles.

for i=1:length(csvFiles) %Created a loop for all the .csv files in the variable csvFiles.
    filename = fullfile(folderPath, csvFiles(i).name); %Stores the names of files in the variable filename.
    opts = detectImportOptions(filename, 'TextType','string','VariableNamingRule','preserve'); %Ensure that texts are read as strings instead of char. Ensure that column names remain the same. Store the result in opts.
    requiredColumns = {'movie_name', 'genre', 'director'}; %Extract the columns 'movie_name' 'genre' and 'director' from the dataset
    existingColumns = ismember(requiredColumns,opts.VariableNames); %Check if the required columns are in the data files, and store the result in existingColumns as a logical array.

    if all(existingColumns) %If all existingColumns are present in the CSV file
        opts.SelectedVariableNames = requiredColumns; %Read the requiredColumns
        dataTable = readtable(filename, opts); %Store the requiredColumns into a data table.

        movies = [movies;table2cell(dataTable)]; %Change the table to a cell array and stacks it in the variable movies
    end
end
end