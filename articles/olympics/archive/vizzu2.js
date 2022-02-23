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

// step 2
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

// //step 3
chart.animate({
    "config": {
        "channels": {
            "y": { "set": ["Country"] }
        }
    }
}, t)

// //step 4
chart.animate({
    "config": {
        "geometry": "rectangle",
        "channels": {
            "x": { "set": ["Value"] }
        }
    }
}, t)

// //step 5
chart.animate({
    "config": {
        "channels": {
            "color": { "set": ["Medal"] },
            "label": { "set": ["Medal"] },
            "x": { "attach": ["Medal"] }
        }
    }
}, t)

//step 6
chart.animate({
    "config": {
        "channels": {
            "label": { "set": ["Value"] }
        },
        "split": true
    }
}, t)

//step 7
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

//step 8
chart.animate({
    "config": {
        "channels": {
            "x": { "detach": ["Medal"] }
        }
    }
}, '100ms')

//step 9
chart.animate({
    "config": {
        "channels": {
            "x": { "attach": ["Year"] }
        }
    }
}, '100ms')

//step 10
chart.animate({
    "config": {
        "channels": {
            "x": { "detach": ["Value"] },
            "y": { "attach": ["Value"] }
        },
        "split": true
    }
}, t)

//step 11
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

//step 12
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

//step 13
chart.animate({
    "config": {
        "channels": {
            "y": { "attach": ["Gender"] },
            "color": { "set": ["Gender"] }
        },
        "split": false
    }
}, t)


//step 14
chart.animate({
    "config": {
        "split": true
    }
}, t)

//step 15
chart.animate({
    "config": {
        "split": false,
        "geometry": "rectangle"
    }
}, t)

//step 16
chart.animate({
    "data": {
        "filter": d => d["Country"] == "AUT" &&
            d["Discipline"] == "Alpine Skiing" &&
            d["Year"] == "2014"
    },
    "config": {}
}, t)

//step 17
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

//step 18
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