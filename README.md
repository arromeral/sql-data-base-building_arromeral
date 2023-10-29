# 🎬📼SQL Database building Blockbust📼🎬
![blockbust](https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/e6033b62-f4fe-4eab-a36c-552663bc037d)
## Description
The project consists of the creation of a SQL database for the reopening of a video club business. The starting point for this consist in seven *csv* documents provided by the client that include inventory data, records of past rentals, movies, actors, film categories and languages, among others.

The objective of the project is to try to build a database sufficiently optimized to allow the client to start the business, being able to keep a record of rentals, inventory status, customer data and history, as well as the employees. I will also try to offer a series of queries that allow employees to search for relevant information about the movies in the inventory.
## Contents
The contents of the project are as follows:
## Methodology
### Understanding & Cleaning stage:
The first stage of the project has been dedicated to understanding the data provided by the client, and trying to organize it to understand the structure of the business. Once the relationships between the data has been outlined, it has been cleaned with the aim of adapting it to the final structure of the database.

For this, the python **pandas library** has been used, loading the data into Dataframes, cleaning and adjusting them, and finally returning them to *csv* format so that it can later be imported into mySQL.

The work done can be seen in the different Jupyter Notebooks in the src folder. The most relevant actions carried out are explained below:

- All the tables contained a "Last update" column, in this case, these columns have been eliminated except for the "rental" and "inventory" tables.
- The rental table contained rental records from the time the business was operational many years ago, and referenced customers and inventory ids that no longer exists, so it was decided to empty the table so it could be used to track new records once the business becomes operational.
- The file *old_HDD.csv* contained records that related actors to their movies, and these to their categories. Although some of the films are not in the inventory, and perhaps not all the films are included in the *film.csv* file, this file has been used extensively to obtain the following relationships:
  - Crossing the data with the actors Dataframe, a new column has been added with the actor id.
  - In a similar way to the actors, a column has been added with the id of the movies crossing the Dataframe with the movies.
  - Taking advantage of the fact that the Dataframe includes the category column, a column has been added to the *film* Dataframe with the id of its category. A new category "Unknown" has also been added to the Dataframe *categories* for those cases in which the movie was not found on *old_HDD*.
  - Once the dataframe has all the possible actor-movie records found, the rest of the columns have been deleted so that this table can be reused as a *many-to-many* relationship (equivalent to the cast of a movie) between actors and movies in SQL .
### Database final structure - EER Diagram:
The final structure of the database can be seen through the following EER Diagram.
![EER Diagram](https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/fbc26ff1-ec64-4ba9-9f8e-26204997db9f)

In addition to the work done in **pandas**, three new tables have been added directly in mySQL, one with store data (in this case 2, which are the ones that appear in the inventory records), and the other two with dummy employees and clients to be able to check the operation of the Database. To create the dummy data, the **Faker** python library has been used, as can be seen in the document *name_generator*.

Three new columns have also been included in the rental table:
- **"status":** indicating the status of the rental ("Rented", "Returned" or "Lost")
- **"rental duration":** which includes the maximum duration in days for that film.
- **"days left":** column that is updated daily as long as the movie has not been returned or declared lost, and that counts the remaining days of rental. Accepts negative values ​​to record rentals with late returns.
  
A new column **"availability"** has also been added to the *inventory* table, which accepts the values ​​"Available" and "Not available" depending on the status of the movie in the *rental* table. This column will be updated by **Triggers** when records are updated or generated in *rental*.
