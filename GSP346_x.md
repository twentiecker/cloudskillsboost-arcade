# Prepare Data for Looker Dashboards and Reports: Challenge Lab

## Task 1. Create Looks

### Look #1: Most heliports by state

#### In this section, you will need to use the Airports dataset to build a visualization that answers the following question: Which states and cities have the most airports with heliports?

#### 1. Your visualization must have the following requirements:

> A table with three columns: City, State, and Airports Count

> Limit the results (rows) to the top 9 states

> The Airports Count column should be in descending order (most to least)

> The Facility Type should not be included in the visualization

#### Note: You will need to create a filter for the Facility Type.

#### 2. Save this visualization as a Look. Title it: `Top 9 Cities With Most Heliports`.

```bash
1. Choose Airports field. Under Dimension, choose City and State. Under Measures choose Count
2. At row limit fill 9
3. The Airports Count column should be in descending order (most to least)
4. Choose Airports field. Under Dimension, hover to Facility Type and then choose filter
5. Set the filter for Airports Facility Type is equal to `HELIPORT`.
6. Set the Visualization to Bar
7. click run
8. click gear icon setting beside the run button and then choose Save > As look
9. Title it: `Top 9 Cities With Most Heliports`
```

### Look #2: Facility type breakdown

#### In this section, you will need to use the Airports dataset to build a visualization that answers the following question: What is the facility type breakdown for the states with the most airports?

#### 1. Your visualization must have the following requirements:

> A table visualization with the Airports Count, State, and the corresponding Facility Types

> Limit the results (rows) to the top 9 states

> The Airports facility type column should be in descending order (most to least)

#### Note: You will need to use a Pivot.

#### 2. Save this visualization as a Look. Title it: `Facility Type Breakdown for Top 9 States`.

```bash
1. Choose Airports field. Under Dimension, choose State. Under Measures choose Count
2. At row limit fill 9
3. The Airports Count column should be in descending order (most to least)
4. Choose Airports field. Under Dimension, hover to Facility Type and then choose pivot
5. Set the Visualization to Table
6. click run
7. click gear icon setting beside the run button and then choose Save > As look
8. Title it: `Facility Type Breakdown for Top 9 States`
```

### Look #3: Percentage cancelled

#### In this section, you will need to use the Flights dataset to build a visualization that answers the following question: What are the airports and states with the highest percentage of flight cancellations with over 10,000 flights?

#### 1. Your visualization must have the following requirements:

> A table with three columns: Aircraft Origin City, Aircraft Origin State, and Percentage of Flights Cancelled

> The Percentage of Flights Cancelled column must be created by a table calculation

> A Flights Count filter set for > 10,000 Flights

> The Cancelled Count and Flights Count should not be included in the visualization

> The Percentage of Flights Cancelled column should be in descending order (most to least)

#### 2. For the table calculation, you can use the provided formula. Be sure to name the calculation Percentage of Flights Cancelled and for formatting, use Percent (3) so your work can be accurately graded.

#### 3. Save this visualization as a Look. Title it: `States and Cities with Highest Percentage of Cancellations: Flights over 10,000`.

```bash
1. Choose Aircraft Origin field. Under Dimension, choose City and State
2. Choose Flights field. Under Measures, choose Count
3. Choose Flights Details. Under Measures, choose Cancelled Count
4. Click add button at custom fields, choose table calculation
5. Use provided formula in lab as Expression
6. use Percent (3) at format field
7. name it Percentage of Flights Cancelled
8. click save
9. Choose Flights field. Under Measures, hover to Count and then choose filter
10. Set the filter for Flights Count is greater than 10000
11. Set the Visualization to Table
12. click run
13. click gear icon setting beside the run button and then choose Save > As look
14. Title it: `States and Cities with Highest Percentage of Cancellations: Flights over 10,000`
```

### Look #4: Smallest average distance

#### In this section, you will need to use the Flights dataset to build a visualization that answers the following question: What are the origin and destination airports with the smallest average distance between them?

#### 1. Your visualization must have the following requirements:

> A table with two columns: Origin and Destination, and Average Distance (Miles)

> Select Average Distance field from a custom measure that calculates the average distance of flights.

> An Average Distance (Miles) filter set for greater than 0.

> The Average Distance (Miles) column should be in ascending order (least to most)

> Limit the results (rows) to 6

#### 2. Save this visualization as a Look. Title it: `Top 6 Airports With Smallest Average Distance`.

```bash
1. Choose Flights field. Under Dimension, choose Origin and Destination
4. Click add button at right of custom fields, choose custom measure
5. At field measure choose Average Distance Flights
7. name it Average Distance (Miles)
8. click save
9. Choose Custom field. Under Measures, hover to Count and then choose filter
10. Set the filter for Flights Count is greater than 10000
11. Set the Visualization to Table
12. click run
13. click gear icon setting beside the run button and then choose Save > As look
14. Title it: `States and Cities with Highest Percentage of Cancellations: Flights over 10,000`
```

---

## Task 2. Merge results

#### In this section, you will need to use both the Flights and Airports datasets to build a visualization that answers the following question: Where are the busiest, joint-use major airports that have control towers and what are their associated codes?

#### For this task, you will need to merge the two different datasets.

#### 1. Your visualization must have the following requirements:

> A bar chart that includes the City, State, and Code, with the corresponding number of flights

> Your Primary query must be from the Flights dataset, and include the Aircraft Origin City, Aircraft Origin State, Aircraft Origin Code, and Flights Count

> The following Airports source query you will merge into must be from the Airports dataset, and include the State, City, and Code. Additionally in the Airports source query, you must use three filters on Control Tower, Is Major, and Joint Use. All of these should be true (yes)

> Limit the results (rows) to the top 10 cities

#### Note: When you merge the results, review the dimensions that Looker used to match the queries. You should be merging Aircraft Origin City with Airports City, Aircraft Origin State with Airports State, and Aircraft Origin Code with Airports Code.

#### 2. Save this visualization to a Dashboard. Title your visualization: Busiest, Major Joint-Use Airports with Control Towers.

#### 3. Place this in a new Dashboard named `Plane and Helicopter Rental Hub Data`

---

## Task 3: Save looks to a dashboard

#### In this section, you will need to add all of your created Looks to a Dashboard.

#### 1. For each of the Looks you created, add them to the Plane and Helicopter Rental Hub Data Dashboard.

#### 2. Verify the Dashboard has the four Looks you created, as well as the merged result visualization.
