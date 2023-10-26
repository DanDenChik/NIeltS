import pandas as pd
import sqlite3

excel_file = 'data.xlsx'

conn = sqlite3.connect('backend/db.sqlite3')
cursor = conn.cursor()

df = pd.read_excel(excel_file, engine='openpyxl')

for index, row in df.iterrows():
    word = row['word']
    definition = row['definition']
    example_sentence = row['example_in_sentence']
    translation = row['translation']
    level_of_word = row['level_of_word']
    
    if isinstance(translation, list):
        translation = ', '.join(translation)
    
    cursor.execute('''INSERT INTO users_word (word, definition, example_sentence, translation, level_of_word)
                      VALUES (?, ?, ?, ?, ?)''', (word, definition, example_sentence, translation, level_of_word))

conn.commit()
conn.close()
