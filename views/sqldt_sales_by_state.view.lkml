view: sqldt_sales_by_state {
    derived_table: {
      sql: SELECT
          users.state  AS state,
         COALESCE(SUM(order_items.sale_price ), 0) AS total_sale_price
      FROM `thelook.order_items`  AS order_items
      LEFT JOIN `thelook.users`  AS users ON order_items.user_id = users.id
      GROUP BY
          1
      ORDER BY
          2 DESC
      LIMIT 500 ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: state {
      type: string
      sql: ${TABLE}.state ;;
    }

    dimension: total_sale_price {
      type: number
      sql: ${TABLE}.total_sale_price ;;
    }

    set: detail {
      fields: [
        state,
        total_sale_price
      ]
    }
  }
