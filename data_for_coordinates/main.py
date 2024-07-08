import pandas as pd

# Load the Excel file
file_path = 'adresses.xlsx'
df = pd.read_excel(file_path, sheet_name='Sheet1')  # Adjust sheet_name if needed
#Index(['Unnamed: 0', 'NAZWA BUDYNKU', 'LATITUDE', 'LONGTITUDE'], dtype='object')

# Extract the relevant columns
names = df['NAZWA BUDYNKU'][2:85]
latitudes = df['LATITUDE'][2:85]
longitudes = df['LONGTITUDE'][2:85]

# Initialize an empty list to store the values strings
values_list = []

# Loop through the rows and format the values
for name, latitude, longitude in zip(names, latitudes, longitudes):
    values_list.append(f"('{name}', {latitude}, {longitude})")

# Join the list into a single string separated by commas
values_string = ', '.join(values_list)

# Write the string to a text file
output_file = 'output.txt'
with open(output_file, 'w') as f:
    f.write(values_string)

print(f"Data has been written to {output_file}")