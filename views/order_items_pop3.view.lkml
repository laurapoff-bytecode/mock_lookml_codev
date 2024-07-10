## Period over Period Method 3: Custom choice of current and previous periods with parameters
##
## Refined from:
##    -Molly Lippsett 2020, Methods for Period Over Period (PoP) Analysis in Looker,[LookML Example],https://community.looker.com/technical-tips-tricks-1021/methods-for-period-over-period-pop-analysis-in-looker-30823
##    -Llooker 2020, Lookml period over period analysis in different dialects, [views],https://github.com/llooker/period_over_period_analysis
##
## Created by: Carl Clifford - Bytecode IO
## Create Date: 11/29/2022
##
## Modified by: Carl Clifford
## Modified Date: 12/2/2022
## Comments: Added SQL Dialects



# Like Method 2, but instead of using parameters to simply select the appropriate date dimension,
# we will use liquid to define the logic to pick out the correct periods for each selection.

  include: "/views/order_items.view.lkml"

  view: order_items_pop3 {
    extends: [order_items]


    filter: current_date_range {
      type: date
      view_label: "_PoP"
      label: "1. Current Date Range"
      description: "Select the current date range you are interested in. Make sure any other filter on Event Date covers this period, or is removed."
      sql: ${period} IS NOT NULL ;;
      convert_tz: no
    }

    parameter: compare_to {
      view_label: "_PoP"
      description: "Select the templated previous period you would like to compare to. Must be used with Current Date Range filter"
      label: "2. Compare To:"
      type: unquoted
      allowed_value: {
        label: "Previous Period"
        value: "Period"
      }
      allowed_value: {
        label: "Previous Week"
        value: "Week"
      }
      allowed_value: {
        label: "Previous Month"
        value: "Month"
      }
      allowed_value: {
        label: "Previous Quarter"
        value: "Quarter"
      }
      allowed_value: {
        label: "Previous Year"
        value: "Year"
      }
      default_value: "Period"
      # view_label: "_PoP" view_label having been declared twice in the article
    }



## ------------------ HIDDEN HELPER DIMENSIONS  ------------------ ##

### - BIGQUERY {

    dimension: days_in_period {
      # hidden:  yes
      view_label: "_PoP"
      description: "Gives the number of days in the current period date range"
      type: number
      sql: DATE_DIFF( DATE({% date_start current_date_range %}), DATE({% date_end current_date_range %}), DAY) ;;
    }

    dimension: period_2_start {
      # hidden:  yes
      view_label: "_PoP"
      description: "Calculates the start of the previous period"
      type: date
      sql:
        {% if compare_to._parameter_value == "Period" %}
        DATE_ADD(DATE({% date_start current_date_range %}), INTERVAL ${days_in_period} DAY)
        {% else %}
        DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL 1 {% parameter compare_to %})
        {% endif %};;
      convert_tz: no
    }

    dimension: period_2_end {
      # hidden:  yes
      view_label: "_PoP"
      description: "Calculates the end of the previous period"
      type: date
      sql:
        {% if compare_to._parameter_value == "Period" %}
        DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL 1 DAY)
        {% else %}
        DATE_SUB(DATE_SUB(DATE({% date_end current_date_range %}), INTERVAL 1 DAY), INTERVAL 1 {% parameter compare_to %})
        {% endif %};;
      convert_tz: no
    }

    dimension: day_in_period {
      hidden: yes
      description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
      type: number
      sql:
          {% if current_date_range._is_filtered %}
              CASE
              WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
              THEN DATE_DIFF( DATE({% date_start current_date_range %}), ${created_date}, DAY) + 1
              WHEN ${created_date} between ${period_2_start} and ${period_2_end}
              THEN DATE_DIFF(${period_2_start}, ${created_date}, DAY) + 1
              END
          {% else %} NULL
          {% endif %}
          ;;
    }


### } / - END BIGQUERY

## ------------------ DIMENSIONS TO PLOT ------------------ ##

### - BIGQUERY {

    dimension_group: date_in_period {
      description: "Use this as your grouping dimension when comparing periods. Aligns the previous periods onto the current period"
      label: "Current Period"
      type: time
      # sql: DATE_ADD( ${day_in_period} - 1, DATE({% date_start current_date_range %}), DAY) ;;
      sql: DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL (${day_in_period} - 1) DAY)  ;;
      view_label: "_PoP"
      timeframes: [
        date,
        hour_of_day,
        day_of_week,
        day_of_week_index,
        day_of_month,
        day_of_year,
        week_of_year,
        month,
        month_name,
        month_num,
        year]
      convert_tz: no
    }

### } / - END BIGQUERY


    dimension: period {
      view_label: "_PoP"
      label: "Period"
      description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
      type: string
      #order_by_field: order_for_period
      sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
            THEN 'This {% parameter compare_to %}'
            WHEN ${created_date} between ${period_2_start} and ${period_2_end}
            THEN 'Last {% parameter compare_to %}'
            END
        {% else %}
            NULL
        {% endif %}
        ;;
    }


## ---------------------- TO CREATE FILTERED MEASURES ---------------------------- ##

    dimension: period_filtered_measures {
      hidden: yes
      description: "We just use this for the filtered measures"
      type: string
      sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${created_raw} {% endcondition %} THEN 'this'
            WHEN ${created_date} between ${period_2_start} and ${period_2_end} THEN 'last' END
        {% else %} NULL {% endif %} ;;
    }

# Filtered measures

    measure: current_period_sales {
      view_label: "_PoP"
      type: sum
      sql: ${sale_price};;
      filters: [period_filtered_measures: "this"]
    }

    measure: previous_period_sales {
      view_label: "_PoP"
      type: sum
      sql: ${sale_price};;
      filters: [period_filtered_measures: "last"]
    }

    measure: sales_pop_change {
      view_label: "_PoP"
      label: "Total Sales period-over-period % change"
      type: number
      sql: CASE WHEN ${current_period_sales} = 0
            THEN NULL
            ELSE (1.0 * ${current_period_sales} / NULLIF(${previous_period_sales} ,0)) - 1 END ;;
      value_format_name: percent_2
    }

  }
  explore: order_items_pop3 {
    label: "Order Items PoP Method 3: Custom choice of current and previous periods with parameters"
  }
