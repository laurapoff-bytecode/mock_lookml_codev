# Define the database connection to be used for this model.
connection: "looker_partner_demo"

# include all the views
include: "/views/**/*.view.lkml"

# include all the explores
include: "/explores/**/*.explore.lkml"

explore: sdt_customer_order_history {}
explore: ndt_customer_order_history {}

datagroup: mock_lookml_codev_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: mock_lookml_codev_default_datagroup
