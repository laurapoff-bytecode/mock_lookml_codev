view: sdt_customer_order_history {
    derived_table: {
      sql: SELECT user_id, COUNT(order_id) AS order_count, SUM(sale_price) AS total_sales from `looker-partners.thelook.order_items`
              GROUP BY user_id
              ORDER BY user_id ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: user_id {
      type: number
      sql: ${TABLE}.user_id ;;
    }

    dimension: order_count {
      type: number
      sql: ${TABLE}.order_count ;;
    }

    dimension: total_sales {
      type: number
      sql: ${TABLE}.total_sales ;;
    }

    set: detail {
      fields: [
        user_id,
        order_count,
        total_sales
      ]
    }
  }
