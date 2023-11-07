view: sdt_customer_order_history {

  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: total_sale_price {}
      column: count {}
    }
  }
  dimension: id {
    description: ""
    type: number
  }
  dimension: total_sale_price {
    description: ""
    type: number
    value_format_name: usd
  }
  dimension: count {
    description: ""
    type: number
  }
}
