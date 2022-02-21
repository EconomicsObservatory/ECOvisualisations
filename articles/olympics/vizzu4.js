import Vizzu from 'https://cdn.jsdelivr.net/npm/vizzu@0.4.3/dist/vizzu.min.js';
import { data } from './olympicssf.js';

let t = '1500ms';
let chart = new Vizzu('vizzuCanvas');

//step 0
chart.animate({
    "data": data,
})

//step 1
chart.animate({
    "data": {
        "filter": d => d["Year"] == "2014" &&
            d["Games"] == "Winter"
    },
    "config": {
        "channels": {
            "size": { "set": ['Medal'] },
            "color": { "set": ['Country'] },
            "label": { "set": ['Country'] }
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

chart.animate({
    "config": {
        "channels": {
            "x": { "set": ["LogPopulation"] },
            "y": { "set": ['Medal'] },
        }
    }
}, t)

chart.animate({
    "config": {
        "channels": {
            "x": { "set": ["GDPPerCapita"] },
            "y": { "set": ['MedalValue'] },
        }
    }
}, t)

// chart.animate({
//     "config": {
//         "channels": {
//             "x": { "set": ["LogGDPPerCapita"] },
//             "y": { "set": ['LogPopulation'] },
//         }
//     }
// }, t)