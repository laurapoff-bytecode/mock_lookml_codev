view: ndt_customer_order_history {
    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: total_sale_price {}
        column: count_of_orders {}
      }
      persist_for: "4 hours"
    }
    dimension: user_id {
      description: ""
      type: number
    }
    dimension: total_sale_price {
      description: ""
      value_format: "$#,##0.00"
      type: number
    }
    dimension: count_of_orders {
      description: ""
      type: number
    }
  }
