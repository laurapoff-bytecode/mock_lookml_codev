include: "/views/order_items.view.lkml"

view: order_items_period_to_date {

  extends: [order_items]


  dimension: end_date_ty { #End Date for this year
    group_label: "Period To Date"
    type: date
    sql: date_sub(current_date, INTERVAL 1 day) ;;
    convert_tz: no
  }

  dimension: end_date_ly{ #End date for last year
    group_label: "Period To Date"
    type: date
    sql: date_sub(${end_date_ty}, INTERVAL 1 year);;
    convert_tz: no
  }


  dimension: wtd_start_date_ty { #WTD start date for this year
    group_label: "Period To Date"
    type: date
    sql: date_trunc(${end_date_ty}, week);;
    convert_tz: no
  }

  dimension:wtd_start_date_ly { #WTD start date for last year
    group_label: "Period To Date"
    type: date
    sql: date_trunc(${end_date_ly}, week) ;;
    convert_tz: no
  }

  dimension: is_wtd_ly {
    type: yesno
    sql: ${created_date} >= ${wtd_start_date_ly} and ${created_date} <= ${end_date_ly} ;;
    convert_tz: no
    hidden: yes
  }

  dimension: is_wtd_ty {
    type: yesno
    sql: ${created_date} >= ${wtd_start_date_ty} and ${created_date} <= ${end_date_ty} ;;
    convert_tz: no
    hidden: yes
  }


  dimension: qtd_start_date_ty { #QTD start date for this year
    group_label: "Period To Date"
    type: date
    sql: date_trunc(${end_date_ty}, quarter);;
    convert_tz: no
  }

  dimension: qtd_start_date_ly { #QTD start date for this year
    group_label: "Period To Date"
    type: date
    sql: date_trunc(${end_date_ly}, quarter) ;;
    convert_tz: no
  }

  dimension: is_qtd_ly {
    type: yesno
    sql: ${created_date} >= ${qtd_start_date_ly} and ${created_date} <= ${end_date_ly} ;;
    convert_tz: no
    hidden: yes
  }

  dimension: is_qtd_ty {
    type: yesno
    sql: ${created_date} >= ${qtd_start_date_ty} and ${created_date} <= ${end_date_ty} ;;
    convert_tz: no
    hidden: yes
  }


  dimension: mtd_start_date_ty { #MTD start date for this year
    group_label: "Period To Date"
    type: date
    sql: date_trunc(${end_date_ty}, month);;
    convert_tz: no
  }

  dimension:mtd_start_date_ly { #MTD start date for last year
    group_label: "Period To Date"
    type: date
    sql: date_sub(${mtd_start_date_ty}, INTERVAL 1 Year) ;;
    convert_tz: no
  }

  dimension: is_mtd_ly {
    type: yesno
    sql: ${created_date} >= ${mtd_start_date_ly} and ${created_date} <= ${end_date_ly} ;;
    convert_tz: no
    hidden: yes
  }

  dimension: is_mtd_ty {
    type: yesno
    sql: ${created_date} >= ${mtd_start_date_ty} and ${created_date} <= ${end_date_ty} ;;
    convert_tz: no
    hidden: yes
  }



  dimension: ytd_start_date_ty { #YTD start date for this year
    group_label: "Period To Date"
    type: date
    sql: date_trunc(current_date, year);;
    convert_tz: no
  }

  dimension:ytd_start_date_ly { #YTD start date for last year
    group_label: "Period To Date"
    type: date
    sql: date_sub(${ytd_start_date_ty}, INTERVAL 1 Year) ;;
    convert_tz: no
  }

  dimension: is_ytd_ly {
    type: yesno
    sql: ${created_date} >= ${ytd_start_date_ly} and ${created_date} <= ${end_date_ly} ;;
    convert_tz: no
    hidden: yes
  }

  dimension: is_ytd_ty {
    type: yesno
    sql: ${created_date} >= ${ytd_start_date_ty} and ${created_date} <= ${end_date_ty} ;;
    convert_tz: no
    hidden: yes
  }



# Measures
  measure: total_sale_price_YTD_TY {
    type: sum
    sql: ${sale_price} ;;
    filters: [is_ytd_ty: "Yes"]
    value_format_name: usd}

  measure: total_sale_price_YTD_LY {
    type: sum
    sql: ${sale_price} ;;
    filters: [is_ytd_ly: "Yes"]
    value_format_name: usd}

  measure: total_sale_price_MTD_TY {
    type: sum
    sql: ${sale_price};;
    filters: [is_mtd_ty: "Yes"]
    value_format_name: usd}

  measure: total_sale_price_MTD_LY {
    type: sum
    sql: ${sale_price};;
    filters: [is_mtd_ly: "Yes"]
    value_format_name: usd}

  measure: total_sale_price_QTD_TY {
    type: sum
    sql: ${sale_price};;
    filters: [is_qtd_ty: "Yes"]
    value_format_name: usd}

  measure: total_sale_price_QTD_LY {
    type: sum
    sql: ${sale_price};;
    filters: [is_qtd_ly: "Yes"]
    value_format_name: usd}

  measure: total_sale_price_WTD_TY {
    type: sum
    sql: ${sale_price};;
    filters: [is_wtd_ty: "Yes"]
    value_format_name: usd}

  measure: total_sale_price_WTD_LY {
    type: sum
    sql: ${sale_price};;
    filters: [is_wtd_ly: "Yes"]
    value_format_name: usd}


}

explore: order_items_period_to_date {
  label: "Order Items Period To Date"
}
