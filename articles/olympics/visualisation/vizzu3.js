import Vizzu from 'https://cdn.jsdelivr.net/npm/vizzu@0.4.3/dist/vizzu.min.js';
import { data } from './olympicssm.js';

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
            "y": { "set": ['Discipline'] },
            "color": { "set": ['Discipline'] },
            "x": { "set": ['Country'] }
        },
        "split": true
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
            "geometry": "circle",
            "channels": {
                "size": {
                    "set": ['Medal']
                }
            },
            "legend": null
        }
    },
    t)

chart.animate({
    "config": {
        "channels": {
            "color": { "set": ['Country'] }
        }
    }
}, t)

chart.animate({
    "config": {
        "channels": {
            "size": { "attach": "Discipline" },
            "y": { "set": null },
            "x": { "set": null },
        }
    }
}, t)

chart.animate({
    "config": {
        "channels": {
            "size": { "detach": ["Discipline"] },
            "label": { "set": ['Country'] },
        }
    }
}, t)