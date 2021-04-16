# Data Editor: Trial Task 
Submission by: *Dénes Csala*

📊 This is a visual explanation of the solve-through of the trial task. It is an interactive [Jupyter](https://jupyter.org/) notebook. 
* Feel free to download it (first icon from the right in the top menu) it and run it locally (you will need a local [Jupyter](https://jupyter.org/) installation, I recommend [Anaconda](http://www.anaconda.com/)) to regenerate the outputs. 
* You can also launch a live copy of it in the cloud on [Binder](https://mybinder.org/) by clicking the second icon from the right or by reuploading the downloaded _.ipynb_ file to [Google Colab](https://colab.research.google.com/). 
* If you decide to run it locally, you will also need the [Altair](https://altair-viz.github.io/getting_started/installation.html) package. 
* If you want to be fancy and run everything locally, without the need for the _Vega-Lite_ renderer server, also install the [altair_saver](https://github.com/altair-viz/altair_saver/) and [altair_viewer](https://github.com/altair-viz/altair_viewer/) packages.

## First steps

Import dependencies


```python
import pandas as pd, numpy as np
import matplotlib.pyplot as plt
import altair as alt
```

The task is to recreate a graph exported form the [St. Louis FED](https://fred.stlouisfed.org/). After a bit of digging, we can recreate the orignal graph in the _FRED Data Editor_:
* 🕹 [Interactive](https://fred.stlouisfed.org/graph/?g=Cgea)
* 👇 [Static](https://fred.stlouisfed.org/graph/fredgraph.png?g=Cgvc)


```python
%%html
<img style='width:700px' style='border:none;' src='fred.png'>
```


<img style='width:700px' style='border:none;' src='fred.png'>



After searching the database for the above two datasets and examining the download links, it becomes apparent that we need to download the following two indicators:


```python
indicator1='DRTSCIS'
indicator2='BAMLH0A0HYM2'
pretty_indicator={'DRTSCIS':'Net Percentage of Domestic Banks Tightening Standards for Commercial and Industrial Loans to Small Firms',
                 'BAMLH0A0HYM2':'ICE BofA US High Yield Index Option-Adjusted Spread'}
```

One could use the ⬇ download button provided by the site (and I've done what to fulfill the requirements of the task: [DRTSCIS](https://raw.githubusercontent.com/csaladenes/eco/main/DRTSCIS.csv), [BAMLH0A0HYM2](https://raw.githubusercontent.com/csaladenes/eco/main/BAMLH0A0HYM2.csv)), but after examining the download link we can quickly discover that the site has a reasonable _API_, it is safer therefore to use the API directly:


```python
df1=pd.read_csv('https://fred.stlouisfed.org/graph/fredgraph.csv?id='+indicator1)
df2=pd.read_csv('https://fred.stlouisfed.org/graph/fredgraph.csv?id='+indicator2)
```

## Chart 1

After some initial data wrangling it becomes apparent that the two datasets have different frequencies, and their start and end stamps do not match. WE therefore need to define clear start and end dates.


```python
start='2000-01-01'
end='2020-12-31'
```

Furthermore, on the graph, there are three shaded areas, indicating the recession times. We need to define these manually.  


```python
recessions=[{
            "start": "2001-03-31",
            "end": "2001-11-30",
            "event": "recession"
          },
          {
            "start": "2007-12-31",
            "end": "2009-06-30",
            "event": "recession"
          },
          {
            "start": "2020-02-29",
            "end": "2021-04-01",
            "event": "covid"
          }]
color_dict={'covid':'#F3F4D8','recession':'#E2E2E2'}
dr=pd.DataFrame(recessions)
dr['color']=[color_dict[i] for i in dr['event']]
```

### ⚙ Data processing

A few more data processing steps are necessary before we can load the data into _Vega-lite_. I have chained them one after another, using `pandas`. 
* First we need to the set type of the of the _DATE_ column to `datetime`.
* After this, we need to filter the datasets to only values contained between `start` and `end`.
* For the second dataset, some values are represented as `.` - we need to clean these up.


```python
df1=df1.astype({'DATE':np.datetime64}).set_index('DATE').dropna().loc[start:end].reset_index()
df2=df2.astype({'DATE':np.datetime64}).set_index('DATE').replace('.',np.nan).astype(float).loc[start:end].reset_index().dropna()
```

After careful examination of the interactive plot on the _FRED_ site, it indicates that for the _BAMLH0A0HYM2_ dataset the reported and graphed period is always the latest available date in a certain month (not necessarily the last date of the month). Therefore, filter the dataset for only those rows where  switchover happens between two months.


```python
df2=df2[pd.to_datetime(df2['DATE']).dt.month.diff(periods=-1)!=0]
```

### 📈 Plotting

Next up we define the plotter function, using `Altair` to generate a `Vega-Lite` grammar, which in turn gets translated to vanilla `Vega`.
* The visualization has 4 components:
    * The line for `DRTSCIS` on the right `y` axis
    * The line `BAMLH0A0HYM2` on the left `y` axis 
    * The shaded recession areas
    * The thick zeroline
* The transformation tasks are the following:
    * Generate line plots
    * Allocate the correct colors
    * Set scales & domains
    * Set axis labels
    * Set axis tick intervals & ticks
    * Set axis tick formats
    * Set up shadded areas and zeroline
    * Set up z-order
    * Concatenate everything onto one timeline plot, with `DRTSCIS` on the right `y` axis
* 👇 Et voila!


```python
def plotter(df1,df2,dr):
    l1=alt.Chart(df1)\
        .mark_line(
        line=True,
        color='#A53F3D'
        ).encode(
        x='DATE:T',
        y=alt.Y(indicator1+':Q', 
                title='Percent', 
                scale=alt.Scale(domain=(-30, 90)),
                axis=alt.Axis(
                    format= ".0f",
                    tickCount=9,
                    titleFontWeight='normal',
                    values=[15*i for i in range(-2,7)]
                )
               )
    )
    l2=alt.Chart(df2)\
        .mark_line(
        line=True,
        color='#557CAA'
        ).encode(
        x=alt.X('DATE:T', 
                title=None,
                axis=alt.Axis(
                    grid=False,
                    tickCount=10
                )
               ),
        y=alt.Y(indicator2+':Q', 
                title='Percent', 
                scale=alt.Scale(domain=[0, 20]),
                axis=alt.Axis(
                    format= ".1f",
                    grid=True,
                    tickCount=9,
                    titleFontWeight='normal',
                    values=[2.5*i for i in range(9)]
                )
               )
    )
    rect = alt.Chart(dr).mark_rect(
        blend='darken'
    ).encode(
        x='start:T',
        x2='end:T',
        color=alt.Color('color:N',scale=None),
#     ).properties(
#         width=700,
#         height=250
    )
    l = alt.Chart(pd.DataFrame([{'value':0}])).mark_rule(size=3).encode(
        y=alt.Y('value:Q', 
                title=None, 
                scale=alt.Scale(domain=[0, 20]),
                axis=alt.Axis(
                    values=[],
                    grid=False
                )
               ),
    )
    return ((rect)+((l2+l1+l).resolve_scale(y='independent'))+l).configure_view(
        continuousHeight=250,
        continuousWidth=700,
    )
plotter(df1,df2,dr)
```





<div id="altair-viz-1483297755644eb1a00a5fd4f068808c"></div>
<script type="text/javascript">
  (function(spec, embedOpt){
    let outputDiv = document.currentScript.previousElementSibling;
    if (outputDiv.id !== "altair-viz-1483297755644eb1a00a5fd4f068808c") {
      outputDiv = document.getElementById("altair-viz-1483297755644eb1a00a5fd4f068808c");
    }
    const paths = {
      "vega": "https://cdn.jsdelivr.net/npm//vega@5?noext",
      "vega-lib": "https://cdn.jsdelivr.net/npm//vega-lib?noext",
      "vega-lite": "https://cdn.jsdelivr.net/npm//vega-lite@4.8.1?noext",
      "vega-embed": "https://cdn.jsdelivr.net/npm//vega-embed@6?noext",
    };

    function loadScript(lib) {
      return new Promise(function(resolve, reject) {
        var s = document.createElement('script');
        s.src = paths[lib];
        s.async = true;
        s.onload = () => resolve(paths[lib]);
        s.onerror = () => reject(`Error loading script: ${paths[lib]}`);
        document.getElementsByTagName("head")[0].appendChild(s);
      });
    }

    function showError(err) {
      outputDiv.innerHTML = `<div class="error" style="color:red;">${err}</div>`;
      throw err;
    }

    function displayChart(vegaEmbed) {
      vegaEmbed(outputDiv, spec, embedOpt)
        .catch(err => showError(`Javascript Error: ${err.message}<br>This usually means there's a typo in your chart specification. See the javascript console for the full traceback.`));
    }

    if(typeof define === "function" && define.amd) {
      requirejs.config({paths});
      require(["vega-embed"], displayChart, err => showError(`Error loading script: ${err.message}`));
    } else if (typeof vegaEmbed === "function") {
      displayChart(vegaEmbed);
    } else {
      loadScript("vega")
        .then(() => loadScript("vega-lite"))
        .then(() => loadScript("vega-embed"))
        .catch(showError)
        .then(() => displayChart(vegaEmbed));
    }
  })({"config": {"view": {"continuousWidth": 700, "continuousHeight": 250}}, "layer": [{"data": {"name": "data-2b08226b30bbb08a20f45bc01ddaafde"}, "mark": {"type": "rect", "blend": "darken"}, "encoding": {"color": {"type": "nominal", "field": "color", "scale": null}, "x": {"type": "temporal", "field": "start"}, "x2": {"field": "end"}}}, {"layer": [{"data": {"name": "data-6ed5a39391315cf3ad87497286e387ef"}, "mark": {"type": "line", "color": "#557CAA", "line": true}, "encoding": {"x": {"type": "temporal", "axis": {"grid": false, "tickCount": 10}, "field": "DATE", "title": null}, "y": {"type": "quantitative", "axis": {"format": ".1f", "grid": true, "tickCount": 9, "titleFontWeight": "normal", "values": [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]}, "field": "BAMLH0A0HYM2", "scale": {"domain": [0, 20]}, "title": "Percent"}}}, {"data": {"name": "data-31af04096cd0c79173243a476031e47a"}, "mark": {"type": "line", "color": "#A53F3D", "line": true}, "encoding": {"x": {"type": "temporal", "field": "DATE"}, "y": {"type": "quantitative", "axis": {"format": ".0f", "tickCount": 9, "titleFontWeight": "normal", "values": [-30, -15, 0, 15, 30, 45, 60, 75, 90]}, "field": "DRTSCIS", "scale": {"domain": [-30, 90]}, "title": "Percent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "resolve": {"scale": {"y": "independent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "$schema": "https://vega.github.io/schema/vega-lite/v4.8.1.json", "datasets": {"data-2b08226b30bbb08a20f45bc01ddaafde": [{"start": "2001-03-31", "end": "2001-11-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2007-12-31", "end": "2009-06-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2020-02-29", "end": "2021-04-01", "event": "covid", "color": "#F3F4D8"}], "data-6ed5a39391315cf3ad87497286e387ef": [{"DATE": "2000-01-31T00:00:00", "BAMLH0A0HYM2": 4.87}, {"DATE": "2000-02-29T00:00:00", "BAMLH0A0HYM2": 5.08}, {"DATE": "2000-03-31T00:00:00", "BAMLH0A0HYM2": 5.75}, {"DATE": "2000-04-30T00:00:00", "BAMLH0A0HYM2": 5.88}, {"DATE": "2000-05-31T00:00:00", "BAMLH0A0HYM2": 6.16}, {"DATE": "2000-06-30T00:00:00", "BAMLH0A0HYM2": 6.17}, {"DATE": "2000-07-31T00:00:00", "BAMLH0A0HYM2": 6.26}, {"DATE": "2000-08-31T00:00:00", "BAMLH0A0HYM2": 6.43}, {"DATE": "2000-09-30T00:00:00", "BAMLH0A0HYM2": 6.77}, {"DATE": "2000-10-31T00:00:00", "BAMLH0A0HYM2": 7.79}, {"DATE": "2000-11-30T00:00:00", "BAMLH0A0HYM2": 9.06}, {"DATE": "2000-12-31T00:00:00", "BAMLH0A0HYM2": 9.16}, {"DATE": "2001-01-31T00:00:00", "BAMLH0A0HYM2": 7.87}, {"DATE": "2001-02-28T00:00:00", "BAMLH0A0HYM2": 7.7}, {"DATE": "2001-03-31T00:00:00", "BAMLH0A0HYM2": 8.18}, {"DATE": "2001-04-30T00:00:00", "BAMLH0A0HYM2": 8.06}, {"DATE": "2001-05-31T00:00:00", "BAMLH0A0HYM2": 7.68}, {"DATE": "2001-06-30T00:00:00", "BAMLH0A0HYM2": 8.16}, {"DATE": "2001-07-31T00:00:00", "BAMLH0A0HYM2": 8.27}, {"DATE": "2001-08-31T00:00:00", "BAMLH0A0HYM2": 8.05}, {"DATE": "2001-09-30T00:00:00", "BAMLH0A0HYM2": 10.18}, {"DATE": "2001-10-31T00:00:00", "BAMLH0A0HYM2": 9.61}, {"DATE": "2001-11-30T00:00:00", "BAMLH0A0HYM2": 8.39}, {"DATE": "2001-12-31T00:00:00", "BAMLH0A0HYM2": 8.24}, {"DATE": "2002-01-31T00:00:00", "BAMLH0A0HYM2": 7.89}, {"DATE": "2002-02-28T00:00:00", "BAMLH0A0HYM2": 8.19}, {"DATE": "2002-03-31T00:00:00", "BAMLH0A0HYM2": 7.08}, {"DATE": "2002-04-30T00:00:00", "BAMLH0A0HYM2": 6.88}, {"DATE": "2002-05-31T00:00:00", "BAMLH0A0HYM2": 7.28}, {"DATE": "2002-06-30T00:00:00", "BAMLH0A0HYM2": 8.75}, {"DATE": "2002-07-31T00:00:00", "BAMLH0A0HYM2": 9.71}, {"DATE": "2002-08-31T00:00:00", "BAMLH0A0HYM2": 9.61}, {"DATE": "2002-09-30T00:00:00", "BAMLH0A0HYM2": 10.33}, {"DATE": "2002-10-31T00:00:00", "BAMLH0A0HYM2": 10.59}, {"DATE": "2002-11-30T00:00:00", "BAMLH0A0HYM2": 8.83}, {"DATE": "2002-12-31T00:00:00", "BAMLH0A0HYM2": 8.9}, {"DATE": "2003-01-31T00:00:00", "BAMLH0A0HYM2": 8.29}, {"DATE": "2003-02-28T00:00:00", "BAMLH0A0HYM2": 8.38}, {"DATE": "2003-03-31T00:00:00", "BAMLH0A0HYM2": 7.72}, {"DATE": "2003-04-30T00:00:00", "BAMLH0A0HYM2": 6.44}, {"DATE": "2003-05-31T00:00:00", "BAMLH0A0HYM2": 6.79}, {"DATE": "2003-06-30T00:00:00", "BAMLH0A0HYM2": 6.13}, {"DATE": "2003-07-31T00:00:00", "BAMLH0A0HYM2": 5.67}, {"DATE": "2003-08-31T00:00:00", "BAMLH0A0HYM2": 5.46}, {"DATE": "2003-09-30T00:00:00", "BAMLH0A0HYM2": 5.51}, {"DATE": "2003-10-31T00:00:00", "BAMLH0A0HYM2": 4.73}, {"DATE": "2003-11-30T00:00:00", "BAMLH0A0HYM2": 4.48}, {"DATE": "2003-12-31T00:00:00", "BAMLH0A0HYM2": 4.18}, {"DATE": "2004-01-31T00:00:00", "BAMLH0A0HYM2": 4.05}, {"DATE": "2004-02-29T00:00:00", "BAMLH0A0HYM2": 4.34}, {"DATE": "2004-03-31T00:00:00", "BAMLH0A0HYM2": 4.41}, {"DATE": "2004-04-30T00:00:00", "BAMLH0A0HYM2": 3.91}, {"DATE": "2004-05-31T00:00:00", "BAMLH0A0HYM2": 4.28}, {"DATE": "2004-06-30T00:00:00", "BAMLH0A0HYM2": 4.1}, {"DATE": "2004-07-31T00:00:00", "BAMLH0A0HYM2": 4.02}, {"DATE": "2004-08-31T00:00:00", "BAMLH0A0HYM2": 4.06}, {"DATE": "2004-09-30T00:00:00", "BAMLH0A0HYM2": 3.83}, {"DATE": "2004-10-31T00:00:00", "BAMLH0A0HYM2": 3.63}, {"DATE": "2004-11-30T00:00:00", "BAMLH0A0HYM2": 3.17}, {"DATE": "2004-12-31T00:00:00", "BAMLH0A0HYM2": 3.1}, {"DATE": "2005-01-31T00:00:00", "BAMLH0A0HYM2": 3.29}, {"DATE": "2005-02-28T00:00:00", "BAMLH0A0HYM2": 2.83}, {"DATE": "2005-03-31T00:00:00", "BAMLH0A0HYM2": 3.52}, {"DATE": "2005-04-30T00:00:00", "BAMLH0A0HYM2": 4.19}, {"DATE": "2005-05-31T00:00:00", "BAMLH0A0HYM2": 4.13}, {"DATE": "2005-06-30T00:00:00", "BAMLH0A0HYM2": 3.85}, {"DATE": "2005-07-31T00:00:00", "BAMLH0A0HYM2": 3.3}, {"DATE": "2005-08-31T00:00:00", "BAMLH0A0HYM2": 3.66}, {"DATE": "2005-09-30T00:00:00", "BAMLH0A0HYM2": 3.54}, {"DATE": "2005-10-31T00:00:00", "BAMLH0A0HYM2": 3.61}, {"DATE": "2005-11-30T00:00:00", "BAMLH0A0HYM2": 3.67}, {"DATE": "2005-12-31T00:00:00", "BAMLH0A0HYM2": 3.71}, {"DATE": "2006-01-31T00:00:00", "BAMLH0A0HYM2": 3.42}, {"DATE": "2006-02-28T00:00:00", "BAMLH0A0HYM2": 3.37}, {"DATE": "2006-03-31T00:00:00", "BAMLH0A0HYM2": 3.13}, {"DATE": "2006-04-30T00:00:00", "BAMLH0A0HYM2": 3.04}, {"DATE": "2006-05-31T00:00:00", "BAMLH0A0HYM2": 3.12}, {"DATE": "2006-06-30T00:00:00", "BAMLH0A0HYM2": 3.35}, {"DATE": "2006-07-31T00:00:00", "BAMLH0A0HYM2": 3.45}, {"DATE": "2006-08-31T00:00:00", "BAMLH0A0HYM2": 3.49}, {"DATE": "2006-09-30T00:00:00", "BAMLH0A0HYM2": 3.44}, {"DATE": "2006-10-31T00:00:00", "BAMLH0A0HYM2": 3.29}, {"DATE": "2006-11-30T00:00:00", "BAMLH0A0HYM2": 3.2}, {"DATE": "2006-12-31T00:00:00", "BAMLH0A0HYM2": 2.89}, {"DATE": "2007-01-31T00:00:00", "BAMLH0A0HYM2": 2.72}, {"DATE": "2007-02-28T00:00:00", "BAMLH0A0HYM2": 2.82}, {"DATE": "2007-03-31T00:00:00", "BAMLH0A0HYM2": 2.85}, {"DATE": "2007-04-30T00:00:00", "BAMLH0A0HYM2": 2.74}, {"DATE": "2007-05-31T00:00:00", "BAMLH0A0HYM2": 2.46}, {"DATE": "2007-06-30T00:00:00", "BAMLH0A0HYM2": 2.98}, {"DATE": "2007-07-31T00:00:00", "BAMLH0A0HYM2": 4.19}, {"DATE": "2007-08-31T00:00:00", "BAMLH0A0HYM2": 4.55}, {"DATE": "2007-09-30T00:00:00", "BAMLH0A0HYM2": 4.2}, {"DATE": "2007-10-31T00:00:00", "BAMLH0A0HYM2": 4.36}, {"DATE": "2007-11-30T00:00:00", "BAMLH0A0HYM2": 5.75}, {"DATE": "2007-12-31T00:00:00", "BAMLH0A0HYM2": 5.92}, {"DATE": "2008-01-31T00:00:00", "BAMLH0A0HYM2": 6.95}, {"DATE": "2008-02-29T00:00:00", "BAMLH0A0HYM2": 7.67}, {"DATE": "2008-03-31T00:00:00", "BAMLH0A0HYM2": 8.21}, {"DATE": "2008-04-30T00:00:00", "BAMLH0A0HYM2": 6.86}, {"DATE": "2008-05-31T00:00:00", "BAMLH0A0HYM2": 6.53}, {"DATE": "2008-06-30T00:00:00", "BAMLH0A0HYM2": 7.35}, {"DATE": "2008-07-31T00:00:00", "BAMLH0A0HYM2": 8.0}, {"DATE": "2008-08-31T00:00:00", "BAMLH0A0HYM2": 8.36}, {"DATE": "2008-09-30T00:00:00", "BAMLH0A0HYM2": 10.96}, {"DATE": "2008-10-31T00:00:00", "BAMLH0A0HYM2": 16.17}, {"DATE": "2008-11-30T00:00:00", "BAMLH0A0HYM2": 19.88}, {"DATE": "2008-12-31T00:00:00", "BAMLH0A0HYM2": 18.12}, {"DATE": "2009-01-31T00:00:00", "BAMLH0A0HYM2": 16.26}, {"DATE": "2009-02-28T00:00:00", "BAMLH0A0HYM2": 17.38}, {"DATE": "2009-03-31T00:00:00", "BAMLH0A0HYM2": 17.03}, {"DATE": "2009-04-30T00:00:00", "BAMLH0A0HYM2": 13.45}, {"DATE": "2009-05-31T00:00:00", "BAMLH0A0HYM2": 11.7}, {"DATE": "2009-06-30T00:00:00", "BAMLH0A0HYM2": 10.55}, {"DATE": "2009-07-31T00:00:00", "BAMLH0A0HYM2": 9.22}, {"DATE": "2009-08-31T00:00:00", "BAMLH0A0HYM2": 9.12}, {"DATE": "2009-09-30T00:00:00", "BAMLH0A0HYM2": 7.93}, {"DATE": "2009-10-31T00:00:00", "BAMLH0A0HYM2": 7.6}, {"DATE": "2009-11-30T00:00:00", "BAMLH0A0HYM2": 7.65}, {"DATE": "2009-12-31T00:00:00", "BAMLH0A0HYM2": 6.39}, {"DATE": "2010-01-31T00:00:00", "BAMLH0A0HYM2": 6.54}, {"DATE": "2010-02-28T00:00:00", "BAMLH0A0HYM2": 6.71}, {"DATE": "2010-03-31T00:00:00", "BAMLH0A0HYM2": 5.84}, {"DATE": "2010-04-30T00:00:00", "BAMLH0A0HYM2": 5.61}, {"DATE": "2010-05-31T00:00:00", "BAMLH0A0HYM2": 6.98}, {"DATE": "2010-06-30T00:00:00", "BAMLH0A0HYM2": 7.13}, {"DATE": "2010-07-31T00:00:00", "BAMLH0A0HYM2": 6.59}, {"DATE": "2010-08-31T00:00:00", "BAMLH0A0HYM2": 6.92}, {"DATE": "2010-09-30T00:00:00", "BAMLH0A0HYM2": 6.26}, {"DATE": "2010-10-31T00:00:00", "BAMLH0A0HYM2": 5.93}, {"DATE": "2010-11-30T00:00:00", "BAMLH0A0HYM2": 6.22}, {"DATE": "2010-12-31T00:00:00", "BAMLH0A0HYM2": 5.41}, {"DATE": "2011-01-31T00:00:00", "BAMLH0A0HYM2": 5.08}, {"DATE": "2011-02-28T00:00:00", "BAMLH0A0HYM2": 4.78}, {"DATE": "2011-03-31T00:00:00", "BAMLH0A0HYM2": 4.77}, {"DATE": "2011-04-30T00:00:00", "BAMLH0A0HYM2": 4.76}, {"DATE": "2011-05-31T00:00:00", "BAMLH0A0HYM2": 5.09}, {"DATE": "2011-06-30T00:00:00", "BAMLH0A0HYM2": 5.42}, {"DATE": "2011-07-31T00:00:00", "BAMLH0A0HYM2": 5.58}, {"DATE": "2011-08-31T00:00:00", "BAMLH0A0HYM2": 7.3}, {"DATE": "2011-09-30T00:00:00", "BAMLH0A0HYM2": 8.41}, {"DATE": "2011-10-31T00:00:00", "BAMLH0A0HYM2": 7.07}, {"DATE": "2011-11-30T00:00:00", "BAMLH0A0HYM2": 7.79}, {"DATE": "2011-12-31T00:00:00", "BAMLH0A0HYM2": 7.23}, {"DATE": "2012-01-31T00:00:00", "BAMLH0A0HYM2": 6.61}, {"DATE": "2012-02-29T00:00:00", "BAMLH0A0HYM2": 5.98}, {"DATE": "2012-03-31T00:00:00", "BAMLH0A0HYM2": 5.99}, {"DATE": "2012-04-30T00:00:00", "BAMLH0A0HYM2": 6.04}, {"DATE": "2012-05-31T00:00:00", "BAMLH0A0HYM2": 6.96}, {"DATE": "2012-06-30T00:00:00", "BAMLH0A0HYM2": 6.44}, {"DATE": "2012-07-31T00:00:00", "BAMLH0A0HYM2": 6.16}, {"DATE": "2012-08-31T00:00:00", "BAMLH0A0HYM2": 5.98}, {"DATE": "2012-09-30T00:00:00", "BAMLH0A0HYM2": 5.74}, {"DATE": "2012-10-31T00:00:00", "BAMLH0A0HYM2": 5.63}, {"DATE": "2012-11-30T00:00:00", "BAMLH0A0HYM2": 5.65}, {"DATE": "2012-12-31T00:00:00", "BAMLH0A0HYM2": 5.34}, {"DATE": "2013-01-31T00:00:00", "BAMLH0A0HYM2": 4.95}, {"DATE": "2013-02-28T00:00:00", "BAMLH0A0HYM2": 4.98}, {"DATE": "2013-03-31T00:00:00", "BAMLH0A0HYM2": 4.86}, {"DATE": "2013-04-30T00:00:00", "BAMLH0A0HYM2": 4.55}, {"DATE": "2013-05-31T00:00:00", "BAMLH0A0HYM2": 4.62}, {"DATE": "2013-06-30T00:00:00", "BAMLH0A0HYM2": 5.21}, {"DATE": "2013-07-31T00:00:00", "BAMLH0A0HYM2": 4.71}, {"DATE": "2013-08-29T00:00:00", "BAMLH0A0HYM2": 4.76}, {"DATE": "2013-09-30T00:00:00", "BAMLH0A0HYM2": 4.83}, {"DATE": "2013-10-31T00:00:00", "BAMLH0A0HYM2": 4.36}, {"DATE": "2013-11-30T00:00:00", "BAMLH0A0HYM2": 4.27}, {"DATE": "2013-12-31T00:00:00", "BAMLH0A0HYM2": 4.0}, {"DATE": "2014-01-31T00:00:00", "BAMLH0A0HYM2": 4.21}, {"DATE": "2014-02-28T00:00:00", "BAMLH0A0HYM2": 3.81}, {"DATE": "2014-03-31T00:00:00", "BAMLH0A0HYM2": 3.77}, {"DATE": "2014-04-30T00:00:00", "BAMLH0A0HYM2": 3.71}, {"DATE": "2014-05-31T00:00:00", "BAMLH0A0HYM2": 3.67}, {"DATE": "2014-06-30T00:00:00", "BAMLH0A0HYM2": 3.53}, {"DATE": "2014-07-31T00:00:00", "BAMLH0A0HYM2": 4.04}, {"DATE": "2014-08-31T00:00:00", "BAMLH0A0HYM2": 3.84}, {"DATE": "2014-09-30T00:00:00", "BAMLH0A0HYM2": 4.4}, {"DATE": "2014-10-31T00:00:00", "BAMLH0A0HYM2": 4.3}, {"DATE": "2014-11-30T00:00:00", "BAMLH0A0HYM2": 4.67}, {"DATE": "2014-12-31T00:00:00", "BAMLH0A0HYM2": 5.04}, {"DATE": "2015-01-31T00:00:00", "BAMLH0A0HYM2": 5.26}, {"DATE": "2015-02-28T00:00:00", "BAMLH0A0HYM2": 4.46}, {"DATE": "2015-03-31T00:00:00", "BAMLH0A0HYM2": 4.82}, {"DATE": "2015-04-30T00:00:00", "BAMLH0A0HYM2": 4.59}, {"DATE": "2015-05-31T00:00:00", "BAMLH0A0HYM2": 4.58}, {"DATE": "2015-06-30T00:00:00", "BAMLH0A0HYM2": 5.0}, {"DATE": "2015-07-31T00:00:00", "BAMLH0A0HYM2": 5.36}, {"DATE": "2015-08-31T00:00:00", "BAMLH0A0HYM2": 5.7}, {"DATE": "2015-09-30T00:00:00", "BAMLH0A0HYM2": 6.62}, {"DATE": "2015-10-31T00:00:00", "BAMLH0A0HYM2": 5.9}, {"DATE": "2015-11-30T00:00:00", "BAMLH0A0HYM2": 6.4}, {"DATE": "2015-12-31T00:00:00", "BAMLH0A0HYM2": 6.95}, {"DATE": "2016-01-31T00:00:00", "BAMLH0A0HYM2": 7.77}, {"DATE": "2016-02-29T00:00:00", "BAMLH0A0HYM2": 7.75}, {"DATE": "2016-03-31T00:00:00", "BAMLH0A0HYM2": 7.05}, {"DATE": "2016-04-30T00:00:00", "BAMLH0A0HYM2": 6.21}, {"DATE": "2016-05-31T00:00:00", "BAMLH0A0HYM2": 5.97}, {"DATE": "2016-06-30T00:00:00", "BAMLH0A0HYM2": 6.21}, {"DATE": "2016-07-31T00:00:00", "BAMLH0A0HYM2": 5.69}, {"DATE": "2016-08-31T00:00:00", "BAMLH0A0HYM2": 5.1}, {"DATE": "2016-09-30T00:00:00", "BAMLH0A0HYM2": 4.97}, {"DATE": "2016-10-31T00:00:00", "BAMLH0A0HYM2": 4.91}, {"DATE": "2016-11-30T00:00:00", "BAMLH0A0HYM2": 4.67}, {"DATE": "2016-12-31T00:00:00", "BAMLH0A0HYM2": 4.22}, {"DATE": "2017-01-31T00:00:00", "BAMLH0A0HYM2": 4.0}, {"DATE": "2017-02-28T00:00:00", "BAMLH0A0HYM2": 3.74}, {"DATE": "2017-03-31T00:00:00", "BAMLH0A0HYM2": 3.92}, {"DATE": "2017-04-30T00:00:00", "BAMLH0A0HYM2": 3.81}, {"DATE": "2017-05-31T00:00:00", "BAMLH0A0HYM2": 3.74}, {"DATE": "2017-06-30T00:00:00", "BAMLH0A0HYM2": 3.77}, {"DATE": "2017-07-31T00:00:00", "BAMLH0A0HYM2": 3.61}, {"DATE": "2017-08-31T00:00:00", "BAMLH0A0HYM2": 3.85}, {"DATE": "2017-09-30T00:00:00", "BAMLH0A0HYM2": 3.56}, {"DATE": "2017-10-31T00:00:00", "BAMLH0A0HYM2": 3.51}, {"DATE": "2017-11-30T00:00:00", "BAMLH0A0HYM2": 3.61}, {"DATE": "2017-12-31T00:00:00", "BAMLH0A0HYM2": 3.63}, {"DATE": "2018-01-31T00:00:00", "BAMLH0A0HYM2": 3.29}, {"DATE": "2018-02-28T00:00:00", "BAMLH0A0HYM2": 3.47}, {"DATE": "2018-03-31T00:00:00", "BAMLH0A0HYM2": 3.72}, {"DATE": "2018-04-30T00:00:00", "BAMLH0A0HYM2": 3.46}, {"DATE": "2018-05-31T00:00:00", "BAMLH0A0HYM2": 3.63}, {"DATE": "2018-06-30T00:00:00", "BAMLH0A0HYM2": 3.71}, {"DATE": "2018-07-31T00:00:00", "BAMLH0A0HYM2": 3.46}, {"DATE": "2018-08-31T00:00:00", "BAMLH0A0HYM2": 3.49}, {"DATE": "2018-09-30T00:00:00", "BAMLH0A0HYM2": 3.28}, {"DATE": "2018-10-31T00:00:00", "BAMLH0A0HYM2": 3.81}, {"DATE": "2018-11-30T00:00:00", "BAMLH0A0HYM2": 4.29}, {"DATE": "2018-12-31T00:00:00", "BAMLH0A0HYM2": 5.33}, {"DATE": "2019-01-31T00:00:00", "BAMLH0A0HYM2": 4.37}, {"DATE": "2019-02-28T00:00:00", "BAMLH0A0HYM2": 3.92}, {"DATE": "2019-03-31T00:00:00", "BAMLH0A0HYM2": 4.05}, {"DATE": "2019-04-30T00:00:00", "BAMLH0A0HYM2": 3.73}, {"DATE": "2019-05-31T00:00:00", "BAMLH0A0HYM2": 4.59}, {"DATE": "2019-06-30T00:00:00", "BAMLH0A0HYM2": 4.07}, {"DATE": "2019-07-31T00:00:00", "BAMLH0A0HYM2": 3.93}, {"DATE": "2019-08-31T00:00:00", "BAMLH0A0HYM2": 4.13}, {"DATE": "2019-09-30T00:00:00", "BAMLH0A0HYM2": 4.02}, {"DATE": "2019-10-31T00:00:00", "BAMLH0A0HYM2": 4.15}, {"DATE": "2019-11-30T00:00:00", "BAMLH0A0HYM2": 4.02}, {"DATE": "2019-12-31T00:00:00", "BAMLH0A0HYM2": 3.6}, {"DATE": "2020-01-31T00:00:00", "BAMLH0A0HYM2": 4.03}, {"DATE": "2020-02-29T00:00:00", "BAMLH0A0HYM2": 5.06}, {"DATE": "2020-03-31T00:00:00", "BAMLH0A0HYM2": 8.77}, {"DATE": "2020-04-30T00:00:00", "BAMLH0A0HYM2": 7.63}, {"DATE": "2020-05-31T00:00:00", "BAMLH0A0HYM2": 6.54}, {"DATE": "2020-06-30T00:00:00", "BAMLH0A0HYM2": 6.44}, {"DATE": "2020-07-31T00:00:00", "BAMLH0A0HYM2": 5.16}, {"DATE": "2020-08-31T00:00:00", "BAMLH0A0HYM2": 5.02}, {"DATE": "2020-09-30T00:00:00", "BAMLH0A0HYM2": 5.41}, {"DATE": "2020-10-31T00:00:00", "BAMLH0A0HYM2": 5.32}, {"DATE": "2020-11-30T00:00:00", "BAMLH0A0HYM2": 4.33}, {"DATE": "2020-12-31T00:00:00", "BAMLH0A0HYM2": 3.86}], "data-31af04096cd0c79173243a476031e47a": [{"DATE": "2000-01-01T00:00:00", "DRTSCIS": 9.4}, {"DATE": "2000-04-01T00:00:00", "DRTSCIS": 21.4}, {"DATE": "2000-07-01T00:00:00", "DRTSCIS": 23.6}, {"DATE": "2000-10-01T00:00:00", "DRTSCIS": 27.3}, {"DATE": "2001-01-01T00:00:00", "DRTSCIS": 45.5}, {"DATE": "2001-04-01T00:00:00", "DRTSCIS": 36.4}, {"DATE": "2001-07-01T00:00:00", "DRTSCIS": 31.6}, {"DATE": "2001-10-01T00:00:00", "DRTSCIS": 40.4}, {"DATE": "2002-01-01T00:00:00", "DRTSCIS": 41.8}, {"DATE": "2002-04-01T00:00:00", "DRTSCIS": 14.5}, {"DATE": "2002-07-01T00:00:00", "DRTSCIS": 5.5}, {"DATE": "2002-10-01T00:00:00", "DRTSCIS": 18.2}, {"DATE": "2003-01-01T00:00:00", "DRTSCIS": 13.8}, {"DATE": "2003-04-01T00:00:00", "DRTSCIS": 12.7}, {"DATE": "2003-07-01T00:00:00", "DRTSCIS": 3.5}, {"DATE": "2003-10-01T00:00:00", "DRTSCIS": -1.8}, {"DATE": "2004-01-01T00:00:00", "DRTSCIS": -10.9}, {"DATE": "2004-04-01T00:00:00", "DRTSCIS": -19.3}, {"DATE": "2004-07-01T00:00:00", "DRTSCIS": -3.6}, {"DATE": "2004-10-01T00:00:00", "DRTSCIS": -18.2}, {"DATE": "2005-01-01T00:00:00", "DRTSCIS": -13.0}, {"DATE": "2005-04-01T00:00:00", "DRTSCIS": -24.1}, {"DATE": "2005-07-01T00:00:00", "DRTSCIS": -11.1}, {"DATE": "2005-10-01T00:00:00", "DRTSCIS": -5.3}, {"DATE": "2006-01-01T00:00:00", "DRTSCIS": -7.1}, {"DATE": "2006-04-01T00:00:00", "DRTSCIS": -7.0}, {"DATE": "2006-07-01T00:00:00", "DRTSCIS": -1.8}, {"DATE": "2006-10-01T00:00:00", "DRTSCIS": -1.9}, {"DATE": "2007-01-01T00:00:00", "DRTSCIS": 5.4}, {"DATE": "2007-04-01T00:00:00", "DRTSCIS": 1.9}, {"DATE": "2007-07-01T00:00:00", "DRTSCIS": 7.7}, {"DATE": "2007-10-01T00:00:00", "DRTSCIS": 9.6}, {"DATE": "2008-01-01T00:00:00", "DRTSCIS": 30.4}, {"DATE": "2008-04-01T00:00:00", "DRTSCIS": 51.8}, {"DATE": "2008-07-01T00:00:00", "DRTSCIS": 65.4}, {"DATE": "2008-10-01T00:00:00", "DRTSCIS": 74.5}, {"DATE": "2009-01-01T00:00:00", "DRTSCIS": 69.2}, {"DATE": "2009-04-01T00:00:00", "DRTSCIS": 42.3}, {"DATE": "2009-07-01T00:00:00", "DRTSCIS": 34.0}, {"DATE": "2009-10-01T00:00:00", "DRTSCIS": 16.1}, {"DATE": "2010-01-01T00:00:00", "DRTSCIS": 3.7}, {"DATE": "2010-04-01T00:00:00", "DRTSCIS": 0.0}, {"DATE": "2010-07-01T00:00:00", "DRTSCIS": -9.1}, {"DATE": "2010-10-01T00:00:00", "DRTSCIS": -7.1}, {"DATE": "2011-01-01T00:00:00", "DRTSCIS": -1.9}, {"DATE": "2011-04-01T00:00:00", "DRTSCIS": -13.5}, {"DATE": "2011-07-01T00:00:00", "DRTSCIS": -7.8}, {"DATE": "2011-10-01T00:00:00", "DRTSCIS": -6.3}, {"DATE": "2012-01-01T00:00:00", "DRTSCIS": 1.9}, {"DATE": "2012-04-01T00:00:00", "DRTSCIS": -1.8}, {"DATE": "2012-07-01T00:00:00", "DRTSCIS": -4.9}, {"DATE": "2012-10-01T00:00:00", "DRTSCIS": -7.6}, {"DATE": "2013-01-01T00:00:00", "DRTSCIS": -7.7}, {"DATE": "2013-04-01T00:00:00", "DRTSCIS": -23.1}, {"DATE": "2013-07-01T00:00:00", "DRTSCIS": -10.0}, {"DATE": "2013-10-01T00:00:00", "DRTSCIS": -7.1}, {"DATE": "2014-01-01T00:00:00", "DRTSCIS": -4.2}, {"DATE": "2014-04-01T00:00:00", "DRTSCIS": -7.0}, {"DATE": "2014-07-01T00:00:00", "DRTSCIS": -8.3}, {"DATE": "2014-10-01T00:00:00", "DRTSCIS": -8.2}, {"DATE": "2015-01-01T00:00:00", "DRTSCIS": -5.7}, {"DATE": "2015-04-01T00:00:00", "DRTSCIS": -1.4}, {"DATE": "2015-07-01T00:00:00", "DRTSCIS": -6.0}, {"DATE": "2015-10-01T00:00:00", "DRTSCIS": 1.5}, {"DATE": "2016-01-01T00:00:00", "DRTSCIS": 4.2}, {"DATE": "2016-04-01T00:00:00", "DRTSCIS": 5.8}, {"DATE": "2016-07-01T00:00:00", "DRTSCIS": 7.1}, {"DATE": "2016-10-01T00:00:00", "DRTSCIS": -1.5}, {"DATE": "2017-01-01T00:00:00", "DRTSCIS": 0.0}, {"DATE": "2017-04-01T00:00:00", "DRTSCIS": -2.9}, {"DATE": "2017-07-01T00:00:00", "DRTSCIS": -4.1}, {"DATE": "2017-10-01T00:00:00", "DRTSCIS": -8.8}, {"DATE": "2018-01-01T00:00:00", "DRTSCIS": 0.0}, {"DATE": "2018-04-01T00:00:00", "DRTSCIS": -3.0}, {"DATE": "2018-07-01T00:00:00", "DRTSCIS": -7.6}, {"DATE": "2018-10-01T00:00:00", "DRTSCIS": -3.1}, {"DATE": "2019-01-01T00:00:00", "DRTSCIS": 4.3}, {"DATE": "2019-04-01T00:00:00", "DRTSCIS": 0.0}, {"DATE": "2019-07-01T00:00:00", "DRTSCIS": -5.8}, {"DATE": "2019-10-01T00:00:00", "DRTSCIS": 5.6}, {"DATE": "2020-01-01T00:00:00", "DRTSCIS": -1.4}, {"DATE": "2020-04-01T00:00:00", "DRTSCIS": 39.7}, {"DATE": "2020-07-01T00:00:00", "DRTSCIS": 70.0}, {"DATE": "2020-10-01T00:00:00", "DRTSCIS": 31.3}], "data-4c6f780913a45f81a467345005541598": [{"value": 0}]}}, {"mode": "vega-lite"});
</script>



❗ After a pixelwise inspection we see that the red line is slightly shifted when compared to the original _FRED_ graph. This is because the _DRTSCIS_ dataset has clearly a monthly frequency (quarterly, actually, but this is irrelevant here). However, when the data exporter on the _FRED_ site was set up, it clearly generates the month labels - i.e. `2020-12`, which then automatically gets appended with a `-01` upon the _.csv_ export. However, as we have already noted, the months actually indicate the ends of the months. Therefore, we need to fix the time labels to reflect thsi change and `2020-03-01` becomes `2020-03-31`. This, of course, is not so straighforward, since the months has differnet durations. We, therefore do a trick here:
* For each month we add 1 to the month number, so that `2020-03-01` becomes `2020-04-01`
* We then substract one day, so it becomes `2020-03-31` for March, or `2020-02-29` for February


```python
df1['DATE']=pd.to_datetime(df1['DATE'].dt.year.astype(str)+'-'+(df1['DATE'].dt.month+1).astype(str)+'-01')+pd.to_timedelta('-1d')
```

🚀 The plot looks perfectly aligned and quite good now!


```python
plotter(df1,df2,dr)
```





<div id="altair-viz-9891e888a89440969d46dea8a30644af"></div>
<script type="text/javascript">
  (function(spec, embedOpt){
    let outputDiv = document.currentScript.previousElementSibling;
    if (outputDiv.id !== "altair-viz-9891e888a89440969d46dea8a30644af") {
      outputDiv = document.getElementById("altair-viz-9891e888a89440969d46dea8a30644af");
    }
    const paths = {
      "vega": "https://cdn.jsdelivr.net/npm//vega@5?noext",
      "vega-lib": "https://cdn.jsdelivr.net/npm//vega-lib?noext",
      "vega-lite": "https://cdn.jsdelivr.net/npm//vega-lite@4.8.1?noext",
      "vega-embed": "https://cdn.jsdelivr.net/npm//vega-embed@6?noext",
    };

    function loadScript(lib) {
      return new Promise(function(resolve, reject) {
        var s = document.createElement('script');
        s.src = paths[lib];
        s.async = true;
        s.onload = () => resolve(paths[lib]);
        s.onerror = () => reject(`Error loading script: ${paths[lib]}`);
        document.getElementsByTagName("head")[0].appendChild(s);
      });
    }

    function showError(err) {
      outputDiv.innerHTML = `<div class="error" style="color:red;">${err}</div>`;
      throw err;
    }

    function displayChart(vegaEmbed) {
      vegaEmbed(outputDiv, spec, embedOpt)
        .catch(err => showError(`Javascript Error: ${err.message}<br>This usually means there's a typo in your chart specification. See the javascript console for the full traceback.`));
    }

    if(typeof define === "function" && define.amd) {
      requirejs.config({paths});
      require(["vega-embed"], displayChart, err => showError(`Error loading script: ${err.message}`));
    } else if (typeof vegaEmbed === "function") {
      displayChart(vegaEmbed);
    } else {
      loadScript("vega")
        .then(() => loadScript("vega-lite"))
        .then(() => loadScript("vega-embed"))
        .catch(showError)
        .then(() => displayChart(vegaEmbed));
    }
  })({"config": {"view": {"continuousWidth": 700, "continuousHeight": 250}}, "layer": [{"data": {"name": "data-2b08226b30bbb08a20f45bc01ddaafde"}, "mark": {"type": "rect", "blend": "darken"}, "encoding": {"color": {"type": "nominal", "field": "color", "scale": null}, "x": {"type": "temporal", "field": "start"}, "x2": {"field": "end"}}}, {"layer": [{"data": {"name": "data-6ed5a39391315cf3ad87497286e387ef"}, "mark": {"type": "line", "color": "#557CAA", "line": true}, "encoding": {"x": {"type": "temporal", "axis": {"grid": false, "tickCount": 10}, "field": "DATE", "title": null}, "y": {"type": "quantitative", "axis": {"format": ".1f", "grid": true, "tickCount": 9, "titleFontWeight": "normal", "values": [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]}, "field": "BAMLH0A0HYM2", "scale": {"domain": [0, 20]}, "title": "Percent"}}}, {"data": {"name": "data-2108533d577388f9f0eb49c2d14449d0"}, "mark": {"type": "line", "color": "#A53F3D", "line": true}, "encoding": {"x": {"type": "temporal", "field": "DATE"}, "y": {"type": "quantitative", "axis": {"format": ".0f", "tickCount": 9, "titleFontWeight": "normal", "values": [-30, -15, 0, 15, 30, 45, 60, 75, 90]}, "field": "DRTSCIS", "scale": {"domain": [-30, 90]}, "title": "Percent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "resolve": {"scale": {"y": "independent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "$schema": "https://vega.github.io/schema/vega-lite/v4.8.1.json", "datasets": {"data-2b08226b30bbb08a20f45bc01ddaafde": [{"start": "2001-03-31", "end": "2001-11-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2007-12-31", "end": "2009-06-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2020-02-29", "end": "2021-04-01", "event": "covid", "color": "#F3F4D8"}], "data-6ed5a39391315cf3ad87497286e387ef": [{"DATE": "2000-01-31T00:00:00", "BAMLH0A0HYM2": 4.87}, {"DATE": "2000-02-29T00:00:00", "BAMLH0A0HYM2": 5.08}, {"DATE": "2000-03-31T00:00:00", "BAMLH0A0HYM2": 5.75}, {"DATE": "2000-04-30T00:00:00", "BAMLH0A0HYM2": 5.88}, {"DATE": "2000-05-31T00:00:00", "BAMLH0A0HYM2": 6.16}, {"DATE": "2000-06-30T00:00:00", "BAMLH0A0HYM2": 6.17}, {"DATE": "2000-07-31T00:00:00", "BAMLH0A0HYM2": 6.26}, {"DATE": "2000-08-31T00:00:00", "BAMLH0A0HYM2": 6.43}, {"DATE": "2000-09-30T00:00:00", "BAMLH0A0HYM2": 6.77}, {"DATE": "2000-10-31T00:00:00", "BAMLH0A0HYM2": 7.79}, {"DATE": "2000-11-30T00:00:00", "BAMLH0A0HYM2": 9.06}, {"DATE": "2000-12-31T00:00:00", "BAMLH0A0HYM2": 9.16}, {"DATE": "2001-01-31T00:00:00", "BAMLH0A0HYM2": 7.87}, {"DATE": "2001-02-28T00:00:00", "BAMLH0A0HYM2": 7.7}, {"DATE": "2001-03-31T00:00:00", "BAMLH0A0HYM2": 8.18}, {"DATE": "2001-04-30T00:00:00", "BAMLH0A0HYM2": 8.06}, {"DATE": "2001-05-31T00:00:00", "BAMLH0A0HYM2": 7.68}, {"DATE": "2001-06-30T00:00:00", "BAMLH0A0HYM2": 8.16}, {"DATE": "2001-07-31T00:00:00", "BAMLH0A0HYM2": 8.27}, {"DATE": "2001-08-31T00:00:00", "BAMLH0A0HYM2": 8.05}, {"DATE": "2001-09-30T00:00:00", "BAMLH0A0HYM2": 10.18}, {"DATE": "2001-10-31T00:00:00", "BAMLH0A0HYM2": 9.61}, {"DATE": "2001-11-30T00:00:00", "BAMLH0A0HYM2": 8.39}, {"DATE": "2001-12-31T00:00:00", "BAMLH0A0HYM2": 8.24}, {"DATE": "2002-01-31T00:00:00", "BAMLH0A0HYM2": 7.89}, {"DATE": "2002-02-28T00:00:00", "BAMLH0A0HYM2": 8.19}, {"DATE": "2002-03-31T00:00:00", "BAMLH0A0HYM2": 7.08}, {"DATE": "2002-04-30T00:00:00", "BAMLH0A0HYM2": 6.88}, {"DATE": "2002-05-31T00:00:00", "BAMLH0A0HYM2": 7.28}, {"DATE": "2002-06-30T00:00:00", "BAMLH0A0HYM2": 8.75}, {"DATE": "2002-07-31T00:00:00", "BAMLH0A0HYM2": 9.71}, {"DATE": "2002-08-31T00:00:00", "BAMLH0A0HYM2": 9.61}, {"DATE": "2002-09-30T00:00:00", "BAMLH0A0HYM2": 10.33}, {"DATE": "2002-10-31T00:00:00", "BAMLH0A0HYM2": 10.59}, {"DATE": "2002-11-30T00:00:00", "BAMLH0A0HYM2": 8.83}, {"DATE": "2002-12-31T00:00:00", "BAMLH0A0HYM2": 8.9}, {"DATE": "2003-01-31T00:00:00", "BAMLH0A0HYM2": 8.29}, {"DATE": "2003-02-28T00:00:00", "BAMLH0A0HYM2": 8.38}, {"DATE": "2003-03-31T00:00:00", "BAMLH0A0HYM2": 7.72}, {"DATE": "2003-04-30T00:00:00", "BAMLH0A0HYM2": 6.44}, {"DATE": "2003-05-31T00:00:00", "BAMLH0A0HYM2": 6.79}, {"DATE": "2003-06-30T00:00:00", "BAMLH0A0HYM2": 6.13}, {"DATE": "2003-07-31T00:00:00", "BAMLH0A0HYM2": 5.67}, {"DATE": "2003-08-31T00:00:00", "BAMLH0A0HYM2": 5.46}, {"DATE": "2003-09-30T00:00:00", "BAMLH0A0HYM2": 5.51}, {"DATE": "2003-10-31T00:00:00", "BAMLH0A0HYM2": 4.73}, {"DATE": "2003-11-30T00:00:00", "BAMLH0A0HYM2": 4.48}, {"DATE": "2003-12-31T00:00:00", "BAMLH0A0HYM2": 4.18}, {"DATE": "2004-01-31T00:00:00", "BAMLH0A0HYM2": 4.05}, {"DATE": "2004-02-29T00:00:00", "BAMLH0A0HYM2": 4.34}, {"DATE": "2004-03-31T00:00:00", "BAMLH0A0HYM2": 4.41}, {"DATE": "2004-04-30T00:00:00", "BAMLH0A0HYM2": 3.91}, {"DATE": "2004-05-31T00:00:00", "BAMLH0A0HYM2": 4.28}, {"DATE": "2004-06-30T00:00:00", "BAMLH0A0HYM2": 4.1}, {"DATE": "2004-07-31T00:00:00", "BAMLH0A0HYM2": 4.02}, {"DATE": "2004-08-31T00:00:00", "BAMLH0A0HYM2": 4.06}, {"DATE": "2004-09-30T00:00:00", "BAMLH0A0HYM2": 3.83}, {"DATE": "2004-10-31T00:00:00", "BAMLH0A0HYM2": 3.63}, {"DATE": "2004-11-30T00:00:00", "BAMLH0A0HYM2": 3.17}, {"DATE": "2004-12-31T00:00:00", "BAMLH0A0HYM2": 3.1}, {"DATE": "2005-01-31T00:00:00", "BAMLH0A0HYM2": 3.29}, {"DATE": "2005-02-28T00:00:00", "BAMLH0A0HYM2": 2.83}, {"DATE": "2005-03-31T00:00:00", "BAMLH0A0HYM2": 3.52}, {"DATE": "2005-04-30T00:00:00", "BAMLH0A0HYM2": 4.19}, {"DATE": "2005-05-31T00:00:00", "BAMLH0A0HYM2": 4.13}, {"DATE": "2005-06-30T00:00:00", "BAMLH0A0HYM2": 3.85}, {"DATE": "2005-07-31T00:00:00", "BAMLH0A0HYM2": 3.3}, {"DATE": "2005-08-31T00:00:00", "BAMLH0A0HYM2": 3.66}, {"DATE": "2005-09-30T00:00:00", "BAMLH0A0HYM2": 3.54}, {"DATE": "2005-10-31T00:00:00", "BAMLH0A0HYM2": 3.61}, {"DATE": "2005-11-30T00:00:00", "BAMLH0A0HYM2": 3.67}, {"DATE": "2005-12-31T00:00:00", "BAMLH0A0HYM2": 3.71}, {"DATE": "2006-01-31T00:00:00", "BAMLH0A0HYM2": 3.42}, {"DATE": "2006-02-28T00:00:00", "BAMLH0A0HYM2": 3.37}, {"DATE": "2006-03-31T00:00:00", "BAMLH0A0HYM2": 3.13}, {"DATE": "2006-04-30T00:00:00", "BAMLH0A0HYM2": 3.04}, {"DATE": "2006-05-31T00:00:00", "BAMLH0A0HYM2": 3.12}, {"DATE": "2006-06-30T00:00:00", "BAMLH0A0HYM2": 3.35}, {"DATE": "2006-07-31T00:00:00", "BAMLH0A0HYM2": 3.45}, {"DATE": "2006-08-31T00:00:00", "BAMLH0A0HYM2": 3.49}, {"DATE": "2006-09-30T00:00:00", "BAMLH0A0HYM2": 3.44}, {"DATE": "2006-10-31T00:00:00", "BAMLH0A0HYM2": 3.29}, {"DATE": "2006-11-30T00:00:00", "BAMLH0A0HYM2": 3.2}, {"DATE": "2006-12-31T00:00:00", "BAMLH0A0HYM2": 2.89}, {"DATE": "2007-01-31T00:00:00", "BAMLH0A0HYM2": 2.72}, {"DATE": "2007-02-28T00:00:00", "BAMLH0A0HYM2": 2.82}, {"DATE": "2007-03-31T00:00:00", "BAMLH0A0HYM2": 2.85}, {"DATE": "2007-04-30T00:00:00", "BAMLH0A0HYM2": 2.74}, {"DATE": "2007-05-31T00:00:00", "BAMLH0A0HYM2": 2.46}, {"DATE": "2007-06-30T00:00:00", "BAMLH0A0HYM2": 2.98}, {"DATE": "2007-07-31T00:00:00", "BAMLH0A0HYM2": 4.19}, {"DATE": "2007-08-31T00:00:00", "BAMLH0A0HYM2": 4.55}, {"DATE": "2007-09-30T00:00:00", "BAMLH0A0HYM2": 4.2}, {"DATE": "2007-10-31T00:00:00", "BAMLH0A0HYM2": 4.36}, {"DATE": "2007-11-30T00:00:00", "BAMLH0A0HYM2": 5.75}, {"DATE": "2007-12-31T00:00:00", "BAMLH0A0HYM2": 5.92}, {"DATE": "2008-01-31T00:00:00", "BAMLH0A0HYM2": 6.95}, {"DATE": "2008-02-29T00:00:00", "BAMLH0A0HYM2": 7.67}, {"DATE": "2008-03-31T00:00:00", "BAMLH0A0HYM2": 8.21}, {"DATE": "2008-04-30T00:00:00", "BAMLH0A0HYM2": 6.86}, {"DATE": "2008-05-31T00:00:00", "BAMLH0A0HYM2": 6.53}, {"DATE": "2008-06-30T00:00:00", "BAMLH0A0HYM2": 7.35}, {"DATE": "2008-07-31T00:00:00", "BAMLH0A0HYM2": 8.0}, {"DATE": "2008-08-31T00:00:00", "BAMLH0A0HYM2": 8.36}, {"DATE": "2008-09-30T00:00:00", "BAMLH0A0HYM2": 10.96}, {"DATE": "2008-10-31T00:00:00", "BAMLH0A0HYM2": 16.17}, {"DATE": "2008-11-30T00:00:00", "BAMLH0A0HYM2": 19.88}, {"DATE": "2008-12-31T00:00:00", "BAMLH0A0HYM2": 18.12}, {"DATE": "2009-01-31T00:00:00", "BAMLH0A0HYM2": 16.26}, {"DATE": "2009-02-28T00:00:00", "BAMLH0A0HYM2": 17.38}, {"DATE": "2009-03-31T00:00:00", "BAMLH0A0HYM2": 17.03}, {"DATE": "2009-04-30T00:00:00", "BAMLH0A0HYM2": 13.45}, {"DATE": "2009-05-31T00:00:00", "BAMLH0A0HYM2": 11.7}, {"DATE": "2009-06-30T00:00:00", "BAMLH0A0HYM2": 10.55}, {"DATE": "2009-07-31T00:00:00", "BAMLH0A0HYM2": 9.22}, {"DATE": "2009-08-31T00:00:00", "BAMLH0A0HYM2": 9.12}, {"DATE": "2009-09-30T00:00:00", "BAMLH0A0HYM2": 7.93}, {"DATE": "2009-10-31T00:00:00", "BAMLH0A0HYM2": 7.6}, {"DATE": "2009-11-30T00:00:00", "BAMLH0A0HYM2": 7.65}, {"DATE": "2009-12-31T00:00:00", "BAMLH0A0HYM2": 6.39}, {"DATE": "2010-01-31T00:00:00", "BAMLH0A0HYM2": 6.54}, {"DATE": "2010-02-28T00:00:00", "BAMLH0A0HYM2": 6.71}, {"DATE": "2010-03-31T00:00:00", "BAMLH0A0HYM2": 5.84}, {"DATE": "2010-04-30T00:00:00", "BAMLH0A0HYM2": 5.61}, {"DATE": "2010-05-31T00:00:00", "BAMLH0A0HYM2": 6.98}, {"DATE": "2010-06-30T00:00:00", "BAMLH0A0HYM2": 7.13}, {"DATE": "2010-07-31T00:00:00", "BAMLH0A0HYM2": 6.59}, {"DATE": "2010-08-31T00:00:00", "BAMLH0A0HYM2": 6.92}, {"DATE": "2010-09-30T00:00:00", "BAMLH0A0HYM2": 6.26}, {"DATE": "2010-10-31T00:00:00", "BAMLH0A0HYM2": 5.93}, {"DATE": "2010-11-30T00:00:00", "BAMLH0A0HYM2": 6.22}, {"DATE": "2010-12-31T00:00:00", "BAMLH0A0HYM2": 5.41}, {"DATE": "2011-01-31T00:00:00", "BAMLH0A0HYM2": 5.08}, {"DATE": "2011-02-28T00:00:00", "BAMLH0A0HYM2": 4.78}, {"DATE": "2011-03-31T00:00:00", "BAMLH0A0HYM2": 4.77}, {"DATE": "2011-04-30T00:00:00", "BAMLH0A0HYM2": 4.76}, {"DATE": "2011-05-31T00:00:00", "BAMLH0A0HYM2": 5.09}, {"DATE": "2011-06-30T00:00:00", "BAMLH0A0HYM2": 5.42}, {"DATE": "2011-07-31T00:00:00", "BAMLH0A0HYM2": 5.58}, {"DATE": "2011-08-31T00:00:00", "BAMLH0A0HYM2": 7.3}, {"DATE": "2011-09-30T00:00:00", "BAMLH0A0HYM2": 8.41}, {"DATE": "2011-10-31T00:00:00", "BAMLH0A0HYM2": 7.07}, {"DATE": "2011-11-30T00:00:00", "BAMLH0A0HYM2": 7.79}, {"DATE": "2011-12-31T00:00:00", "BAMLH0A0HYM2": 7.23}, {"DATE": "2012-01-31T00:00:00", "BAMLH0A0HYM2": 6.61}, {"DATE": "2012-02-29T00:00:00", "BAMLH0A0HYM2": 5.98}, {"DATE": "2012-03-31T00:00:00", "BAMLH0A0HYM2": 5.99}, {"DATE": "2012-04-30T00:00:00", "BAMLH0A0HYM2": 6.04}, {"DATE": "2012-05-31T00:00:00", "BAMLH0A0HYM2": 6.96}, {"DATE": "2012-06-30T00:00:00", "BAMLH0A0HYM2": 6.44}, {"DATE": "2012-07-31T00:00:00", "BAMLH0A0HYM2": 6.16}, {"DATE": "2012-08-31T00:00:00", "BAMLH0A0HYM2": 5.98}, {"DATE": "2012-09-30T00:00:00", "BAMLH0A0HYM2": 5.74}, {"DATE": "2012-10-31T00:00:00", "BAMLH0A0HYM2": 5.63}, {"DATE": "2012-11-30T00:00:00", "BAMLH0A0HYM2": 5.65}, {"DATE": "2012-12-31T00:00:00", "BAMLH0A0HYM2": 5.34}, {"DATE": "2013-01-31T00:00:00", "BAMLH0A0HYM2": 4.95}, {"DATE": "2013-02-28T00:00:00", "BAMLH0A0HYM2": 4.98}, {"DATE": "2013-03-31T00:00:00", "BAMLH0A0HYM2": 4.86}, {"DATE": "2013-04-30T00:00:00", "BAMLH0A0HYM2": 4.55}, {"DATE": "2013-05-31T00:00:00", "BAMLH0A0HYM2": 4.62}, {"DATE": "2013-06-30T00:00:00", "BAMLH0A0HYM2": 5.21}, {"DATE": "2013-07-31T00:00:00", "BAMLH0A0HYM2": 4.71}, {"DATE": "2013-08-29T00:00:00", "BAMLH0A0HYM2": 4.76}, {"DATE": "2013-09-30T00:00:00", "BAMLH0A0HYM2": 4.83}, {"DATE": "2013-10-31T00:00:00", "BAMLH0A0HYM2": 4.36}, {"DATE": "2013-11-30T00:00:00", "BAMLH0A0HYM2": 4.27}, {"DATE": "2013-12-31T00:00:00", "BAMLH0A0HYM2": 4.0}, {"DATE": "2014-01-31T00:00:00", "BAMLH0A0HYM2": 4.21}, {"DATE": "2014-02-28T00:00:00", "BAMLH0A0HYM2": 3.81}, {"DATE": "2014-03-31T00:00:00", "BAMLH0A0HYM2": 3.77}, {"DATE": "2014-04-30T00:00:00", "BAMLH0A0HYM2": 3.71}, {"DATE": "2014-05-31T00:00:00", "BAMLH0A0HYM2": 3.67}, {"DATE": "2014-06-30T00:00:00", "BAMLH0A0HYM2": 3.53}, {"DATE": "2014-07-31T00:00:00", "BAMLH0A0HYM2": 4.04}, {"DATE": "2014-08-31T00:00:00", "BAMLH0A0HYM2": 3.84}, {"DATE": "2014-09-30T00:00:00", "BAMLH0A0HYM2": 4.4}, {"DATE": "2014-10-31T00:00:00", "BAMLH0A0HYM2": 4.3}, {"DATE": "2014-11-30T00:00:00", "BAMLH0A0HYM2": 4.67}, {"DATE": "2014-12-31T00:00:00", "BAMLH0A0HYM2": 5.04}, {"DATE": "2015-01-31T00:00:00", "BAMLH0A0HYM2": 5.26}, {"DATE": "2015-02-28T00:00:00", "BAMLH0A0HYM2": 4.46}, {"DATE": "2015-03-31T00:00:00", "BAMLH0A0HYM2": 4.82}, {"DATE": "2015-04-30T00:00:00", "BAMLH0A0HYM2": 4.59}, {"DATE": "2015-05-31T00:00:00", "BAMLH0A0HYM2": 4.58}, {"DATE": "2015-06-30T00:00:00", "BAMLH0A0HYM2": 5.0}, {"DATE": "2015-07-31T00:00:00", "BAMLH0A0HYM2": 5.36}, {"DATE": "2015-08-31T00:00:00", "BAMLH0A0HYM2": 5.7}, {"DATE": "2015-09-30T00:00:00", "BAMLH0A0HYM2": 6.62}, {"DATE": "2015-10-31T00:00:00", "BAMLH0A0HYM2": 5.9}, {"DATE": "2015-11-30T00:00:00", "BAMLH0A0HYM2": 6.4}, {"DATE": "2015-12-31T00:00:00", "BAMLH0A0HYM2": 6.95}, {"DATE": "2016-01-31T00:00:00", "BAMLH0A0HYM2": 7.77}, {"DATE": "2016-02-29T00:00:00", "BAMLH0A0HYM2": 7.75}, {"DATE": "2016-03-31T00:00:00", "BAMLH0A0HYM2": 7.05}, {"DATE": "2016-04-30T00:00:00", "BAMLH0A0HYM2": 6.21}, {"DATE": "2016-05-31T00:00:00", "BAMLH0A0HYM2": 5.97}, {"DATE": "2016-06-30T00:00:00", "BAMLH0A0HYM2": 6.21}, {"DATE": "2016-07-31T00:00:00", "BAMLH0A0HYM2": 5.69}, {"DATE": "2016-08-31T00:00:00", "BAMLH0A0HYM2": 5.1}, {"DATE": "2016-09-30T00:00:00", "BAMLH0A0HYM2": 4.97}, {"DATE": "2016-10-31T00:00:00", "BAMLH0A0HYM2": 4.91}, {"DATE": "2016-11-30T00:00:00", "BAMLH0A0HYM2": 4.67}, {"DATE": "2016-12-31T00:00:00", "BAMLH0A0HYM2": 4.22}, {"DATE": "2017-01-31T00:00:00", "BAMLH0A0HYM2": 4.0}, {"DATE": "2017-02-28T00:00:00", "BAMLH0A0HYM2": 3.74}, {"DATE": "2017-03-31T00:00:00", "BAMLH0A0HYM2": 3.92}, {"DATE": "2017-04-30T00:00:00", "BAMLH0A0HYM2": 3.81}, {"DATE": "2017-05-31T00:00:00", "BAMLH0A0HYM2": 3.74}, {"DATE": "2017-06-30T00:00:00", "BAMLH0A0HYM2": 3.77}, {"DATE": "2017-07-31T00:00:00", "BAMLH0A0HYM2": 3.61}, {"DATE": "2017-08-31T00:00:00", "BAMLH0A0HYM2": 3.85}, {"DATE": "2017-09-30T00:00:00", "BAMLH0A0HYM2": 3.56}, {"DATE": "2017-10-31T00:00:00", "BAMLH0A0HYM2": 3.51}, {"DATE": "2017-11-30T00:00:00", "BAMLH0A0HYM2": 3.61}, {"DATE": "2017-12-31T00:00:00", "BAMLH0A0HYM2": 3.63}, {"DATE": "2018-01-31T00:00:00", "BAMLH0A0HYM2": 3.29}, {"DATE": "2018-02-28T00:00:00", "BAMLH0A0HYM2": 3.47}, {"DATE": "2018-03-31T00:00:00", "BAMLH0A0HYM2": 3.72}, {"DATE": "2018-04-30T00:00:00", "BAMLH0A0HYM2": 3.46}, {"DATE": "2018-05-31T00:00:00", "BAMLH0A0HYM2": 3.63}, {"DATE": "2018-06-30T00:00:00", "BAMLH0A0HYM2": 3.71}, {"DATE": "2018-07-31T00:00:00", "BAMLH0A0HYM2": 3.46}, {"DATE": "2018-08-31T00:00:00", "BAMLH0A0HYM2": 3.49}, {"DATE": "2018-09-30T00:00:00", "BAMLH0A0HYM2": 3.28}, {"DATE": "2018-10-31T00:00:00", "BAMLH0A0HYM2": 3.81}, {"DATE": "2018-11-30T00:00:00", "BAMLH0A0HYM2": 4.29}, {"DATE": "2018-12-31T00:00:00", "BAMLH0A0HYM2": 5.33}, {"DATE": "2019-01-31T00:00:00", "BAMLH0A0HYM2": 4.37}, {"DATE": "2019-02-28T00:00:00", "BAMLH0A0HYM2": 3.92}, {"DATE": "2019-03-31T00:00:00", "BAMLH0A0HYM2": 4.05}, {"DATE": "2019-04-30T00:00:00", "BAMLH0A0HYM2": 3.73}, {"DATE": "2019-05-31T00:00:00", "BAMLH0A0HYM2": 4.59}, {"DATE": "2019-06-30T00:00:00", "BAMLH0A0HYM2": 4.07}, {"DATE": "2019-07-31T00:00:00", "BAMLH0A0HYM2": 3.93}, {"DATE": "2019-08-31T00:00:00", "BAMLH0A0HYM2": 4.13}, {"DATE": "2019-09-30T00:00:00", "BAMLH0A0HYM2": 4.02}, {"DATE": "2019-10-31T00:00:00", "BAMLH0A0HYM2": 4.15}, {"DATE": "2019-11-30T00:00:00", "BAMLH0A0HYM2": 4.02}, {"DATE": "2019-12-31T00:00:00", "BAMLH0A0HYM2": 3.6}, {"DATE": "2020-01-31T00:00:00", "BAMLH0A0HYM2": 4.03}, {"DATE": "2020-02-29T00:00:00", "BAMLH0A0HYM2": 5.06}, {"DATE": "2020-03-31T00:00:00", "BAMLH0A0HYM2": 8.77}, {"DATE": "2020-04-30T00:00:00", "BAMLH0A0HYM2": 7.63}, {"DATE": "2020-05-31T00:00:00", "BAMLH0A0HYM2": 6.54}, {"DATE": "2020-06-30T00:00:00", "BAMLH0A0HYM2": 6.44}, {"DATE": "2020-07-31T00:00:00", "BAMLH0A0HYM2": 5.16}, {"DATE": "2020-08-31T00:00:00", "BAMLH0A0HYM2": 5.02}, {"DATE": "2020-09-30T00:00:00", "BAMLH0A0HYM2": 5.41}, {"DATE": "2020-10-31T00:00:00", "BAMLH0A0HYM2": 5.32}, {"DATE": "2020-11-30T00:00:00", "BAMLH0A0HYM2": 4.33}, {"DATE": "2020-12-31T00:00:00", "BAMLH0A0HYM2": 3.86}], "data-2108533d577388f9f0eb49c2d14449d0": [{"DATE": "2000-01-31T00:00:00", "DRTSCIS": 9.4}, {"DATE": "2000-04-30T00:00:00", "DRTSCIS": 21.4}, {"DATE": "2000-07-31T00:00:00", "DRTSCIS": 23.6}, {"DATE": "2000-10-31T00:00:00", "DRTSCIS": 27.3}, {"DATE": "2001-01-31T00:00:00", "DRTSCIS": 45.5}, {"DATE": "2001-04-30T00:00:00", "DRTSCIS": 36.4}, {"DATE": "2001-07-31T00:00:00", "DRTSCIS": 31.6}, {"DATE": "2001-10-31T00:00:00", "DRTSCIS": 40.4}, {"DATE": "2002-01-31T00:00:00", "DRTSCIS": 41.8}, {"DATE": "2002-04-30T00:00:00", "DRTSCIS": 14.5}, {"DATE": "2002-07-31T00:00:00", "DRTSCIS": 5.5}, {"DATE": "2002-10-31T00:00:00", "DRTSCIS": 18.2}, {"DATE": "2003-01-31T00:00:00", "DRTSCIS": 13.8}, {"DATE": "2003-04-30T00:00:00", "DRTSCIS": 12.7}, {"DATE": "2003-07-31T00:00:00", "DRTSCIS": 3.5}, {"DATE": "2003-10-31T00:00:00", "DRTSCIS": -1.8}, {"DATE": "2004-01-31T00:00:00", "DRTSCIS": -10.9}, {"DATE": "2004-04-30T00:00:00", "DRTSCIS": -19.3}, {"DATE": "2004-07-31T00:00:00", "DRTSCIS": -3.6}, {"DATE": "2004-10-31T00:00:00", "DRTSCIS": -18.2}, {"DATE": "2005-01-31T00:00:00", "DRTSCIS": -13.0}, {"DATE": "2005-04-30T00:00:00", "DRTSCIS": -24.1}, {"DATE": "2005-07-31T00:00:00", "DRTSCIS": -11.1}, {"DATE": "2005-10-31T00:00:00", "DRTSCIS": -5.3}, {"DATE": "2006-01-31T00:00:00", "DRTSCIS": -7.1}, {"DATE": "2006-04-30T00:00:00", "DRTSCIS": -7.0}, {"DATE": "2006-07-31T00:00:00", "DRTSCIS": -1.8}, {"DATE": "2006-10-31T00:00:00", "DRTSCIS": -1.9}, {"DATE": "2007-01-31T00:00:00", "DRTSCIS": 5.4}, {"DATE": "2007-04-30T00:00:00", "DRTSCIS": 1.9}, {"DATE": "2007-07-31T00:00:00", "DRTSCIS": 7.7}, {"DATE": "2007-10-31T00:00:00", "DRTSCIS": 9.6}, {"DATE": "2008-01-31T00:00:00", "DRTSCIS": 30.4}, {"DATE": "2008-04-30T00:00:00", "DRTSCIS": 51.8}, {"DATE": "2008-07-31T00:00:00", "DRTSCIS": 65.4}, {"DATE": "2008-10-31T00:00:00", "DRTSCIS": 74.5}, {"DATE": "2009-01-31T00:00:00", "DRTSCIS": 69.2}, {"DATE": "2009-04-30T00:00:00", "DRTSCIS": 42.3}, {"DATE": "2009-07-31T00:00:00", "DRTSCIS": 34.0}, {"DATE": "2009-10-31T00:00:00", "DRTSCIS": 16.1}, {"DATE": "2010-01-31T00:00:00", "DRTSCIS": 3.7}, {"DATE": "2010-04-30T00:00:00", "DRTSCIS": 0.0}, {"DATE": "2010-07-31T00:00:00", "DRTSCIS": -9.1}, {"DATE": "2010-10-31T00:00:00", "DRTSCIS": -7.1}, {"DATE": "2011-01-31T00:00:00", "DRTSCIS": -1.9}, {"DATE": "2011-04-30T00:00:00", "DRTSCIS": -13.5}, {"DATE": "2011-07-31T00:00:00", "DRTSCIS": -7.8}, {"DATE": "2011-10-31T00:00:00", "DRTSCIS": -6.3}, {"DATE": "2012-01-31T00:00:00", "DRTSCIS": 1.9}, {"DATE": "2012-04-30T00:00:00", "DRTSCIS": -1.8}, {"DATE": "2012-07-31T00:00:00", "DRTSCIS": -4.9}, {"DATE": "2012-10-31T00:00:00", "DRTSCIS": -7.6}, {"DATE": "2013-01-31T00:00:00", "DRTSCIS": -7.7}, {"DATE": "2013-04-30T00:00:00", "DRTSCIS": -23.1}, {"DATE": "2013-07-31T00:00:00", "DRTSCIS": -10.0}, {"DATE": "2013-10-31T00:00:00", "DRTSCIS": -7.1}, {"DATE": "2014-01-31T00:00:00", "DRTSCIS": -4.2}, {"DATE": "2014-04-30T00:00:00", "DRTSCIS": -7.0}, {"DATE": "2014-07-31T00:00:00", "DRTSCIS": -8.3}, {"DATE": "2014-10-31T00:00:00", "DRTSCIS": -8.2}, {"DATE": "2015-01-31T00:00:00", "DRTSCIS": -5.7}, {"DATE": "2015-04-30T00:00:00", "DRTSCIS": -1.4}, {"DATE": "2015-07-31T00:00:00", "DRTSCIS": -6.0}, {"DATE": "2015-10-31T00:00:00", "DRTSCIS": 1.5}, {"DATE": "2016-01-31T00:00:00", "DRTSCIS": 4.2}, {"DATE": "2016-04-30T00:00:00", "DRTSCIS": 5.8}, {"DATE": "2016-07-31T00:00:00", "DRTSCIS": 7.1}, {"DATE": "2016-10-31T00:00:00", "DRTSCIS": -1.5}, {"DATE": "2017-01-31T00:00:00", "DRTSCIS": 0.0}, {"DATE": "2017-04-30T00:00:00", "DRTSCIS": -2.9}, {"DATE": "2017-07-31T00:00:00", "DRTSCIS": -4.1}, {"DATE": "2017-10-31T00:00:00", "DRTSCIS": -8.8}, {"DATE": "2018-01-31T00:00:00", "DRTSCIS": 0.0}, {"DATE": "2018-04-30T00:00:00", "DRTSCIS": -3.0}, {"DATE": "2018-07-31T00:00:00", "DRTSCIS": -7.6}, {"DATE": "2018-10-31T00:00:00", "DRTSCIS": -3.1}, {"DATE": "2019-01-31T00:00:00", "DRTSCIS": 4.3}, {"DATE": "2019-04-30T00:00:00", "DRTSCIS": 0.0}, {"DATE": "2019-07-31T00:00:00", "DRTSCIS": -5.8}, {"DATE": "2019-10-31T00:00:00", "DRTSCIS": 5.6}, {"DATE": "2020-01-31T00:00:00", "DRTSCIS": -1.4}, {"DATE": "2020-04-30T00:00:00", "DRTSCIS": 39.7}, {"DATE": "2020-07-31T00:00:00", "DRTSCIS": 70.0}, {"DATE": "2020-10-31T00:00:00", "DRTSCIS": 31.3}], "data-4c6f780913a45f81a467345005541598": [{"value": 0}]}}, {"mode": "vega-lite"});
</script>



### 📤 Data export

The task is almost finished, but we have used `pandas` _dataframes_ as inputs for `Altair`. We now convert these to _.csv_, as per the task's requirement. First, save the _dataframes_ to _.csv_: 💾


```python
df1.to_csv('df1.csv')
df2.to_csv('df2.csv')
```

Next, upload to [GitHub](https://github.com/csaladenes/eco) ... then return here. We then set up for local loading and viewing.


```python
import json
import altair_viewer
import os
cwd = os.getcwd()
```


```python
%%capture c
!jupyter-notebook list
```


```python
local_path='http'+c.stdout.split('http')[1].split('?token')[0]+'tree'+(cwd.replace('\\','/')+'/')[2:]
github_url='https://raw.githubusercontent.com/csaladenes/eco/main/'
```

Since we have already the set up the plotter in a way that it can accept a _dataframe_ directly as an input, but also a _.csv_ or a _.json_ file, we can call it again, but this time with the _.csv_ file arguments.  
### 🤩 The finished product


```python
# plotter(local_path+'df1.csv',local_path+'df2.csv',dr)
p=plotter(github_url+'df1.csv',github_url+'df2.csv',dr)
p
```





<div id="altair-viz-91946c8f5c4d4f2b9f3cef9abed4624f"></div>
<script type="text/javascript">
  (function(spec, embedOpt){
    let outputDiv = document.currentScript.previousElementSibling;
    if (outputDiv.id !== "altair-viz-91946c8f5c4d4f2b9f3cef9abed4624f") {
      outputDiv = document.getElementById("altair-viz-91946c8f5c4d4f2b9f3cef9abed4624f");
    }
    const paths = {
      "vega": "https://cdn.jsdelivr.net/npm//vega@5?noext",
      "vega-lib": "https://cdn.jsdelivr.net/npm//vega-lib?noext",
      "vega-lite": "https://cdn.jsdelivr.net/npm//vega-lite@4.8.1?noext",
      "vega-embed": "https://cdn.jsdelivr.net/npm//vega-embed@6?noext",
    };

    function loadScript(lib) {
      return new Promise(function(resolve, reject) {
        var s = document.createElement('script');
        s.src = paths[lib];
        s.async = true;
        s.onload = () => resolve(paths[lib]);
        s.onerror = () => reject(`Error loading script: ${paths[lib]}`);
        document.getElementsByTagName("head")[0].appendChild(s);
      });
    }

    function showError(err) {
      outputDiv.innerHTML = `<div class="error" style="color:red;">${err}</div>`;
      throw err;
    }

    function displayChart(vegaEmbed) {
      vegaEmbed(outputDiv, spec, embedOpt)
        .catch(err => showError(`Javascript Error: ${err.message}<br>This usually means there's a typo in your chart specification. See the javascript console for the full traceback.`));
    }

    if(typeof define === "function" && define.amd) {
      requirejs.config({paths});
      require(["vega-embed"], displayChart, err => showError(`Error loading script: ${err.message}`));
    } else if (typeof vegaEmbed === "function") {
      displayChart(vegaEmbed);
    } else {
      loadScript("vega")
        .then(() => loadScript("vega-lite"))
        .then(() => loadScript("vega-embed"))
        .catch(showError)
        .then(() => displayChart(vegaEmbed));
    }
  })({"config": {"view": {"continuousWidth": 700, "continuousHeight": 250}}, "layer": [{"data": {"name": "data-2b08226b30bbb08a20f45bc01ddaafde"}, "mark": {"type": "rect", "blend": "darken"}, "encoding": {"color": {"type": "nominal", "field": "color", "scale": null}, "x": {"type": "temporal", "field": "start"}, "x2": {"field": "end"}}}, {"layer": [{"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df2.csv"}, "mark": {"type": "line", "color": "#557CAA", "line": true}, "encoding": {"x": {"type": "temporal", "axis": {"grid": false, "tickCount": 10}, "field": "DATE", "title": null}, "y": {"type": "quantitative", "axis": {"format": ".1f", "grid": true, "tickCount": 9, "titleFontWeight": "normal", "values": [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]}, "field": "BAMLH0A0HYM2", "scale": {"domain": [0, 20]}, "title": "Percent"}}}, {"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df1.csv"}, "mark": {"type": "line", "color": "#A53F3D", "line": true}, "encoding": {"x": {"type": "temporal", "field": "DATE"}, "y": {"type": "quantitative", "axis": {"format": ".0f", "tickCount": 9, "titleFontWeight": "normal", "values": [-30, -15, 0, 15, 30, 45, 60, 75, 90]}, "field": "DRTSCIS", "scale": {"domain": [-30, 90]}, "title": "Percent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "resolve": {"scale": {"y": "independent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "$schema": "https://vega.github.io/schema/vega-lite/v4.8.1.json", "datasets": {"data-2b08226b30bbb08a20f45bc01ddaafde": [{"start": "2001-03-31", "end": "2001-11-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2007-12-31", "end": "2009-06-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2020-02-29", "end": "2021-04-01", "event": "covid", "color": "#F3F4D8"}], "data-4c6f780913a45f81a467345005541598": [{"value": 0}]}}, {"mode": "vega-lite"});
</script>



🔧 Here is the `Vega-Lite` config:


```python
p.save('config.json')
config=json.loads(open('config.json','r').read())
config
```




    {'config': {'view': {'continuousWidth': 700, 'continuousHeight': 250}},
     'layer': [{'data': {'name': 'data-2b08226b30bbb08a20f45bc01ddaafde'},
       'mark': {'type': 'rect', 'blend': 'darken'},
       'encoding': {'color': {'type': 'nominal', 'field': 'color', 'scale': None},
        'x': {'type': 'temporal', 'field': 'start'},
        'x2': {'field': 'end'}}},
      {'layer': [{'data': {'url': 'https://raw.githubusercontent.com/csaladenes/eco/main/df2.csv'},
         'mark': {'type': 'line', 'color': '#557CAA', 'line': True},
         'encoding': {'x': {'type': 'temporal',
           'axis': {'grid': False, 'tickCount': 10},
           'field': 'DATE',
           'title': None},
          'y': {'type': 'quantitative',
           'axis': {'format': '.1f',
            'grid': True,
            'tickCount': 9,
            'titleFontWeight': 'normal',
            'values': [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]},
           'field': 'BAMLH0A0HYM2',
           'scale': {'domain': [0, 20]},
           'title': 'Percent'}}},
        {'data': {'url': 'https://raw.githubusercontent.com/csaladenes/eco/main/df1.csv'},
         'mark': {'type': 'line', 'color': '#A53F3D', 'line': True},
         'encoding': {'x': {'type': 'temporal', 'field': 'DATE'},
          'y': {'type': 'quantitative',
           'axis': {'format': '.0f',
            'tickCount': 9,
            'titleFontWeight': 'normal',
            'values': [-30, -15, 0, 15, 30, 45, 60, 75, 90]},
           'field': 'DRTSCIS',
           'scale': {'domain': [-30, 90]},
           'title': 'Percent'}}},
        {'data': {'name': 'data-4c6f780913a45f81a467345005541598'},
         'mark': {'type': 'rule', 'size': 3},
         'encoding': {'y': {'type': 'quantitative',
           'axis': {'grid': False, 'values': []},
           'field': 'value',
           'scale': {'domain': [0, 20]},
           'title': None}}}],
       'resolve': {'scale': {'y': 'independent'}}},
      {'data': {'name': 'data-4c6f780913a45f81a467345005541598'},
       'mark': {'type': 'rule', 'size': 3},
       'encoding': {'y': {'type': 'quantitative',
         'axis': {'grid': False, 'values': []},
         'field': 'value',
         'scale': {'domain': [0, 20]},
         'title': None}}}],
     '$schema': 'https://vega.github.io/schema/vega-lite/v4.8.1.json',
     'datasets': {'data-2b08226b30bbb08a20f45bc01ddaafde': [{'start': '2001-03-31',
        'end': '2001-11-30',
        'event': 'recession',
        'color': '#E2E2E2'},
       {'start': '2007-12-31',
        'end': '2009-06-30',
        'event': 'recession',
        'color': '#E2E2E2'},
       {'start': '2020-02-29',
        'end': '2021-04-01',
        'event': 'covid',
        'color': '#F3F4D8'}],
      'data-4c6f780913a45f81a467345005541598': [{'value': 0}]}}



We can indeed load the visualisation back from the config file:


```python
altair_viewer.display(config, inline=True)
```



<div id="altair-chart-e53f17e0a03749b9bc4038204e5ef238"></div>
<script type="text/javascript">
  (function(spec, embedOpt) {
    const outputDiv = document.getElementById("altair-chart-e53f17e0a03749b9bc4038204e5ef238");
    const urls = {
      "vega": "http://localhost:18007/scripts/vega.js",
      "vega-lite": "http://localhost:18007/scripts/vega-lite.js",
      "vega-embed": "http://localhost:18007/scripts/vega-embed.js",
    };
    function loadScript(lib) {
      return new Promise(function(resolve, reject) {
        var s = document.createElement('script');
        s.src = urls[lib];
        s.async = true;
        s.onload = () => resolve(urls[lib]);
        s.onerror = () => reject(`Error loading script: ${urls[lib]}`);
        document.getElementsByTagName("head")[0].appendChild(s);
      });
    }
    function showError(err) {
      outputDiv.innerHTML = `<div class="error" style="color:red;">${err}</div>`;
      throw err;
    }
    function displayChart(vegaEmbed) {
      vegaEmbed(outputDiv, spec, embedOpt)
        .catch(err => showError(`Javascript Error: ${err.message}<br>This usually means there's a typo in your chart specification. See the javascript console for the full traceback.`));
    }

    if(typeof define === "function" && define.amd) {
        // requirejs paths need '.js' extension stripped.
        const paths = Object.keys(urls).reduce(function(paths, package) {
            paths[package] = urls[package].replace(/\.js$/, "");
            return paths
        }, {})
        requirejs.config({paths});
        require(["vega-embed"], displayChart, err => showError(`Error loading script: ${err.message}`));
    } else if (typeof vegaEmbed === "function") {
        displayChart(vegaEmbed);
    } else {
        loadScript("vega")
            .then(() => loadScript("vega-lite"))
            .then(() => loadScript("vega-embed"))
            .catch(showError)
            .then(() => displayChart(vegaEmbed));
    }
  })({"config": {"view": {"continuousWidth": 700, "continuousHeight": 250}}, "layer": [{"data": {"name": "data-2b08226b30bbb08a20f45bc01ddaafde"}, "mark": {"type": "rect", "blend": "darken"}, "encoding": {"color": {"type": "nominal", "field": "color", "scale": null}, "x": {"type": "temporal", "field": "start"}, "x2": {"field": "end"}}}, {"layer": [{"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df2.csv"}, "mark": {"type": "line", "color": "#557CAA", "line": true}, "encoding": {"x": {"type": "temporal", "axis": {"grid": false, "tickCount": 10}, "field": "DATE", "title": null}, "y": {"type": "quantitative", "axis": {"format": ".1f", "grid": true, "tickCount": 9, "titleFontWeight": "normal", "values": [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]}, "field": "BAMLH0A0HYM2", "scale": {"domain": [0, 20]}, "title": "Percent"}}}, {"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df1.csv"}, "mark": {"type": "line", "color": "#A53F3D", "line": true}, "encoding": {"x": {"type": "temporal", "field": "DATE"}, "y": {"type": "quantitative", "axis": {"format": ".0f", "tickCount": 9, "titleFontWeight": "normal", "values": [-30, -15, 0, 15, 30, 45, 60, 75, 90]}, "field": "DRTSCIS", "scale": {"domain": [-30, 90]}, "title": "Percent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "resolve": {"scale": {"y": "independent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "$schema": "https://vega.github.io/schema/vega-lite/v4.8.1.json", "datasets": {"data-2b08226b30bbb08a20f45bc01ddaafde": [{"start": "2001-03-31", "end": "2001-11-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2007-12-31", "end": "2009-06-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2020-02-29", "end": "2021-04-01", "event": "covid", "color": "#F3F4D8"}], "data-4c6f780913a45f81a467345005541598": [{"value": 0}]}}, {});
</script>



Static 🖼 image embed


```python
# p.save('static.png')
```


```python
%%html
<img src='static.png'>
```


<img src='static.png'>



### 💇‍♂️ Styling

The second part of the task asks for adjusting the style to match the exisitng ECO site style and sizes. IN constructing this part of the answer I have tried to track down a few recent entries that use _Vega-Lite_ visualisations as guide, such as:
* [How should we assess school students now that exams have been cancelled?](https://www.economicsobservatory.com/question/how-should-we-assess-school-students-now-exams-have-been-cancelled)
* [#economicsfest: Does economics need to be ‘decolonised’?](https://www.economicsobservatory.com/economicsfest-does-economics-need-to-be-decolonised)
* [Why are supermarket shelves in Northern Ireland empty?](https://www.economicsobservatory.com/why-are-supermarket-shelves-in-northern-ireland-empty)
* [Zoomshock: how is working from home affecting cities and suburbs?](https://www.economicsobservatory.com/zoomshock-how-is-working-from-home-affecting-cities-and-suburbs)
* [Has devolution led to different outcomes during the Covid-19 crisis?](https://www.economicsobservatory.com/has-devolution-led-to-different-outcomes-during-the-covid-19-crisis)
* [What are the implications of Covid-19 for wealth inequality?](https://www.economicsobservatory.com/what-are-the-implications-of-covid-19-for-wealth-inequality)
* [Update: How is the response to coronavirus affecting gender equality?](https://www.economicsobservatory.com/update-how-is-the-response-to-coronavirus-affecting-gender-equality)

After a review of these entries we have decided on the following:
* Chart `width` should be `610px`
* Chart `height` should be `420px`
* Charts typically have _tooltips_
* There is no universal color scheme, but since we only have two data series in this case, we will use the logo identity colors: `#E64754` and `#243A59` 

So, in the light of this, we redefine the plotter function: 👇


```python
def plotter(df1,df2,dr):
    l1=alt.Chart(df1)\
        .mark_line(
        line=True,
        color='#E64754'
        ).encode(
        x='DATE:T',
        y=alt.Y(indicator1+':Q', 
                title='Percent', 
                scale=alt.Scale(domain=(-30, 90)),
                axis=alt.Axis(
                    format= ".0f",
                    tickCount=9,
                    titleFontWeight='normal',
                    values=[15*i for i in range(-2,7)]
                )
               ),
        tooltip=[alt.Tooltip('DATE:T', title='Date'),
                 alt.Tooltip(indicator1+':Q', title=pretty_indicator[indicator1], format='.1f')]
    )
    l2=alt.Chart(df2)\
        .mark_line(
        line=True,
        color='#243A59'
        ).encode(
        x=alt.X('DATE:T', 
                title=None,
                axis=alt.Axis(
                    grid=False,
                    tickCount=10
                )
               ),
        y=alt.Y(indicator2+':Q', 
                title='Percent', 
                scale=alt.Scale(domain=[0, 20]),
                axis=alt.Axis(
                    format= ".1f",
                    grid=True,
                    tickCount=9,
                    titleFontWeight='normal',
                    values=[2.5*i for i in range(9)]
                )
               ),
        tooltip=[alt.Tooltip('DATE:T', title='Date'),
                 alt.Tooltip(indicator2+':Q', title=pretty_indicator[indicator2], format='.2f')]
    )
    rect = alt.Chart(dr).mark_rect(
        blend='darken'
    ).encode(
        x='start:T',
        x2='end:T',
        color=alt.Color('color:N',scale=None),
#     ).properties(
#         width=700,
#         height=250
    )
    l = alt.Chart(pd.DataFrame([{'value':0}])).mark_rule(size=3).encode(
        y=alt.Y('value:Q', 
                title=None, 
                scale=alt.Scale(domain=[0, 20]),
                axis=alt.Axis(
                    values=[],
                    grid=False
                )
               ),
    )
    return ((rect)+((l2+l1+l).resolve_scale(y='independent'))+l).configure_view(
        continuousHeight=420,
        continuousWidth=610,
    )
p=plotter(github_url+'df1.csv',github_url+'df2.csv',dr)
p
```





<div id="altair-viz-4479eb85adcf4e4bbc3ebc0d22e7c04e"></div>
<script type="text/javascript">
  (function(spec, embedOpt){
    let outputDiv = document.currentScript.previousElementSibling;
    if (outputDiv.id !== "altair-viz-4479eb85adcf4e4bbc3ebc0d22e7c04e") {
      outputDiv = document.getElementById("altair-viz-4479eb85adcf4e4bbc3ebc0d22e7c04e");
    }
    const paths = {
      "vega": "https://cdn.jsdelivr.net/npm//vega@5?noext",
      "vega-lib": "https://cdn.jsdelivr.net/npm//vega-lib?noext",
      "vega-lite": "https://cdn.jsdelivr.net/npm//vega-lite@4.8.1?noext",
      "vega-embed": "https://cdn.jsdelivr.net/npm//vega-embed@6?noext",
    };

    function loadScript(lib) {
      return new Promise(function(resolve, reject) {
        var s = document.createElement('script');
        s.src = paths[lib];
        s.async = true;
        s.onload = () => resolve(paths[lib]);
        s.onerror = () => reject(`Error loading script: ${paths[lib]}`);
        document.getElementsByTagName("head")[0].appendChild(s);
      });
    }

    function showError(err) {
      outputDiv.innerHTML = `<div class="error" style="color:red;">${err}</div>`;
      throw err;
    }

    function displayChart(vegaEmbed) {
      vegaEmbed(outputDiv, spec, embedOpt)
        .catch(err => showError(`Javascript Error: ${err.message}<br>This usually means there's a typo in your chart specification. See the javascript console for the full traceback.`));
    }

    if(typeof define === "function" && define.amd) {
      requirejs.config({paths});
      require(["vega-embed"], displayChart, err => showError(`Error loading script: ${err.message}`));
    } else if (typeof vegaEmbed === "function") {
      displayChart(vegaEmbed);
    } else {
      loadScript("vega")
        .then(() => loadScript("vega-lite"))
        .then(() => loadScript("vega-embed"))
        .catch(showError)
        .then(() => displayChart(vegaEmbed));
    }
  })({"config": {"view": {"continuousWidth": 610, "continuousHeight": 420}}, "layer": [{"data": {"name": "data-2b08226b30bbb08a20f45bc01ddaafde"}, "mark": {"type": "rect", "blend": "darken"}, "encoding": {"color": {"type": "nominal", "field": "color", "scale": null}, "x": {"type": "temporal", "field": "start"}, "x2": {"field": "end"}}}, {"layer": [{"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df2.csv"}, "mark": {"type": "line", "color": "#243A59", "line": true}, "encoding": {"tooltip": [{"type": "temporal", "field": "DATE", "title": "Date"}, {"type": "quantitative", "field": "BAMLH0A0HYM2", "format": ".2f", "title": "ICE BofA US High Yield Index Option-Adjusted Spread"}], "x": {"type": "temporal", "axis": {"grid": false, "tickCount": 10}, "field": "DATE", "title": null}, "y": {"type": "quantitative", "axis": {"format": ".1f", "grid": true, "tickCount": 9, "titleFontWeight": "normal", "values": [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]}, "field": "BAMLH0A0HYM2", "scale": {"domain": [0, 20]}, "title": "Percent"}}}, {"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df1.csv"}, "mark": {"type": "line", "color": "#E64754", "line": true}, "encoding": {"tooltip": [{"type": "temporal", "field": "DATE", "title": "Date"}, {"type": "quantitative", "field": "DRTSCIS", "format": ".1f", "title": "Net Percentage of Domestic Banks Tightening Standards for Commercial and Industrial Loans to Small Firms"}], "x": {"type": "temporal", "field": "DATE"}, "y": {"type": "quantitative", "axis": {"format": ".0f", "tickCount": 9, "titleFontWeight": "normal", "values": [-30, -15, 0, 15, 30, 45, 60, 75, 90]}, "field": "DRTSCIS", "scale": {"domain": [-30, 90]}, "title": "Percent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "resolve": {"scale": {"y": "independent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "$schema": "https://vega.github.io/schema/vega-lite/v4.8.1.json", "datasets": {"data-2b08226b30bbb08a20f45bc01ddaafde": [{"start": "2001-03-31", "end": "2001-11-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2007-12-31", "end": "2009-06-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2020-02-29", "end": "2021-04-01", "event": "covid", "color": "#F3F4D8"}], "data-4c6f780913a45f81a467345005541598": [{"value": 0}]}}, {"mode": "vega-lite"});
</script>



🔧 Here is the **final** `Vega-Lite` config:


```python
p.save('chart1.json')
chart1=json.loads(open('chart1.json','r').read())
chart1
```




    {'config': {'view': {'continuousWidth': 610, 'continuousHeight': 420}},
     'layer': [{'data': {'name': 'data-2b08226b30bbb08a20f45bc01ddaafde'},
       'mark': {'type': 'rect', 'blend': 'darken'},
       'encoding': {'color': {'type': 'nominal', 'field': 'color', 'scale': None},
        'x': {'type': 'temporal', 'field': 'start'},
        'x2': {'field': 'end'}}},
      {'layer': [{'data': {'url': 'https://raw.githubusercontent.com/csaladenes/eco/main/df2.csv'},
         'mark': {'type': 'line', 'color': '#243A59', 'line': True},
         'encoding': {'tooltip': [{'type': 'temporal',
            'field': 'DATE',
            'title': 'Date'},
           {'type': 'quantitative',
            'field': 'BAMLH0A0HYM2',
            'format': '.2f',
            'title': 'ICE BofA US High Yield Index Option-Adjusted Spread'}],
          'x': {'type': 'temporal',
           'axis': {'grid': False, 'tickCount': 10},
           'field': 'DATE',
           'title': None},
          'y': {'type': 'quantitative',
           'axis': {'format': '.1f',
            'grid': True,
            'tickCount': 9,
            'titleFontWeight': 'normal',
            'values': [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]},
           'field': 'BAMLH0A0HYM2',
           'scale': {'domain': [0, 20]},
           'title': 'Percent'}}},
        {'data': {'url': 'https://raw.githubusercontent.com/csaladenes/eco/main/df1.csv'},
         'mark': {'type': 'line', 'color': '#E64754', 'line': True},
         'encoding': {'tooltip': [{'type': 'temporal',
            'field': 'DATE',
            'title': 'Date'},
           {'type': 'quantitative',
            'field': 'DRTSCIS',
            'format': '.1f',
            'title': 'Net Percentage of Domestic Banks Tightening Standards for Commercial and Industrial Loans to Small Firms'}],
          'x': {'type': 'temporal', 'field': 'DATE'},
          'y': {'type': 'quantitative',
           'axis': {'format': '.0f',
            'tickCount': 9,
            'titleFontWeight': 'normal',
            'values': [-30, -15, 0, 15, 30, 45, 60, 75, 90]},
           'field': 'DRTSCIS',
           'scale': {'domain': [-30, 90]},
           'title': 'Percent'}}},
        {'data': {'name': 'data-4c6f780913a45f81a467345005541598'},
         'mark': {'type': 'rule', 'size': 3},
         'encoding': {'y': {'type': 'quantitative',
           'axis': {'grid': False, 'values': []},
           'field': 'value',
           'scale': {'domain': [0, 20]},
           'title': None}}}],
       'resolve': {'scale': {'y': 'independent'}}},
      {'data': {'name': 'data-4c6f780913a45f81a467345005541598'},
       'mark': {'type': 'rule', 'size': 3},
       'encoding': {'y': {'type': 'quantitative',
         'axis': {'grid': False, 'values': []},
         'field': 'value',
         'scale': {'domain': [0, 20]},
         'title': None}}}],
     '$schema': 'https://vega.github.io/schema/vega-lite/v4.8.1.json',
     'datasets': {'data-2b08226b30bbb08a20f45bc01ddaafde': [{'start': '2001-03-31',
        'end': '2001-11-30',
        'event': 'recession',
        'color': '#E2E2E2'},
       {'start': '2007-12-31',
        'end': '2009-06-30',
        'event': 'recession',
        'color': '#E2E2E2'},
       {'start': '2020-02-29',
        'end': '2021-04-01',
        'event': 'covid',
        'color': '#F3F4D8'}],
      'data-4c6f780913a45f81a467345005541598': [{'value': 0}]}}




```python
altair_viewer.display(chart1, inline=True)
```



<div id="altair-chart-598e63eda03c4ac1a8365026f71d03ca"></div>
<script type="text/javascript">
  (function(spec, embedOpt) {
    const outputDiv = document.getElementById("altair-chart-598e63eda03c4ac1a8365026f71d03ca");
    const urls = {
      "vega": "http://localhost:18007/scripts/vega.js",
      "vega-lite": "http://localhost:18007/scripts/vega-lite.js",
      "vega-embed": "http://localhost:18007/scripts/vega-embed.js",
    };
    function loadScript(lib) {
      return new Promise(function(resolve, reject) {
        var s = document.createElement('script');
        s.src = urls[lib];
        s.async = true;
        s.onload = () => resolve(urls[lib]);
        s.onerror = () => reject(`Error loading script: ${urls[lib]}`);
        document.getElementsByTagName("head")[0].appendChild(s);
      });
    }
    function showError(err) {
      outputDiv.innerHTML = `<div class="error" style="color:red;">${err}</div>`;
      throw err;
    }
    function displayChart(vegaEmbed) {
      vegaEmbed(outputDiv, spec, embedOpt)
        .catch(err => showError(`Javascript Error: ${err.message}<br>This usually means there's a typo in your chart specification. See the javascript console for the full traceback.`));
    }

    if(typeof define === "function" && define.amd) {
        // requirejs paths need '.js' extension stripped.
        const paths = Object.keys(urls).reduce(function(paths, package) {
            paths[package] = urls[package].replace(/\.js$/, "");
            return paths
        }, {})
        requirejs.config({paths});
        require(["vega-embed"], displayChart, err => showError(`Error loading script: ${err.message}`));
    } else if (typeof vegaEmbed === "function") {
        displayChart(vegaEmbed);
    } else {
        loadScript("vega")
            .then(() => loadScript("vega-lite"))
            .then(() => loadScript("vega-embed"))
            .catch(showError)
            .then(() => displayChart(vegaEmbed));
    }
  })({"config": {"view": {"continuousWidth": 610, "continuousHeight": 420}}, "layer": [{"data": {"name": "data-2b08226b30bbb08a20f45bc01ddaafde"}, "mark": {"type": "rect", "blend": "darken"}, "encoding": {"color": {"type": "nominal", "field": "color", "scale": null}, "x": {"type": "temporal", "field": "start"}, "x2": {"field": "end"}}}, {"layer": [{"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df2.csv"}, "mark": {"type": "line", "color": "#243A59", "line": true}, "encoding": {"tooltip": [{"type": "temporal", "field": "DATE", "title": "Date"}, {"type": "quantitative", "field": "BAMLH0A0HYM2", "format": ".2f", "title": "ICE BofA US High Yield Index Option-Adjusted Spread"}], "x": {"type": "temporal", "axis": {"grid": false, "tickCount": 10}, "field": "DATE", "title": null}, "y": {"type": "quantitative", "axis": {"format": ".1f", "grid": true, "tickCount": 9, "titleFontWeight": "normal", "values": [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]}, "field": "BAMLH0A0HYM2", "scale": {"domain": [0, 20]}, "title": "Percent"}}}, {"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df1.csv"}, "mark": {"type": "line", "color": "#E64754", "line": true}, "encoding": {"tooltip": [{"type": "temporal", "field": "DATE", "title": "Date"}, {"type": "quantitative", "field": "DRTSCIS", "format": ".1f", "title": "Net Percentage of Domestic Banks Tightening Standards for Commercial and Industrial Loans to Small Firms"}], "x": {"type": "temporal", "field": "DATE"}, "y": {"type": "quantitative", "axis": {"format": ".0f", "tickCount": 9, "titleFontWeight": "normal", "values": [-30, -15, 0, 15, 30, 45, 60, 75, 90]}, "field": "DRTSCIS", "scale": {"domain": [-30, 90]}, "title": "Percent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "resolve": {"scale": {"y": "independent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "$schema": "https://vega.github.io/schema/vega-lite/v4.8.1.json", "datasets": {"data-2b08226b30bbb08a20f45bc01ddaafde": [{"start": "2001-03-31", "end": "2001-11-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2007-12-31", "end": "2009-06-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2020-02-29", "end": "2021-04-01", "event": "covid", "color": "#F3F4D8"}], "data-4c6f780913a45f81a467345005541598": [{"value": 0}]}}, {});
</script>



## Chart 2

For this part of the taks we will switch the _ICE BofA US High Yield Index Option-Adjusted Spread_ for _Unemployment Rate_.


```python
indicator3='UNRATE'
pretty_indicator['UNRATE']='Unemployment Rate'
```


```python
df3=pd.read_csv('https://fred.stlouisfed.org/graph/fredgraph.csv?id='+indicator3)
df3=df3.astype({'DATE':np.datetime64}).set_index('DATE').dropna().loc[start:end].reset_index()
df3.to_csv('df3.csv')
```

Next, upload to [GitHub](https://github.com/csaladenes/eco) ... then return here. We then set up for local loading and viewing. Then tweak the plotting function to reflect the new scale and limits. 


```python
def plotter(df1,df2,dr):
    l1=alt.Chart(df1)\
        .mark_line(
        line=True,
        color='#E64754'
        ).encode(
        x='DATE:T',
        y=alt.Y(indicator1+':Q', 
                title='Percent', 
                scale=alt.Scale(domain=(-30, 90)),
                axis=alt.Axis(
                    format= ".0f",
                    tickCount=9,
                    titleFontWeight='normal',
                    values=[15*i for i in range(-2,7)]
                )
               ),
        tooltip=[alt.Tooltip('DATE:T', title='Date'),
                 alt.Tooltip(indicator1+':Q', title=pretty_indicator[indicator1], format='.1f')]
    )
    l2=alt.Chart(df2)\
        .mark_line(
        line=True,
        color='#243A59'
        ).encode(
        x=alt.X('DATE:T', 
                title=None,
                axis=alt.Axis(
                    grid=False,
                    tickCount=10
                )
               ),
        y=alt.Y(indicator3+':Q', 
                title='Percent', 
                scale=alt.Scale(domain=[0, 15]),
                axis=alt.Axis(
                    format= ".1f",
                    grid=True,
                    tickCount=9,
                    titleFontWeight='normal',
                    values=[2.5*i for i in range(9)]
                )
               ),
        tooltip=[alt.Tooltip('DATE:T', title='Date'),
                 alt.Tooltip(indicator3+':Q', title=pretty_indicator[indicator3], format='.2f')]
    )
    rect = alt.Chart(dr).mark_rect(
        blend='darken'
    ).encode(
        x='start:T',
        x2='end:T',
        color=alt.Color('color:N',scale=None)
    )
    l = alt.Chart(pd.DataFrame([{'value':0}])).mark_rule(size=3).encode(
        y=alt.Y('value:Q', 
                title=None, 
                scale=alt.Scale(domain=[0, 20]),
                axis=alt.Axis(
                    values=[],
                    grid=False
                )
               ),
    )
    return ((rect)+((l2+l1+l).resolve_scale(y='independent'))+l).configure_view(
        continuousHeight=420,
        continuousWidth=610,
    )
p=plotter(github_url+'df1.csv',github_url+'df3.csv',dr)
p
```





<div id="altair-viz-4d68bee6293f474190d50ecec1de4eaf"></div>
<script type="text/javascript">
  (function(spec, embedOpt){
    let outputDiv = document.currentScript.previousElementSibling;
    if (outputDiv.id !== "altair-viz-4d68bee6293f474190d50ecec1de4eaf") {
      outputDiv = document.getElementById("altair-viz-4d68bee6293f474190d50ecec1de4eaf");
    }
    const paths = {
      "vega": "https://cdn.jsdelivr.net/npm//vega@5?noext",
      "vega-lib": "https://cdn.jsdelivr.net/npm//vega-lib?noext",
      "vega-lite": "https://cdn.jsdelivr.net/npm//vega-lite@4.8.1?noext",
      "vega-embed": "https://cdn.jsdelivr.net/npm//vega-embed@6?noext",
    };

    function loadScript(lib) {
      return new Promise(function(resolve, reject) {
        var s = document.createElement('script');
        s.src = paths[lib];
        s.async = true;
        s.onload = () => resolve(paths[lib]);
        s.onerror = () => reject(`Error loading script: ${paths[lib]}`);
        document.getElementsByTagName("head")[0].appendChild(s);
      });
    }

    function showError(err) {
      outputDiv.innerHTML = `<div class="error" style="color:red;">${err}</div>`;
      throw err;
    }

    function displayChart(vegaEmbed) {
      vegaEmbed(outputDiv, spec, embedOpt)
        .catch(err => showError(`Javascript Error: ${err.message}<br>This usually means there's a typo in your chart specification. See the javascript console for the full traceback.`));
    }

    if(typeof define === "function" && define.amd) {
      requirejs.config({paths});
      require(["vega-embed"], displayChart, err => showError(`Error loading script: ${err.message}`));
    } else if (typeof vegaEmbed === "function") {
      displayChart(vegaEmbed);
    } else {
      loadScript("vega")
        .then(() => loadScript("vega-lite"))
        .then(() => loadScript("vega-embed"))
        .catch(showError)
        .then(() => displayChart(vegaEmbed));
    }
  })({"config": {"view": {"continuousWidth": 610, "continuousHeight": 420}}, "layer": [{"data": {"name": "data-2b08226b30bbb08a20f45bc01ddaafde"}, "mark": {"type": "rect", "blend": "darken"}, "encoding": {"color": {"type": "nominal", "field": "color", "scale": null}, "x": {"type": "temporal", "field": "start"}, "x2": {"field": "end"}}}, {"layer": [{"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df3.csv"}, "mark": {"type": "line", "color": "#243A59", "line": true}, "encoding": {"tooltip": [{"type": "temporal", "field": "DATE", "title": "Date"}, {"type": "quantitative", "field": "UNRATE", "format": ".2f", "title": "Unemployment Rate"}], "x": {"type": "temporal", "axis": {"grid": false, "tickCount": 10}, "field": "DATE", "title": null}, "y": {"type": "quantitative", "axis": {"format": ".1f", "grid": true, "tickCount": 9, "titleFontWeight": "normal", "values": [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]}, "field": "UNRATE", "scale": {"domain": [0, 15]}, "title": "Percent"}}}, {"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df1.csv"}, "mark": {"type": "line", "color": "#E64754", "line": true}, "encoding": {"tooltip": [{"type": "temporal", "field": "DATE", "title": "Date"}, {"type": "quantitative", "field": "DRTSCIS", "format": ".1f", "title": "Net Percentage of Domestic Banks Tightening Standards for Commercial and Industrial Loans to Small Firms"}], "x": {"type": "temporal", "field": "DATE"}, "y": {"type": "quantitative", "axis": {"format": ".0f", "tickCount": 9, "titleFontWeight": "normal", "values": [-30, -15, 0, 15, 30, 45, 60, 75, 90]}, "field": "DRTSCIS", "scale": {"domain": [-30, 90]}, "title": "Percent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "resolve": {"scale": {"y": "independent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "$schema": "https://vega.github.io/schema/vega-lite/v4.8.1.json", "datasets": {"data-2b08226b30bbb08a20f45bc01ddaafde": [{"start": "2001-03-31", "end": "2001-11-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2007-12-31", "end": "2009-06-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2020-02-29", "end": "2021-04-01", "event": "covid", "color": "#F3F4D8"}], "data-4c6f780913a45f81a467345005541598": [{"value": 0}]}}, {"mode": "vega-lite"});
</script>



After each crisis, one can clearly see the _**delay**_ in the return in _Unemployment rate_ to pre-crisis levels.  
🔧 Here is the **final** `Vega-Lite` config:


```python
p.save('chart2.json')
chart2=json.loads(open('chart2.json','r').read())
chart2
```




    {'config': {'view': {'continuousWidth': 610, 'continuousHeight': 420}},
     'layer': [{'data': {'name': 'data-2b08226b30bbb08a20f45bc01ddaafde'},
       'mark': {'type': 'rect', 'blend': 'darken'},
       'encoding': {'color': {'type': 'nominal', 'field': 'color', 'scale': None},
        'x': {'type': 'temporal', 'field': 'start'},
        'x2': {'field': 'end'}}},
      {'layer': [{'data': {'url': 'https://raw.githubusercontent.com/csaladenes/eco/main/df3.csv'},
         'mark': {'type': 'line', 'color': '#243A59', 'line': True},
         'encoding': {'tooltip': [{'type': 'temporal',
            'field': 'DATE',
            'title': 'Date'},
           {'type': 'quantitative',
            'field': 'UNRATE',
            'format': '.2f',
            'title': 'Unemployment Rate'}],
          'x': {'type': 'temporal',
           'axis': {'grid': False, 'tickCount': 10},
           'field': 'DATE',
           'title': None},
          'y': {'type': 'quantitative',
           'axis': {'format': '.1f',
            'grid': True,
            'tickCount': 9,
            'titleFontWeight': 'normal',
            'values': [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]},
           'field': 'UNRATE',
           'scale': {'domain': [0, 15]},
           'title': 'Percent'}}},
        {'data': {'url': 'https://raw.githubusercontent.com/csaladenes/eco/main/df1.csv'},
         'mark': {'type': 'line', 'color': '#E64754', 'line': True},
         'encoding': {'tooltip': [{'type': 'temporal',
            'field': 'DATE',
            'title': 'Date'},
           {'type': 'quantitative',
            'field': 'DRTSCIS',
            'format': '.1f',
            'title': 'Net Percentage of Domestic Banks Tightening Standards for Commercial and Industrial Loans to Small Firms'}],
          'x': {'type': 'temporal', 'field': 'DATE'},
          'y': {'type': 'quantitative',
           'axis': {'format': '.0f',
            'tickCount': 9,
            'titleFontWeight': 'normal',
            'values': [-30, -15, 0, 15, 30, 45, 60, 75, 90]},
           'field': 'DRTSCIS',
           'scale': {'domain': [-30, 90]},
           'title': 'Percent'}}},
        {'data': {'name': 'data-4c6f780913a45f81a467345005541598'},
         'mark': {'type': 'rule', 'size': 3},
         'encoding': {'y': {'type': 'quantitative',
           'axis': {'grid': False, 'values': []},
           'field': 'value',
           'scale': {'domain': [0, 20]},
           'title': None}}}],
       'resolve': {'scale': {'y': 'independent'}}},
      {'data': {'name': 'data-4c6f780913a45f81a467345005541598'},
       'mark': {'type': 'rule', 'size': 3},
       'encoding': {'y': {'type': 'quantitative',
         'axis': {'grid': False, 'values': []},
         'field': 'value',
         'scale': {'domain': [0, 20]},
         'title': None}}}],
     '$schema': 'https://vega.github.io/schema/vega-lite/v4.8.1.json',
     'datasets': {'data-2b08226b30bbb08a20f45bc01ddaafde': [{'start': '2001-03-31',
        'end': '2001-11-30',
        'event': 'recession',
        'color': '#E2E2E2'},
       {'start': '2007-12-31',
        'end': '2009-06-30',
        'event': 'recession',
        'color': '#E2E2E2'},
       {'start': '2020-02-29',
        'end': '2021-04-01',
        'event': 'covid',
        'color': '#F3F4D8'}],
      'data-4c6f780913a45f81a467345005541598': [{'value': 0}]}}




```python
altair_viewer.display(chart2, inline=True)
```



<div id="altair-chart-cf719c84dd3c4822beba6b24f74baec5"></div>
<script type="text/javascript">
  (function(spec, embedOpt) {
    const outputDiv = document.getElementById("altair-chart-cf719c84dd3c4822beba6b24f74baec5");
    const urls = {
      "vega": "http://localhost:18007/scripts/vega.js",
      "vega-lite": "http://localhost:18007/scripts/vega-lite.js",
      "vega-embed": "http://localhost:18007/scripts/vega-embed.js",
    };
    function loadScript(lib) {
      return new Promise(function(resolve, reject) {
        var s = document.createElement('script');
        s.src = urls[lib];
        s.async = true;
        s.onload = () => resolve(urls[lib]);
        s.onerror = () => reject(`Error loading script: ${urls[lib]}`);
        document.getElementsByTagName("head")[0].appendChild(s);
      });
    }
    function showError(err) {
      outputDiv.innerHTML = `<div class="error" style="color:red;">${err}</div>`;
      throw err;
    }
    function displayChart(vegaEmbed) {
      vegaEmbed(outputDiv, spec, embedOpt)
        .catch(err => showError(`Javascript Error: ${err.message}<br>This usually means there's a typo in your chart specification. See the javascript console for the full traceback.`));
    }

    if(typeof define === "function" && define.amd) {
        // requirejs paths need '.js' extension stripped.
        const paths = Object.keys(urls).reduce(function(paths, package) {
            paths[package] = urls[package].replace(/\.js$/, "");
            return paths
        }, {})
        requirejs.config({paths});
        require(["vega-embed"], displayChart, err => showError(`Error loading script: ${err.message}`));
    } else if (typeof vegaEmbed === "function") {
        displayChart(vegaEmbed);
    } else {
        loadScript("vega")
            .then(() => loadScript("vega-lite"))
            .then(() => loadScript("vega-embed"))
            .catch(showError)
            .then(() => displayChart(vegaEmbed));
    }
  })({"config": {"view": {"continuousWidth": 610, "continuousHeight": 420}}, "layer": [{"data": {"name": "data-2b08226b30bbb08a20f45bc01ddaafde"}, "mark": {"type": "rect", "blend": "darken"}, "encoding": {"color": {"type": "nominal", "field": "color", "scale": null}, "x": {"type": "temporal", "field": "start"}, "x2": {"field": "end"}}}, {"layer": [{"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df3.csv"}, "mark": {"type": "line", "color": "#243A59", "line": true}, "encoding": {"tooltip": [{"type": "temporal", "field": "DATE", "title": "Date"}, {"type": "quantitative", "field": "UNRATE", "format": ".2f", "title": "Unemployment Rate"}], "x": {"type": "temporal", "axis": {"grid": false, "tickCount": 10}, "field": "DATE", "title": null}, "y": {"type": "quantitative", "axis": {"format": ".1f", "grid": true, "tickCount": 9, "titleFontWeight": "normal", "values": [0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0]}, "field": "UNRATE", "scale": {"domain": [0, 15]}, "title": "Percent"}}}, {"data": {"url": "https://raw.githubusercontent.com/csaladenes/eco/main/df1.csv"}, "mark": {"type": "line", "color": "#E64754", "line": true}, "encoding": {"tooltip": [{"type": "temporal", "field": "DATE", "title": "Date"}, {"type": "quantitative", "field": "DRTSCIS", "format": ".1f", "title": "Net Percentage of Domestic Banks Tightening Standards for Commercial and Industrial Loans to Small Firms"}], "x": {"type": "temporal", "field": "DATE"}, "y": {"type": "quantitative", "axis": {"format": ".0f", "tickCount": 9, "titleFontWeight": "normal", "values": [-30, -15, 0, 15, 30, 45, 60, 75, 90]}, "field": "DRTSCIS", "scale": {"domain": [-30, 90]}, "title": "Percent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "resolve": {"scale": {"y": "independent"}}}, {"data": {"name": "data-4c6f780913a45f81a467345005541598"}, "mark": {"type": "rule", "size": 3}, "encoding": {"y": {"type": "quantitative", "axis": {"grid": false, "values": []}, "field": "value", "scale": {"domain": [0, 20]}, "title": null}}}], "$schema": "https://vega.github.io/schema/vega-lite/v4.8.1.json", "datasets": {"data-2b08226b30bbb08a20f45bc01ddaafde": [{"start": "2001-03-31", "end": "2001-11-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2007-12-31", "end": "2009-06-30", "event": "recession", "color": "#E2E2E2"}, {"start": "2020-02-29", "end": "2021-04-01", "event": "covid", "color": "#F3F4D8"}], "data-4c6f780913a45f81a467345005541598": [{"value": 0}]}}, {});
</script>



## Further thoughts

Now the charts are finished and ready to be embedded into the _ECO_ site. However, here are three additional thoughts that I would like to formulate:

### ✨ Other tools

For time plots several data visualisation packages might do a more aesthetically pleasing job with only a slight extra effort. Here we could be looking at [D3plus](http://d3plus.org/) (the visual engine behind the [Observatory of Economic Complexity](https://oec.world) and the [Atlas of Economic Complexity](https://atlas.cid.harvard.edu/)), [eCharts](https://echarts.apache.org/en/index.html) or even the simple [Flourish](https://app.flourish.studio/).

### 🌃 Grafana rendition

Perhaps for those looking more into unification of styling, as well as for it being perfect for representign time series, [Grafana](http://grafana.net/), the visualisation engine behind my [COVID-19 Romanian Economic Impact Monitor](https://econ.ubbcluj.ro/coronavirus) is also a good choice:
* 🕹 [Interactive](https://covid-large.csaladen.es/d/s7ujx-wMz/eco?orgId=1&from=946677600000&to=1609365600000&viewPanel=2)
* 👇 Static


```python
%%html
<img style='width:100%;' src="grafana-static.png">
```


<img style='width:100%;' src="grafana-static.png">



### 📈📉 Dual axis plot caveats

 Dual axis plots typically give a false sense of correlation, [Lisa Charlotte Rost](https://lisacharlotterost.de/), data scientist at [Datawrapper](https://www.datawrapper.de/) does an [excellent](https://blog.datawrapper.de/dualaxis/) job at describing this issue. Here the typical recommendation would be to have a _connected scatterplot_, with time explicity displayed on the scatter points:


```python
%%html
<img style='width:600px' src="connected scatter plot.png">
```


<img style='width:600px' src="connected scatter plot.png">


