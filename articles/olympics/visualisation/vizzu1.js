import Vizzu from 'https://cdn.jsdelivr.net/npm/vizzu@0.4.3/dist/vizzu.min.js';
import { athletes } from '../data/olympics-data-1896-2022-extended-athletes.js';
// import { countries } from '../data/olympics-data-1896-2022-extended-countries.js';

let t0 = '0ms'
let t1 = {
    "duration": 4,
    "delay": 2,
    "title": {
        "duration": 2,
        "delay": 2.2
    }
}
let t2 = {
    "duration": 1.5,
    "delay": 0.5,
    "title": {
        "duration": 2,
        "delay": 0.7
    }
}
let chart = new Vizzu('vizzuCanvas');
//step 0
chart.animate({
    "data": athletes,
})

//step 1
chart.animate({
        "config": {
            "channels": {
                "size": { "set": ["medalValue"] },
                "label": { "set": ["gameType"] },
            },
            "geometry": "circle",
            "legend": null,
        },
        "style": {
            "plot": {
                "marker": {
                    "label": {
                        //"position": "center"
                    },
                    "colorPalette": '#179FDBFF #36B7B4FF'
                },

            },
            "title": {
                "fontSize": 20,
                "paddingBottom": -30
            },
            "fontSize": 16,
            "fontFamily": "Spectral"
        }
    })
    //

//step 2
chart.animate({
        "config": {
            "title": "Olympic games are organised across two seasons."
        }
    })
    //

//step 3
chart.animate({
        "config": {
            "channels": {
                "color": { "set": ["gameSeason"] },
                "label": { "set": ["gameSeason"] },
            },

        }
    }, t2)
    //t2

//step 4
chart.animate({
        "config": {
            "channels": {
                "size": { "set": null },
                "x": { "set": ["gameSeason", "medalValue"] },
            },
            "coordSystem": "polar",
            "geometry": "rectangle",
            "title": 'This chart shows the distribution of events.'

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
    }, t1)
    //t1

//step 5
chart.animate({
        "config": {
            "channels": {
                "x": { "attach": ["sport"] },
                "label": { "set": null }
            },
            "title": 'The games are contested in 1400+ events across 88 disciplines.'

        }
    }, t1)
    //

//step 6b
chart.animate({
    "config": {}
}, t1)


//step 6
chart.animate({
        "config": {
            "channels": {
                "y": { "set": ["medalValue"], "range": { "min": "-60%" } },
                "label": { "set": ["sport"] },
            },

        }
    }, t2)
    //t2

//step 6b
chart.animate({
    "config": {}
}, t1)

//step 7
chart.animate({
        "config": {
            "channels": {
                "y": { "range": { "min": "0%", "max": "105%" } }
            },
            "coordSystem": "cartesian",
            "title": '17.5% of all medals are awarded in 🏂 Winter events.'

        },

    }, t1)
    //t1

//step 8
chart.animate({
    "data": {
        "filter": d => d["gameSeason"] == 'Winter'
    },
    "config": {
        "title": 'The latest Winter games had 99 events across 6 sports.'

    }
}, t1)

//step 9
chart.animate({
    "config": {
        "channels": {
            "color": { "attach": ["sport"] },
            "y": { 'attach': ["disciplineName"] },
            // "x": { 'detach': ["medalValue"] },
            "label": { 'set': ["disciplineName"] }

        },
        "title": 'These 6 Winter sports are broken down into 17 disciplines.'
    },
    "style": {
        "plot": {
            "marker": {
                "colorPalette": '#179FDBFF #122B39FF #0063AFFF #36B7B4FF #00A767FF #243B5AFF #676A86FF'
            },

        },
    }
}, t1)

//step 10
chart.animate({
    "data": { "filter": d => d["sport"] == 'Skiing' },
    "config": {
        "title": 'These are all the Skiing disciplines.'
    }
}, t1)

//step 11
chart.animate({
    "data": {
        "filter": d => d["disciplineId"] == "alpine-skiing"
    },
    "config": {
        "channels": {
            "y": { "set": null },
            "x": { "set": null },
            "size": { "set": ["medalValue"] },
        },
        "geometry": "circle",
        "title": 'Let\'s look at ⛷ Alpine Skiing!'
    },

}, t1)