# If necessary, uncomment the line below to include explore_source.

# include: "order_items.explore.lkml"

view:order_facts {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count {}
    }
  }
  dimension: order_id {
    primary_key: yes
    type: number
  }
  dimension: count {
    description: "Total number of items per order"
    type: number
  }

measure: max_order_count {
  type: number
  sql: MAX(${count}) ;;
}
}
