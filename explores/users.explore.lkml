include: "/views/users.view.lkml"
include: "/views/order_items.view.lkml"

explore: users {
  join: order_items {
    type: left_outer
    sql_on: ${users.id}=${order_items.user_id} ;;
    relationship: one_to_many

  }
}
