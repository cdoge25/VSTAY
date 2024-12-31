# Data Engineer Course Entry Test - SQL Skills

Use SQL Server or MySQL

## Question 1: Data Modeling (10%)

Study the provided CSV files and create a detailed Entity Relationship Diagram (ERD) that shows:
- All entities (tables)
- All attributes (columns) for each entity
- Primary keys and foreign keys
- Relationships between entities with proper cardinality (one-to-one, one-to-many, many-to-many)
- Data types for each attribute

Requirements:
- Use proper ERD notation
- Clearly indicate primary and foreign keys
- Show relationship cardinality
- Include all tables from the provided data files
- You should use dbdiagram.io

## Question 2: Data Definition (10%)

Write SQL queries to create all the necessary tables based on your ERD

Requirements:
- Create tables in the correct order to maintain referential integrity
- Use proper data types (VARCHAR, INT, DECIMAL, DATE, etc.)
- Define primary keys and foreign keys correctly, including appropriate foreign key constraints
- Follow consistent naming conventions

## Question 3: Data Integration (10%)

Bulk insert the CSV files into the created tables.

## Question 4: Data Manipulation (10%)

Implement a price tracking system:

1. Create a `price_change` procedure
   - The procedure should take the accommodation ID and the amount to change the price by as input (how much to increase or decrease the price)
   - The procedure should update the PricePerNight field in the Accommodation table
   
2. Implement price change tracking:
   - Create a trigger that records any changes to the PricePerNight field in the Accommodation table
   - The tracking should include:
     * When the price was changed
     * Old and new price values

3. Test the price tracking system:
   - Use the `price_change` procedure to update the price of accommodation `ACM000000001` by `50000`
   - Then use the procedure again to update the same accommodation's price by `-50000`
   - What does the `AccommodationPriceHistory` table look like after these operations?

## Question 5: Data Analytics (60%)

1. Analyze accommodation type popularity and revenue:
   - Calculate the total number of bookings (non-cancelled) for each accommodation type
   - Show the percentage of total bookings for each type
   - Include average length of stay
   - Calculate total revenue for each type (price_per_night * number_of_nights minus the discount)
   - Show if the revenue is above or below the overall average
   - Sort by total revenue in descending order

2. Create a comprehensive accommodation rating analysis:
   - Show accommodations with average rating above 4
   - Include the number of reviews for each accommodation
   - Calculate and show the average rating of the corresponding accommodation type
   - Show how much each accommodation's rating deviates from its type's average
   - Sort by average rating in descending order

3. Which province has the most accommodationm s?
   - List the number of accommodations for each accommodation type as well as the total number of accommodations in each province
   - Show the province name, accommodation type names as column names (Homestay, Hotel, etc.), and the total number of accommodations
   - Sort by the total number of accommodations in descending order

4. Write a stored procedure for an advanced accommodation search system:
   - Create a stored procedure `search_accommodations` that takes these parameters:
     * Required capacity (number of guests)
     * Required amenities (optional, comma-separated amenity IDs)
     * Required facilities (optional, comma-separated facility IDs)
   - The procedure should return:
     * Accommodation details (AccommodationID, AccommodationName, AccommodationType, PricePerNight, Capacity, NumberOfRooms)
   - Execute the procedure with:
     * Required capacity: 18
     * Required facilities: 'F10' (Facilities for disabled guests)
     * Required amenities: 'A12' (Pets allowed in room)
