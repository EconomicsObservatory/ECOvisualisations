import Vizzu from 'https://cdn.jsdelivr.net/npm/vizzu@0.4.3/dist/vizzu.min.js';
import { athletes } from '../data/olympics-data-1896-2022-extended-athletes.js';
// import { countries } from '../data/olympics-data-1896-2022-extended-countries.js';

let t0 = {
    "duration": 0,
    "delay": 0,
    "title": {
        "duration": 0,
        "delay": 0
    }
}
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
    "data": {
        "filter": d => d["disciplineId"] == "alpine-skiing"
    },
    "config": {
        "channels": {
            "y": { "set": ["ico3eq"] },
            "x": { "set": ["medalCount"], "title": "Number of medals" },
            "color": {
                "set": ["ico3eq"]
            },
        },
        "legend": null,
        "split": false,
        "align": "center",
        "title": 'Now let\'s see how are they distributed in time!',
    },
    "style": {
        "plot": {
            "marker": {
                "colorPalette": '#179FDBFF #122B39FF #0063AFFF #36B7B4FF #00A767FF #243B5AFF #676A86FF'
            },
            "xAxis": {
                "title": {
                    // "color": "#ffffff00",
                    "paddingTop": 40
                },
                // "label": { "color": "#ffffff00" }
            },
            "yAxis": {
                "color": "#ffffff00",
                "title": { "color": "#ffffff00" },
                "label": { "color": null },
            },
            "paddingBottom": 95,
            "paddingLeft": 95
        },
        "title": {
            "fontSize": 20,
            "paddingBottom": -30
        },
        "fontSize": 16,
        "fontFamily": "Spectral"
    }
})

//step 9
chart.animate({
    "config": {
        "channels": {
            "x": { "attach": ["gameName"] }
        },
    }
}, '100ms')

//step 10
chart.animate({
    "config": {
        "channels": {
            "y": { "attach": ["medalCount"] },
            "x": { "detach": ["medalCount"] },

        },
        "split": true,
        "sort": "none"
    },
    "style": {
        "plot": {
            "xAxis": {
                "label": {
                    "angle": -0.8,
                    "fontSize": 12
                },
            }
        }
    }
}, t2)

//step 11
chart.animate({
    "config": {
        "geometry": "area",
        "align": 'center',
        // "legend": "auto"
    }
}, t2)

//step 12
chart.animate({
    "data": {
        "filter": d => d["ico3eq"] == "AUT" &&
            d["disciplineId"] == "alpine-skiing"
    },
    "config": {
        "channels": {
            "label": { "set": ["medalCount"] },
        },
        "align": 'min',
        "split": false
    }
}, t2)

//step 13
chart.animate({
    "config": {}
}, t2)

//step 13
chart.animate({
    "config": {
        "channels": {
            "y": { "set": ["eventGender", "medalCount"] },
            "color": { "set": ["eventGender"] }
        },
    },
}, t2)

//step 15
chart.animate({
    "config": {
        "split": true
    }
}, t2)

//step 15
chart.animate({
    "config": {
        "geometry": "rectangle"
    }
})

//step 16
chart.animate({
    "data": {
        "filter": d => d["ico3eq"] == "AUT" &&
            d["disciplineId"] == "alpine-skiing" &&
            d["year"] == "2022"
    },
    "config": {
        "split": false
    }
})

//step 17
chart.animate({
    "config": {
        "channels": {
            "y": { "detach": ["eventGender"] },
            "x": { "set": ["ico3eq"] },
            "color": { "set": ["disciplineName"] },
            "label": { "set": ["disciplineName"] }
        },
    }
})

//step 18
chart.animate({
    "data": {
        "filter": d => d["year"] == "2022"
    },
    "config": {
        "channels": {
            "y": { "set": ["disciplineName"] },
            "x": { "set": ["ico3eq"] },
            "label": { "set": null }
        },
        "split": true
    }
})

//step 18
chart.animate({
    "config": {
        "channels": {
            "y": { "attach": ["sport"] },
        },
    }
})