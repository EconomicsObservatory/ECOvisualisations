import Vizzu from 'https://cdn.jsdelivr.net/npm/vizzu@latest/dist/vizzu.min.js';
import ScrollyTelling from './scrollyTelling.js';
import data from './data.js';
import style from './style.js';
import { athletes } from '../../data/olympics-data-1896-2022-extended-athletes.js';

window.onbeforeunload = function () {
	window.scrollTo(0, 0);
}

ScrollyTelling.init(Vizzu, "#scrollyTellingContainer", "#vizzuArticle",
	[

		chart => chart.animate({
			"data": athletes,
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
		}),

		chart => chart.animate({
			"config": {
				"title": "Olympic games are organised across two seasons.",
				"channels": {
					"color": { "set": ["gameSeason"] },
					"label": { "set": ["gameSeason"] },
				},

			}
		}),

		chart => chart.animate({
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
		}),

		chart => chart.animate({
			"config": {
				"channels": {
					"x": { "attach": ["sport"] },
					"label": { "set": null }
				},
				"title": 'The games are contested in 1400+ events across 88 disciplines.'

			}
		}),

		chart => chart.animate({
			"config": {
				"channels": {
					"y": { "set": ["medalValue"], "range": { "min": "-60%" } },
					"label": { "set": ["sport"] },
				},

			}
		}),

		chart => chart.animate({
			"config": {
				"channels": {
					"y": { "range": { "min": "0%", "max": "105%" } }
				},
				"coordSystem": "cartesian",
				"title": '17.5% of all medals are awarded in 🏂 Winter events.'

			},

		}),

		chart => chart.animate({
			"data": {
				"filter": d => d["gameSeason"] == 'Winter'
			},
			"config": {
				"title": 'The latest Winter games had 99 events across 6 sports.'

			}
		}),

		chart => chart.animate({
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
		}),

		chart => chart.animate({
			"data": { "filter": d => d["sport"] == 'Skiing' },
			"config": {
				"title": 'These are all the Skiing disciplines.'
			}
		}),

		chart => chart.animate({
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

		}),

		chart => chart.animate({
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
		}),

		chart => chart.animate({
			"config": {
				"channels": {
					"y": { "set": ["ico3eq"], "range": { "max": "102%" } }
				},
				"title": 'Let\'s compare the nations based on their aggregate Medal Score.'
			}
		}),

		chart => chart.animate({
			"config": {
				"geometry": "rectangle",
				"channels": {
					"x": { "set": ["medalValue"], "title": "Medal Score   🥇 × 4  +  🥈 × 2  +  🥉 × 1" }
				}
			}
		}),

		chart => chart.animate({
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
		}),

		chart => chart.animate({
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
		}),

		chart => chart.animate({
			"config": {
				"channels": {
					"label": { "set": null },
				},
				"split": false,
				"align": "center",
				"title": 'That is every 4th Gold medal.',
			}
		}),

		chart => chart.animate({
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
		}),

		chart => chart.animate({
			"config": {
				"channels": {
					"x": {
						"detach": ["medalType"],
					}
				},
				"title": 'Now let\'s see how are they distributed in time!',
			}
		}),

		chart => chart.animate({
			"config": {
				"sort": "none",
			}
		}),

		//part 2b
		chart => chart.animate({
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
			}
		}),

		chart => chart.animate({
			"config": {
				"channels": {
					"x": { "attach": ["gameName"] }
				},
			}
		}, '100ms'),

		chart => chart.animate({
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
		}),

		chart => chart.animate({
			"config": {
				"geometry": "area",
				"align": 'center',
				// "legend": "auto"
				"title": 'Let\'s look at Austria only.',
			}
		}),

		chart => chart.animate({
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
		}),

		chart => chart.animate({
			"config": {
				"channels": {
					"y": { "set": ["eventGender", "medalCount"] },
					"color": { "set": ["eventGender"] }
				},
				"title": 'They seem to be equally successful in both Women\'s and Men\'s events, as well as Mixed.',
			},
		}),

		chart => chart.animate({
			"config": {
				"split": true
			}
		}),

		chart => chart.animate({
			"config": {
				"geometry": "rectangle",
				"title": 'But let\' not forget the big picture!',
			}
		}),

		chart => chart.animate({
			"data": {
				"filter": d => d["ico3eq"] == "AUT" &&
					d["disciplineId"] == "alpine-skiing" &&
					d["year"] == "2022"
			},
			"config": {
				"split": false,
				"title": 'This was only one country...',
			}
		}),

		chart => chart.animate({
			"config": {
				"channels": {
					"y": { "detach": ["eventGender"] },
					"x": { "set": ["ico3eq"] },
					"color": { "set": ["disciplineName"] },
					"label": { "set": ["disciplineName"] }
				},
				"title": 'In one event...',
			}
		}),

		chart => chart.animate({
			"data": {
				"filter": d => d["year"] == "2022"
			},
			"config": {
				"channels": {
					"y": { "set": ["disciplineName"] },
					"x": { "set": ["ico3eq"] },
					"label": { "set": null }
				},
				"split": true,
				"title": '🥇🥈🥉',
			}
		}),

		chart => chart.animate({
			"config": {
				"channels": {
					"y": { "attach": ["sport"] },
				},
			}
		})

	], { scrollType: "animate" });


