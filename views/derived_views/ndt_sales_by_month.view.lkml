# If necessary, uncomment the line below to include explore_source.
# include: "order_items.explore.lkml"

view: ndt_sales_by_month {
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
    value_format_name: usd
  }
}
