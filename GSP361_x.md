Task 1
orders_items.view
dimension: is_search_source {
type: yesno
sql: ${users.traffic_source} = "Search" ;;
}

measure: sales_from_complete_search_users {
type: sum
sql: ${TABLE}.sale_price ;;
filters: [is_search_source: "Yes", order_items.status: "Complete"]
}

measure: total_gross_margin {
type: sum
sql: ${TABLE}.sale_price - ${inventory_items.cost} ;;
}

dimension: return_days {
type: number
sql: DATE_DIFF(${order_items.delivered_date}, ${order_items.returned_date}, DAY);;
}

task 2
model

# view: user_details {

# # You can specify the table name if it's different from the view name:

# sql_table_name: my_schema_name.tester ;;

#

# # Define your dimensions and measures here, like this:

# dimension: user_id {

# description: "Unique ID for each user that has ordered"

# type: number

# sql: ${TABLE}.user_id ;;

# }

#

# dimension: lifetime_orders {

# description: "The total number of orders for each user"

# type: number

# sql: ${TABLE}.lifetime_orders ;;

# }

#

# dimension_group: most_recent_purchase {

# description: "The date when each user last ordered"

# type: time

# timeframes: [date, week, month, year]

# sql: ${TABLE}.most_recent_purchase_at ;;

# }

#

# measure: total_lifetime_orders {

# description: "Use this for counting lifetime orders across many users"

# type: sum

# sql: ${lifetime_orders} ;;

# }

# }

view: user_details {

# Or, you could make this view a derived table, like this:

derived_table: {
explore_source: order_items {
column: order_id {}
column: user_id {}
column: total_revenue {}
column: age { field: users.age }
column: city { field: users.city }
column: state { field: users.state }
}
}

# Define your dimensions and measures here, like this:

dimension: order_id {
description: ""
type: number
}

dimension: user_id {
description: ""
type: number
}

dimension: total_revenue {
description: ""
type: number
}

dimension: age {
description: ""
type: number
}

dimension: city {
description: ""
}

dimension: state {
description: ""
}
}

task 3
filter 1 dan 2
model
sql_always_where: ${sale_price} >= 197 ;;

conditionally_filter: {
filters: [order_items.shipped_date: "2018"]
unless: [order_items.status, order_items.delivered_date]
}

filter 3 dan 4
remove previous flter from filter 1 dan 2

model
sql_always_having: ${average_sale_price} > 64 ;;

always_filter: {
filters: [order_items.status: "Shipped", users.state: "California", users.traffic_source:
"Search"]
}

task 4
remove all filter from task 3
remove previos/default datagroup and persist with in the model

model
datagroup: order_items_challenge_datagroup {
sql_trigger: SELECT MAX(order_item_id) from order_items ;;
max_cache_age: "7 hours"
}

persist_with: order_items_challenge_datagroup
