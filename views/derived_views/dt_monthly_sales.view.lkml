view: dt_monthly_sales {

    derived_table: {
      explore_source: order_items {
        column: created_month {}
        column: total_sale_price {}
      }
    }
    dimension: created_month {
      primary_key: yes
      description: ""
      type: date_month
    }
    dimension: total_sale_price {
      description: ""
      type: number
    }
  }
