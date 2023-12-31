# 🎬📼SQL Database building project - Blockbust📼🎬
<p align="center">
  <img width="1000" height="300" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/e1388a83-52fb-4cae-a04a-c2959588a5bd">
</p>

## Description
The project consists of the creation of a SQL database for the reopening of a video club business. The starting point for this consist in seven *csv* documents provided by the client that include inventory data, records of past rentals, movies, actors, film categories and languages, among others.

The objective of the project is to try to build a database sufficiently optimized to allow the client to start the business, being able to keep record of rentals, inventory status, customer data and history, as well as the employees stats. I will also try to offer a series of queries that allow staff to search for relevant information about the movies in the inventory.
## Contents
The contents of the project are as follows:
- [**data**](https://github.com/arromeral/sql-data-base-building_arromeral/tree/main/data): 
   - [**original_info**](https://github.com/arromeral/sql-data-base-building_arromeral/tree/main/data/original_info): Folder with all the *csv* files provided by the client.
   - [**cleaned_and_additional_info**](https://github.com/arromeral/sql-data-base-building_arromeral/tree/main/data/cleaned_and_additional_info): Folder with all the *csv* files cleaned and generated to load data to mySQL.
- [**images**](https://github.com/arromeral/sql-data-base-building_arromeral/tree/main/images): Folder with the images used in this document.
- [**sql**](https://github.com/arromeral/sql-data-base-building_arromeral/tree/main/sql): Folder with the SQL document for importing the database, and the rest of the SQL queries created to use the database.
   - [**core_workflow_queries**](https://github.com/arromeral/sql-data-base-building_arromeral/tree/main/sql/core_workflow_queries): Folder with the main queries of the core business workflow.
   - [**additional_queries**](https://github.com/arromeral/sql-data-base-building_arromeral/tree/main/sql):Folder with other queries of interest generated to the business.
   - [**blockbust.mwb**](https://github.com/arromeral/sql-data-base-building_arromeral/blob/main/sql/blockbust.mwb): File with the EER Diagram.
   - [**blockbust.sql**](https://github.com/arromeral/sql-data-base-building_arromeral/blob/main/sql/blockbust.sql) : File to import the Database.
- [**src**](https://github.com/arromeral/sql-data-base-building_arromeral/tree/main/src): Folder with the Jupyter Notebooks used to analyze and clean the data provided by the client.
## Methodology & Results
### Understanding & Cleaning stage:
The first stage of the project has been dedicated to understanding the data provided by the client, and trying to organize it to understand the structure of the business. Once the relationships between the data has been outlined, it has been cleaned with the aim of adapting it to the final structure of the database.

For this, the python **pandas library** has been used, loading the data into Dataframes, cleaning and adjusting them, and finally returning them to *csv* format so that it can later be imported into mySQL.

The work done can be seen in the different Jupyter Notebooks in the [**src folder**](https://github.com/arromeral/sql-data-base-building_arromeral/tree/main/src). The most relevant actions carried out are explained below:

- All the tables contained a "Last update" column, in this case, these columns have been eliminated except for the "rental" and "inventory" tables.
- The rental table contained rental records from the time the business was operational many years ago, and referenced customers and inventory ids that no longer exists, so it was decided to empty the table so it could be used to track new records once the business becomes operational.
- The file **old_HDD.csv** contained records that related actors to their movies, and these to their categories. Although some of the films are not in the inventory, and perhaps not all the films are included in the **film.csv** file, this file has been used extensively in the [**ajuste_tablas**](https://github.com/arromeral/sql-data-base-building_arromeral/blob/main/src/ajuste_tablas.ipynb) Jupyter Notebook to obtain the following relationships :
  - Crossing the data with the actors Dataframe, a new column has been added with the actor id.
  - In a similar way to the actors, a column has been added with the id of the movies crossing the Dataframe with the movies.
  - Taking advantage of the fact that the Dataframe includes the category column, a column has been added to the *film* Dataframe with the id of its category. A new category "Unknown" has also been added to the Dataframe *categories* for those cases in which the movie was not found on *old_HDD*.
  - Once the dataframe has all the possible actor-movie records found, the rest of the columns have been deleted so that this table can be reused as a *many-to-many* relationship (equivalent to the cast of a movie) between actors and movies in SQL .
### Database final structure - EER Diagram:
The final structure of the database can be seen through the following EER Diagram:

![EER Diagram](https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/ad05010e-8aa1-4c49-ad4e-a5262e603458)


In addition to the work done in **pandas**, three new tables have been added directly in mySQL, one with stores data (in this case 2, which are the ones that appear in the inventory records), and the other two with dummy employees and clients to be able to check the operation of the Database. To create the dummy data, the **Faker** python library has been used, as can be seen in the Jupyter Notebook [**name_generator**](https://github.com/arromeral/sql-data-base-building_arromeral/blob/main/src/name_generator.ipynb).

Three new columns have also been included in the rental table:
- **"status":** indicating the status of the rental ("Rented", "Returned" or "Lost")
- **"rental duration":** which includes the maximum duration in days for that film.
- **"days left":** column that is updated daily as long as the movie has not been returned or declared lost, and that counts the remaining days of rental. Accepts negative values ​​to record rentals with late returns.
  
A new column **"availability"** has also been added to the *inventory* table, which accepts the values ​​"Available" and "Not available" depending on the status of the movie in the *rental* table. This column will be updated by **Triggers** when records are updated or generated in *rental*.

### Proposed Workflow & QUERIES:

The structure of the database is designed to minimize manual data entry by employees and simplify the number of tasks while maintaining the rigor, consistency and updating of the data as much as possible.

The core business workflow is as follows:
- A client rents a movie -> A record is generated in the *rental* table with the data of the client, the employee and the inventory id of the item.
  
  <img width="572" alt="new_rental" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/b5d8f0d7-14d7-46ee-8198-ae04efadd3a9">
- Employees update the *rental* table periodically to update the status of the rentals, especially the days remaining for each rental in progress or after each new rent.

<img width="587" alt="update_rental_table" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/4ce22eaf-d529-4010-bfb3-71b165ee266d">

- The client returns the movie or declares it lost -> The employee updates the rental record in the *rental* table, updating its status and the return date.

<img width="602" alt="update_rental_status" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/a74da488-774f-442d-84bf-352e6d51d807">

The rental table once the business is operational should look like this:

<img width="560" alt="rental_table" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/a77ca233-61b6-4dd0-942e-2573c87a8a7f">

Furthermore, it would be interesting if once a new rental was generated, the status of the item would be updated in the "inventory" table to "Not available", and also when a movie was returned it would change again to "Available". To do this, two "Triggers" have been created, which are automations that are activated automatically when a certain action occurs, such as a new **insert** in rental or an **update** in a row of "rental.

These two triggers are the following:

-  [**trigger_new_rental**](https://github.com/arromeral/sql-data-base-building_arromeral/blob/main/sql/core_workflow_queries/trigger_new_rental.sql): Changes the item's inventory status to "Not available" when it is rented
-  [**trigger_return_change_inventory**](https://github.com/arromeral/sql-data-base-building_arromeral/blob/main/sql/core_workflow_queries/trigger_return_change_inventory.sql): Changes the item's inventory status to "Available" when the film is returned.

Additionally, a series of **QUERIES** have been created that allow staff to obtain information about clients, or facilitate the search for information in the Database in response to hypothetical queries made by clients:
- **"customer_expenses"**: This query returns a table with the total expenses of customers in the business in descending order of expense (*It can be useful when offering promotions or discounts to the best customers*).

  <img width="259" alt="customer expenses" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/0b9edc9b-aacd-4c42-b969-97e8cd2b0ffe">

- **"customer_days_delayed"**: This query keeps track of the total days of accumulated delays in returns for each customer (
*May be necessary to cancel the membership of undesirable clients*).

<img width="242" alt="cust_days_delayed" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/a837584f-37c1-4e2d-b049-a34e6d72a5fe">

- **"customer_current_delays"**: Keeps track of customers with ongoing rentals that have exceeded the maximum rental days. Also return the client's phone number and email(
*It can be useful to send a return reminder to these customers*).

<img width="415" alt="current_delays" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/d34ca330-cb62-421e-a41b-8494d995a596">

- **"customer_penalties"**: This query calculates customer penalties, based on the sum of the replacement rate for lost movies and suggests a system of penalties for delays based on the days of delay and the rate of the item.
  
<img width="383" alt="total penalties" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/a7ff2d39-1237-4bde-bb45-be196a7c3335">

- **"actor_films"**: This Querie returns all the movies in the database in which a specific actor appears.

  <img width="216" alt="actor_film" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/d0607604-0489-47cb-9220-a0f1bd42fc7a">

- **"film_cast"**: This Query returns the cast of a specific movie from the database.


<img width="191" alt="film_cast" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/3bbf5388-16ce-40bd-9dfd-9a8d350a8ff2">

- **"film_inventory"**: This Query returns the inventory status of a certain film, that is, the number of units available in each store.

  <img width="262" alt="film_inventory" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/15d3ab5d-c519-44c3-93e6-5f23ebe68af8">

- **"actor_film_inventory"**: Similar to the previous one but returning the inventory status of all the films in which a certain actor appears.

  <img width="318" alt="actor_inventory" src="https://github.com/arromeral/sql-data-base-building_arromeral/assets/138980560/e3b1f86f-20db-4690-8d2a-81c64db53d94">


## Future works and additions
Below, a series of additions and improvements are proposed to enrich the project and that may be implemented in the future:

- A system to prevent a customer with currently overdue movies or unpaid penalties from renting.
- Some queries to keep track of employee productivity.
- Automation of the file of rental records closed in another table differentiated from rental.
- Query to get suggested movies based on the latest movies rented by a customer.
