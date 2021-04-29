{
  "$schema": "https://vega.github.io/schema/vega-lite/v4.json",
  "description": "Birds",
  "data": {
    "url": "https://www.economicsobservatory.com/wp-content/uploads/2021/01/birds2.csv"
  },
  "transform": [
    {
      "filter": {
        "field": "Week",
        "range": [
          {"year": 2010, "month": "dec", "date": 1},
          {"year": 2020, "month": "dec", "date": 30}
        ]
      }
    }
  ],
  "height": 399,
  "width": 400,
  "mark": {"type": "bar"},
  "encoding": {
    "x": {"field": "Week", "type": "temporal"},
    "y": {"field": "Value", "type": "quantitative", "title": "Search index"},
    "color": {"field": "Measure", "type": "nominal", "title": "Search term"},
    "tooltip": [
      {"field": "Measure", "type": "ordinal", "title": "Search index"},
      {"field": "Week", "type": "temporal", "title": "Date"},
      {"field": "Value", "type": "quantitative"}
    ]
  }
}