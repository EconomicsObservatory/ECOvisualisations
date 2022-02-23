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
            "y": { "set": null },
            "x": { "set": null },
            "size": { "set": ["disciplineName"] },
            "label": { "set": ["disciplineName"] }
        },
        "geometry": "circle",
        "title": 'Let\'s look at ⛷ Alpine Skiing!'
    },
    "style": {
        "plot": {
            "marker": {
                "label": {
                    //"position": "center"
                },
                "colorPalette": '#179FDBFF #36B7B4FF'
            }

        },
        "title": {
            "fontSize": 20,
            "paddingBottom": -30
        },
        "fontSize": 16,
        "fontFamily": "Spectral"
    }
})

//step 2
chart.animate({
    "config": {
        "channels": {
            "size": { "attach": ["ico3eq", 'medalValue'] },
            "label": { "set": ["ico3eq"] },
            "color": { "set": ["ico3eq"] }
        },
        "legend": null,
        "title": 'Alpine nations are the most successful. Who would have thought? 🤔'
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
                "label": { "color": "#ffffff00" },
            }
        }
    }
}, t1)

//step 3
chart.animate({
    "config": {
        "channels": {
            "y": { "set": ["ico3eq"], "range": { "max": "102%" } }
        },
        "title": 'Let\'s compare the nations based on their aggregate Medal Score.'
    }
}, t1)

//step 4
chart.animate({
    "config": {
        "geometry": "rectangle",
        "channels": {
            "x": { "set": ["medalValue"], "title": "Medal Score   🥇 × 4  +  🥈 × 2  +  🥉 × 1" }
        }
    }
})

//step 5
chart.animate({
        "config": {
            "channels": {
                "color": { "set": ["medalType"] },
                "label": { "set": ["medalType"] },
                "x": { "attach": ["medalType"] }
            },
            "title": 'A Gold medal counts 4 points, a Silver 2 and a Bronze 1.'
        },
        "style": {
            "plot": {
                "marker": {
                    "colorPalette": '#F4C245FF #676A86FF #E54753FF',
                    "label": {
                        "paddingTop": 10
                    },
                },
                "yAxis": {
                    "label": { "color": null },
                }
            }

        }
    }, t2)
    //t2

//step 4
chart.animate({
    "config": {
        "title": 'Austria is the most successful skiing nation, followed by Switzerland.',
        "sort": "byValue"
    }
})

//step 6
chart.animate({
        "config": {
            "channels": {
                "label": { "set": ["medalCount"] },
                "x": {
                    "detach": ["medalValue"],
                    "attach": ["medalCount"],
                    "title": "Number of medals"
                },
            },
            "title": 'From St. Mortiz 1948 to Beijing 2022, Austria won 40 Gold medals.',
            "split": true
        }
    }, t2)
    //t2

//step6
chart.animate({
    "config": {}
}, t2)

//step 7
chart.animate({
        "config": {
            "channels": {
                "label": { "set": null },
            },
            "split": false,
            "align": "center",
            "title": 'That is every 4th Gold medal.',
        }
    }, t2)
    //t2

//step 8
chart.animate({
    "config": {
        "channels": {
            "color": { "set": ["ico3eq"] }
        }
    },
    "style": {
        "plot": {
            "marker": {
                "colorPalette": '#179FDBFF #122B39FF #0063AFFF #36B7B4FF #00A767FF #243B5AFF #676A86FF'
            },
        }
    }
})

//step 8
chart.animate({
    "config": {
        "channels": {
            "x": {
                "detach": ["medalType"],
            }
        },
        "title": 'Now let\'s see how are they distributed in time!',
    }
})

//step 9
chart.animate({
    "config": {
        "sort": "none",
    }
})