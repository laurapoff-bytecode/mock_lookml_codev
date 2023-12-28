include: "/views/**/*.view.lkml"
include: "/views/derived_views/dt_monthly_sales.view.lkml"

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
     relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: dt_monthly_sales {
    type: left_outer
    sql_on: ${order_items.created_month} = ${dt_monthly_sales.created_month} ;;
    relationship: many_to_one
  }

  join: dt_sql_monthly_sales {
    type: left_outer
    sql_on: ${order_items.created_month} = ${dt_sql_monthly_sales.order_items_created_month} ;;
    relationship: many_to_one
  }
}
