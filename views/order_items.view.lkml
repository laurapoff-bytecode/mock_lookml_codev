# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `thelook.order_items` ;;
  drill_fields: [id]

  parameter: time_grain {
    type: string
    allowed_value: { value: "Daily"}
    allowed_value: { value: "Weekly"}
    allowed_value: { value: "Monthly"}
    allowed_value: { value: "Quarterly"}
    default_value: "Quarterly"
  }

  dimension: time_filtering {
    label_from_parameter: time_grain
    type: date_time
    sql:
    CASE
      WHEN {% parameter time_grain %} = "Quarterly" THEN datetime_trunc(${created_raw}, quarter)
      WHEN {% parameter time_grain %} = "Monthly" THEN datetime_trunc(${created_raw}, month)
      WHEN {% parameter time_grain %} = "Weekly" THEN datetime_trunc(${created_raw}, week)
      WHEN {% parameter time_grain %} = "Daily" THEN datetime_trunc(${created_raw}, day)
      ELSE NULL
    END;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;  }
  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;  }

  dimension_group: shipped {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  users.last_name,
  users.id,
  users.first_name,
  inventory_items.id,
  inventory_items.product_name,
  products.name,
  products.id
  ]
  }

}
