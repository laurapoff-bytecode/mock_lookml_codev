view: dt_sql_monthly_sales {
      derived_table: {
      sql: select (format_date('%Y-%m',order_items.created_at)) as order_items_created_month, coalesce(sum(order_items.sale_price),0) as order_items_total_sales
              from `looker-partners.thelook.order_items` as order_items
              group by 1
              order by 1 desc ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: order_items_created_month {
      primary_key: yes
      type: string
      sql: ${TABLE}.order_items_created_month ;;
    }

    dimension: order_items_total_sales {
      type: number
      sql: ${TABLE}.order_items_total_sales ;;
    }

    set: detail {
      fields: [
        order_items_created_month,
        order_items_total_sales
      ]
    }
  }
