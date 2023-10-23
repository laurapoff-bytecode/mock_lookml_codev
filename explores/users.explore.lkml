include: "/views/order_items.view.lkml"
include: "/views/users.view.lkml"

explore: users {
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id}=${order_items.user_id} ;;
  }
}
