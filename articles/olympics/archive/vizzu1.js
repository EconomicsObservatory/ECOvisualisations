import Vizzu from 'https://cdn.jsdelivr.net/npm/vizzu@0.4.3/dist/vizzu.min.js';
import { data } from './olympicssm.js';

let t = '1500ms' //'1000ms';
let chart = new Vizzu('vizzuCanvas');

//step 1
chart.animate({
    "data": data,
    "config": {
        "channels": {
            "size": { "set": ["Medal"] },
            "label": { "set": ["All"] },
        },
        "geometry": "circle",
        "legend": null
    },
    "style": {
        "plot": {
            "marker": {
                "label": {
                    "fontSize": 14,
                    //"position": "center"
                }
            },
        }
    }
}, t)

//step 2
chart.animate({
    "config": {
        "channels": {
            "color": { "set": ["Games"] },
            "label": { "set": ["Games"] },
        }
    }
}, t)

//step 3
chart.animate({
    "config": {
        "channels": {
            "size": { "set": null },
            "x": { "set": ["Games", "Medal"] },
        },
        "coordSystem": "polar",
        "geometry": "rectangle",
    },
    "style": {
        "plot": {
            "marker": { "borderWidth": 1, "borderOpacity": 0.5 },
            "xAxis": { "title": { "color": "#ffffff00" }, "label": { "color": "#ffffff00" } },
            "yAxis": {
                "color": "#ffffff00",
                "title": { "color": "#ffffff00" },
                "label": { "color": "#ffffff00" },
            }
        }
    }
}, t)

//step 4
chart.animate({
    "config": {
        "channels": {
            "x": { "attach": ["Sport"] },
            "label": { "set": null }
        }
    }
}, t)

//step 5
chart.animate({
    "config": {
        "channels": {
            "y": { "set": ["Medal"], "range": { "min": "-60%" } },
            "label": { "set": ["Sport"] },
        },
    }
}, t)

//step 6
chart.animate({
    "config": {
        "coordSystem": "cartesian",
    }
}, t)

//step 7
chart.animate({
    "data": {
        "filter": d => d["Games"] == 'Winter'
    }
}, t)

//step 7
chart.animate({
    "config": {
        "channels": {
            "color": { "attach": ["Sport"] },
            "y": { 'attach': ["Discipline"] },
            "label": { 'set': ["Discipline"] }

        }
    }
}, t)

//step 7
chart.animate({
    "data": { "filter": d => d["Sport"] == 'Skiing' }
}, t)

//step 7
chart.animate({
    "data": {
        "filter": d => d["Discipline"] == "Alpine Skiing"
    },
    "config": {
        "channels": {
            "y": { "set": null },
            "x": { "set": null },
            "size": { "set": ["Discipline"] },
        },
        "geometry": "circle"
    },

}, t)