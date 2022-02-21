import Vizzu from 'https://cdn.jsdelivr.net/npm/vizzu@0.4.3/dist/vizzu.min.js';
import { data } from './winter.js';

let t = '1500ms';
let chart = new Vizzu('vizzuCanvas');

//step 0
chart.animate({
    "data": data,
})

//step 1
chart.animate({
    "data": {
        "filter": d => d["Discipline"] == "Alpine Skiing"
    },
    "config": {
        "channels": {
            "y": { "set": null },
            "x": { "set": null },
            "size": { "set": ["Discipline"] },
            "label": { "set": ["Discipline"] }
        },
        "geometry": "circle"
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

// step 1
chart.animate({
    "config": {
        "channels": {
            "size": { "attach": ["Country", 'Value'] },
            "label": { "set": ["Country"] },
            "color": { "set": ["Country"] }
        },
        "legend": null
    }
}, t)

// //step 1
chart.animate({
    "config": {
        "channels": {
            "y": { "set": ["Country"] }
        }
    }
}, t)

// //step 1
chart.animate({
    "config": {
        "geometry": "rectangle",
        "channels": {
            "x": { "set": ["Value"] }
        }
    }
}, t)

// //step 1
chart.animate({
    "config": {
        "channels": {
            "color": { "set": ["Medal"] },
            "label": { "set": ["Medal"] },
            "x": { "attach": ["Medal"] }
        }
    }
}, t)

chart.animate({
    "config": {
        "channels": {
            "label": { "set": ["Value"] }
        },
        "split": true
    }
}, t)

chart.animate({
    "config": {
        "channels": {
            "label": { "set": null },
            "color": { "set": ["Country"] }
        },
        "split": false,
        "align": "center"
    }
}, t)
chart.animate({
    "config": {
        "channels": {
            "x": { "detach": ["Medal"] }
        }
    }
}, t)

chart.animate({
    "config": {
        "channels": {
            "x": { "attach": ["Year"] }
        }
    }
}, t)

chart.animate({
    "config": {
        "channels": {
            "x": { "detach": ["Value"] },
            "y": { "attach": ["Value"] }
        },
        "split": true
    }
}, t)

chart.animate({
    "config": {
        "channels": {
            "x": { "set": ["Year"] },
            // "y": { "set": null }
        },
        "geometry": "area",
        "align": 'center',
    }
}, t)

chart.animate({
    "data": {
        "filter": d => d["Country"] == "AUT" &&
            d["Discipline"] == "Alpine Skiing"
    },
    "config": {
        "channels": {
            "label": { "set": ["Value"] },
        },
        "align": 'min'
    }
}, t)

chart.animate({
    "config": {
        "channels": {
            "y": { "attach": ["Gender"] },
            "color": { "set": ["Gender"] }
        },
        "split": false
    }
}, t)


chart.animate({
    "config": {
        "split": true
    }
}, t)

chart.animate({
    "config": {
        "split": false,
        "geometry": "rectangle"
    }
}, t)

chart.animate({
    "data": {
        "filter": d => d["Country"] == "AUT" &&
            d["Discipline"] == "Alpine Skiing" &&
            d["Year"] == "2014"
    },
    "config": {}
}, t)

chart.animate({
    "config": {
        "channels": {
            "y": { "detach": ["Gender"] },
            "x": { "set": ["Country"] },
            "color": { "set": ["Discipline"] },
            "label": { "set": ["Discipline"] }
        },
    }
}, t)

chart.animate({
    "data": {
        "filter": d => d["Country"] != "XX" &&
            d["Discipline"] != "XX" &&
            d["Year"] == "2014"
    },
    "config": {
        "channels": {
            "y": { "set": ["Discipline"] },
            "x": { "set": ["Country"] },
            "color": { "set": ["Discipline"] },
            "label": { "set": null }
        },
        "split": true
    }
})