# i211379_Assignment_2_DB
<p>
Question 01:
        The EER diagram for a small private airport database includes additional features beyond the basic ER diagram, including subtypes and super-types, specialization, and generalization. One example of this is the relationship between OWNER and its subtypes, PERSON and CORPORATION, which allows for more specific and detailed information to be stored and retrieved. PILOT and EMPLOYEE are subtypes of PERSON, demonstrating specialization, while PLANE_TYPE and HANGAR share the attribute of capacity, indicating generalization. The EER diagram also includes relationships such as FLIES and WORKS_ON, indicating the types of planes each pilot and employee can work with respectively. Additionally, the relationship between AIRPLANE and SERVICE is expanded to include the PLANE_SERVICE entity, allowing for multiple service records to be associated with each airplane. Overall, the EER diagram provides a comprehensive understanding of the entities and relationships involved, allowing for efficient management of the airport's operations.
</p>
<p>
        ![a](https://user-images.githubusercontent.com/115403487/228383568-0482da38-dcb7-49e9-a5c8-1cc07ebb76ee.gif)

</p>
<p>
Question 02:
        In this i can created all the tables and inserted 20 dummy values in each table.
        Foreign Key: In Relation of 1:N or N:1 primary key moves toward the many side table and in M:N i created one more table and store the p.keys of both table.
</p>
<p>
Question 03:
        This query uses a subquery to find all registration numbers of airplanes that have undergone maintenance (by selecting the Reg# column from the PLANE_SERVICE table) and then selects all registration numbers of airplanes that are not in that subquery result set. This gives us the registration numbers of airplanes that have never undergone maintenance.
</p>
<p>
Question 04:
        This SQL query uses several joins to retrieve the names and addresses of corporations that own airplanes with a capacity greater than 200. It first joins the CORPORATION table with the OWNER table on the CO_ID and ID columns respectively. It then joins the OWNER table with the OWNS table on the ID and Owner_ID columns respectively. It further joins the OWNS table with the AIRPLANE table on the Reg# column. Finally, it joins the AIRPLANE table with the PLANE_TYPE table on the OF_TYPE and Model columns respectively. The WHERE clause is then used to filter results based on the condition that the capacity of the airplane is greater than 200.
</p>
<p>
Question 05:
        This SQL query uses the AVG aggregate function to find the average salary of employees who work the night shift, which is specified by the condition Shift = 'Night'. The query also checks the shift timing using the LIKE operator and SUBSTRING function to ensure that the employee works between 10 PM and 6 AM. This condition is split into two cases to handle shifts that start in the PM and continue into the AM, or shifts that start and end in the AM. Finally, the query groups the result by employee SSN using the GROUP BY clause.
</p>
<p>
Question 06:
        This SQL query selects the top 5 employees with the highest total number of maintenance hours worked. It uses joins to combine data from the EMPLOYEE, MAINTAIN_BY, and SERVICE tables. The query first joins EMPLOYEE with MAINTAIN_BY on the Ssn column to get the maintenance work performed by each employee. Then, it joins MAINTAIN_BY with SERVICE on the SERVICE_ID column to get the number of maintenance hours worked for each service. The query then groups the data by employee Ssn and calculates the sum of hours worked. Finally, the result is ordered in descending order by total hours worked and only the top 5 employees are selected using the TOP keyword.
</p>
<p>
Question 07:
        For query 7(a), we are joining the AIRPLANE table with PLANE_SERVICE and SERVICE tables to get the registration numbers of airplanes that have undergone maintenance. The WHERE clause filters the results to only include maintenance performed in the past week using the DATEADD function to subtract 7 days from the current date.
        For query 7(b), we are using the same JOINs to get the registration numbers of airplanes that have undergone maintenance, but the WHERE clause filters the results to include maintenance performed in the last 15 years using the DATEADD function to subtract 15 years from the current date. The DISTINCT keyword is used to eliminate duplicate registration numbers in the result set
</p>
<p>
Question 08:
        This query joins several tables to retrieve the information needed. The OWNS table links AIRPLANE and OWNER tables. The OWNER table has a Type column that indicates whether the owner is a person or corporation. The query uses LEFT JOIN and CASE statements to retrieve the names and phone numbers of owners. The WHERE clause filters the results to only show owners who have purchased a plane in the past month.
</p>
<p>
Question 09:
        This query uses the JOIN keyword to combine the PILOT and FLIES tables based on matching pilot SSNs. It then uses the COUNT function to count the number of distinct airplane models each pilot is authorized to fly. The GROUP BY clause is used to group the results by pilot SSN, so that the count is performed for each pilot. The ORDER BY clause is used to sort the results in descending order based on the number of authorized airplanes.
</p>
<p>
Question 10:
        This query selects the top 1 row from the HANGAR table based on the Capacity column in descending order. This means that the hangar with the largest capacity will appear first. The SELECT statement returns only the LOCATION and Capacity columns of the top row, which is the hangar with the most available space.
</p>
<p>
Question 11:
        We start by selecting the corporation's name and the number of distinct registration numbers (Reg#) owned by each corporation.
        We join the CORPORATION table with the OWNER table on the CO_ID column.
        We filter only the corporations by checking that the Type column equals 'corporation'.
        We join the OWNS table with the previous join result on the Owner_ID column.
        We group the result by corporation name using the GROUP BY clause.
        We sort the result in descending order of the number of planes owned using the ORDER BY clause.
</p>
<p>
Question 12:
        This query retrieves the average number of maintenance hours per plane type by joining three tables: AIRPLANE, PLANE_TYPE, and SERVICE. The PLANE_TYPE table contains the model name of each airplane type, which is used to join with the OF_TYPE column of the AIRPLANE table. Then, the PLANE_SERVICE table is joined with the AIRPLANE table to obtain all services performed on each airplane. Finally, the SERVICE table is joined with the PLANE_SERVICE table to retrieve the number of maintenance hours spent on each service.
        The AVG() function is used to compute the average number of maintenance hours per plane type by grouping the results by plane type using the GROUP BY clause. The Model column of the PLANE_TYPE table is selected to display the plane type names along with the computed average maintenance hours.
</p>
<p>
Question 13:
        We start by selecting the distinct IDs of owners, so we add SELECT DISTINCT o.ID.
        We then join the OWNER table with the OWNS table using JOIN ON o.ID = os.Owner_ID.
        Next, we join the AIRPLANE table with the PLANE_TYPE table using JOIN ON os.Reg# = a.Reg# and JOIN ON a.OF_TYPE = pt.Model.
        We then join the WORKS_ON table with the EMPLOYEE table using JOIN ON pt.Model = wo.Model_emp and LEFT JOIN ON wo2.Ssn_emp = e.Ssn.
        We add a second left join to check if the employee is qualified to work on the type of plane using LEFT JOIN ON wo2.Ssn_emp = e.Ssn AND wo2.Model_emp = pt.Model.
        Finally, we add a WHERE clause to filter out the rows where the employee is qualified to work on the plane using WHERE wo2.Ssn_emp IS NULL.
</p>
<p>
Question 14:
        This SQL query retrieves the names, locations, and types of owners who have purchased a plane from a corporation that has a hangar in the same location as the owner. It does so by joining the OWNER table with the OWNS table on the Owner_ID column and then joining the AIRPLANE table with the OWNS table on the Reg# column. The HANGAR table is then joined with the resulting table on the Location column.
        Finally, the WHERE clause filters the results by only selecting those owners whose Type is 'corporation'. The DISTINCT keyword is used to remove any duplicate rows from the result set.
</p>
<p>
Question 15:
        In order to find the names of pilots who are qualified to fly a plane that is currently in maintenance, we need to join several tables together.
        First, we join the PILOT table with the FLIES table to get the list of pilots and the models they are qualified to fly. Then, we join the PLANE_TYPE table with the AIRPLANE table to get the list of planes and their respective models.
        Next, we join the AIRPLANE table with the PLANE_SERVICE table and then with the SERVICE table to get the list of planes that are currently in maintenance and the maintenance dates.
        Finally, we apply a filter to find the pilots who are qualified to fly the planes that are currently in maintenance.
        There are two different queries provided to address this question, both of which use a similar approach. The first query (15 A) finds pilots who are qualified to fly planes that have had maintenance performed on them within the last 1000 days. The second query (15 B) finds pilots who are qualified to fly planes that are currently in maintenance.
</p>
<p>
Question 16:
        This query retrieves the names of employees who have worked on planes owned by a particular corporation, sorted by the total number of maintenance hours worked.
        The query first selects the employee's social security number (Ssn) and calculates the sum of the maintenance hours that the employee has worked on all planes.
        The query then joins the EMPLOYEE table with the WORKS_ON table on the employee's Ssn, and the PLANE_TYPE table on the model of the plane that the employee is qualified to work on.
        Next, the query joins the AIRPLANE table on the plane model and the PLANE_SERVICE table on the airplane's registration number. Then, it joins the SERVICE table on the service ID to get the maintenance hours.
        The query also joins the OWNS and OWNER tables to filter the planes owned by a particular corporation.
        Finally, the query groups the results by employee Ssn and orders them in descending order of the total maintenance hours.
</p>
<p>
Question 17:
        This query retrieves the registration numbers and plane types of airplanes that have been owned by a PERSON or undergone maintenance work from an employee who works the day shift.
        We start by selecting the registration number and plane type from the AIRPLANE table. We then left join the OWNS table to get the owner of the airplane, and we filter the results by selecting only those owners who have a type of 'person'.
        Next, we left join the WORKS_ON table to get the employee who worked on the airplane, and we filter the results by selecting only those employees who work the day shift.
        Finally, we use a WHERE clause to filter the results to include only those airplanes that have been owned by a person or undergone maintenance work from an employee who works the day shift. We use the IS NOT NULL operator to check whether ow.ID or e.Ssn is not null, which means that there is a match in either the OWNS table or the WORKS_ON table.
</p><p>
Question 18:
        This query retrieves information about owners who have purchased a plane from a corporation that has also purchased a plane of the same type in the past 20 months. Here's how it works:
        The FROM clause specifies that we want to query the OWNER, OWNS, and AIRPLANE tables. o, o1, and a1 are aliases for these tables, respectively.
        The JOIN clauses join the tables together based on their relationships. o1 is joined to o on the ID column to ensure that we're only looking at owners who have a plane. a1 is joined to o1 on the Reg# column to get information about the plane.
        The WHERE clause filters the results to only include owners of type 'corporation' and planes that were purchased in the past 20 months. The DATEADD function is used to subtract 20 months from the current date and GETDATE() is used to get the current date.
        The resulting output will include the ID, Type, and location columns for owners who meet the specified criteria.
</p><p>
Question 19:
        This SQL query is used to find the total number of planes stored in each hangar. The query uses an outer join between the HANGAR and AIRPLANE tables to ensure that all hangars are included in the result, even if they don't have any planes stored in them.
        The COUNT function is used to count the number of planes stored in each hangar, and the results are grouped by the Number column of the HANGAR table. The ORDER BY clause is used to sort the results in descending order based on the total number of planes stored in each hangar.
        Overall, this query provides a useful summary of the number of planes stored in each hangar, which can help with planning and resource allocation.
</p><p>
Question 20:
        This SQL query uses a LEFT JOIN to combine two tables, PLANE_TYPE and AIRPLANE. The PLANE_TYPE table lists the different models of planes, while the AIRPLANE table lists the registration numbers of each plane along with its associated plane type.
        The query counts the number of planes for each plane type by using the COUNT function on the Reg# column of the AIRPLANE table. The results are grouped by the Model column of the PLANE_TYPE table.
        Finally, the results are ordered in descending order by the TOTAL_PLANES column, which gives us the number of planes for each plane type in decreasing order.
</p><p>
Question 21:
        This query selects the registration number of each airplane and counts the number of services performed on each plane. The LEFT JOIN is used to include planes that have not had any services performed on them, as well as those that have had services performed. The GROUP BY clause is used to group the results by the registration number of each plane. The COUNT() function is used to count the number of rows in the PLANE_SERVICE table for each plane, giving us the total number of services performed on each plane. Finally, the results are sorted in descending order by the total number of services performed.
</p><p>
Question 22:
        The first query (22A) finds the average salary of each individual employee, grouped by their SSN and shift.
        The second query (22B) finds the average salary of all employees in each shift, grouping by shift.
</p><p>
Question 23:
         It joins the OWNER and OWNS tables on the Owner_ID column and uses COUNT to count the number of planes each owner owns. Finally, it groups the results by owner ID and orders them by the total number of planes in descending order.
</p><p>
Question 24:
        This query joins the PILOT and FLIES tables using a left join. It groups the results by the PILOT.Ssn column and counts the number of planes each pilot is authorized to fly using the COUNT(FLIES.Model) function. The result set is then ordered in descending order of the number of authorized planes using the ORDER BY clause.
</p><p>
Question 25:
        QUERY NO 1:
                This query is important as it provides information about which pilots are authorized to fly which airplane models. This information can be used for scheduling flights and assigning pilots to specific planes based on their authorization. It can also help in managing the training and certification of pilots for different airplane models. Additionally, this information can be used for analyzing the distribution of pilot authorizations across different airplane types and identifying areas for improvement in pilot training and certification programs.
       </p><p> QUERY NO 2:
                This query is important for maintaining the maintenance history of a specific airplane. By using this query, you can retrieve the list of maintenance service records for a specific airplane. This information is very useful in case of any issues with the airplane in the future, as it will help in identifying the maintenance history of the airplane, and any recurring issues that may have occurred in the past. This query can be used by maintenance engineers, mechanics, and airline companies to keep track of the maintenance history of their airplanes.
        </p><p>QUERY NO 3:
                This query is useful in situations where you want to find employees who are qualified to work on a specific airplane model, and then sort them by their shift and salary. It can be used by airline companies to efficiently manage their workforce and assign employees to specific tasks based on their skills and availability.
                The query uses the ORDER BY clause to sort the results in a specific order. The CASE statement is used to sort employees based on their shift, with those working the night shift appearing first. The salary is sorted in descending order, so that employees with higher salaries appear first. This allows companies to quickly identify the most qualified and available employees for a particular job, while also ensuring that employees are paid fairly for their work.
        </p><p>QUERY NO 04:
                This query is useful for retrieving the data of all the hangars based on their capacity in descending order. This information can be helpful in managing the parking and storage of airplanes. For example, if the capacity of a hangar is nearing its limit, it may be necessary to either move some planes to another hangar or build a new one with a higher capacity. By having this information easily accessible, airport or airline administrators can make informed decisions about hangar management.
        </p><p>QUERY NO 05:
                This query is important because it helps identify corporations that have a large fleet of airplanes, which could be useful in various scenarios such as market analysis, customer segmentation, or business strategy planning. For example, an airline company could use this query to identify potential competitors or partners in the industry, or a manufacturer could use it to identify potential customers for their aircraft. This query can be used in various industries such as aviation, transportation, and business analysis.
        </p><p>QUERY NO 06:
                This query is important for analyzing the maintenance history of each airplane in the database. By retrieving the total number of hours spent on maintenance for each airplane, we can identify which airplanes require more maintenance and which ones require less. This information can be used to optimize maintenance schedules and ensure that all airplanes are properly maintained to ensure safe and efficient operations. The query can be used by airlines, aircraft maintenance organizations, and other aviation-related businesses.
