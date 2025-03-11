function movies = listofmovies()
folderPath = 'archive';
csvFiles = dir(fullfile(folderPath, '*.csv'));

movies = {};

for i=1:length(csvFiles)
    filename = fullfile(folderPath, csvFiles(i).name);
    opts = detectImportOptions(filename, 'TextType','string','VariableNamingRule','preserve');
    requiredColumns = {'movie_name', 'genre', 'director'};
    existingColumns = ismember(requiredColumns,opts.VariableNames);

    if all(existingColumns)
        opts.SelectedVariableNames = requiredColumns;
        dataTable = readtable(filename, opts);

        movies = [movies;table2cell(dataTable)];
    end
end
end