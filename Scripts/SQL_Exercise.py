import sqlite3


def query_a(year1, year2):
    conn = sqlite3.connect('Exercise.db')
    cursor = conn.cursor()
    query = '''SELECT Full_Name, Publication_Title, Publisher, Year_Published
                FROM Publications NATURAL JOIN Has_Authored NATURAL JOIN Lab_Members
                WHERE Year_Published BETWEEN ? AND ? ; '''
    cursor.execute(query, (year1, year2))
    result = cursor.fetchall()
    conn.commit()
    conn.close()
    return result


# print(query_a(2017, 2020))


def query_b(topic):
    topic = '%' + topic + '%'
    conn = sqlite3.connect('Exercise.db')
    cursor = conn.cursor()
    query = '''SELECT Full_Name, Publication_Title, Publisher, Year_Published
                FROM Publications NATURAL JOIN Has_Authored NATURAL JOIN Lab_Members
                WHERE Topic LIKE ? ; '''
    cursor.execute(query, (topic,))
    result = cursor.fetchall()
    conn.commit()
    conn.close()
    return result


# print(query_b('Javascript'))

def query_c(year1, year2):
    conn = sqlite3.connect('Exercise.db')
    cursor = conn.cursor()
    query = '''SELECT  Full_Name, Category, COUNT(Publication_Title) AS Publications
                FROM Publications NATURAL JOIN Has_Authored NATURAL JOIN Lab_Members
                WHERE Year_Published BETWEEN ? AND ?
                GROUP BY unique_Id, Category;'''
    cursor.execute(query, (year1, year2))
    result = cursor.fetchall()
    conn.commit()
    conn.close()
    return result

# print(query_c(2017, 2020))


def query_g(date1, date2):
    date1 = "'" + date1 + "'"
    date2 = "'" + date2 + "'"
    conn = sqlite3.connect('Exercise.db')
    cursor = conn.cursor()
    query = '''SELECT  Full_Name, SUM(Budget) AS Total_Budget
                FROM Research_Projects NATURAL JOIN Has_Supervised NATURAL JOIN Lab_Members
                WHERE Member_Type = 'Dep_Member' AND (Start_Date >= ? AND End_Date >= ? )
                GROUP BY unique_Id
                ORDER BY SUM(Budget) DESC;'''
    cursor.execute(query, (date1, date2))
    result = cursor.fetchall()
    conn.commit()
    conn.close()
    return result

# print(query_g('2017-01-01', '2020-12-12'))


def query_i(name):
    conn = sqlite3.connect('Exercise.db')
    cursor = conn.cursor()
    query = '''SELECT Project_Title, Start_Date, End_Date
                FROM Research_Projects NATURAL JOIN Has_Supervised NATURAL JOIN Lab_Members
                WHERE Full_Name = ? ;'''
    cursor.execute(query, (name,))
    result = cursor.fetchall()
    conn.commit()
    conn.close()
    return result


# print(query_i('Domnica Nusom'))
