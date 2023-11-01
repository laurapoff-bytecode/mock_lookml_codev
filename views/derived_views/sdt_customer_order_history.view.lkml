view: sdt_customer_order_history {
    derived_table: {
      sql: SELECT user_id , COUNT(order_id) AS Total_Orders, SUM (sale_price) AS Total_Sales
              FROM `looker-partners.thelook.order_items`
              GROUP BY user_id ;;
    }


    dimension: user_id {
      type: number
      sql: ${TABLE}.user_id ;;
    }

    dimension: total_orders {
      type: number
      sql: ${TABLE}.Total_Orders ;;
    }

    dimension: total_sales {
      type: number
      sql: ${TABLE}.Total_Sales ;;
    }

    set: detail {
      fields: [
        user_id,
        total_orders,
        total_sales
      ]
    }
  }
