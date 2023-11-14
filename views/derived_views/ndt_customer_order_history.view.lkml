view: ndt_customer_order_history {
    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: count {}
        column: total_sale_price {}
      }
    }
    dimension: user_id {
      description: ""
      type: number
    }
    dimension: count {
      description: ""
      type: number
    }
    dimension: total_sale_price {
      description: ""
      type: number
    }
  }


  explore: ndt_customer_order_history {}
