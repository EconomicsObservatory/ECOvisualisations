let ScrollyTelling = {};

ScrollyTelling.init = function(Vizzu, parentElementSelector="body", articleElementSelector="vizzuArticle", animStates, options={})
{
    Vizzu.prototype.scrollyTelling = {};
    Vizzu.prototype.scrollyTelling.currentVP = 0;
    Vizzu.prototype.scrollyTelling.requestedId = 0;
    Vizzu.prototype.scrollyTelling.storedCharts = {};
    Vizzu.prototype.scrollyTelling.registeredAnimations = [];

    let parentElement = "";
    let articleElement = "";
    if(typeof parentElement == "string")
    {
        try {
            parentElement = document.querySelector(parentElementSelector);
        } catch (error) {
            return null;
        }
    }

    if(typeof articleElement == "string")
    {
        try {
            articleElement = document.querySelector(articleElementSelector);

        } catch (error) {
            console.error("ScrollyTelling Error: Could not find parent element:", error);
            return null;
        }
    }

    if(typeof options.scrollType == 'undefined')
    {
        options.scrollType = "animate";
    }

    if(typeof options.animateDuration == 'undefined' && options.scrollType == "animate")
    {
        options.animateDuration = "250ms";
    }

    if(typeof options.vizzuContainer == 'undefined')
    {
        options.vizzuContainer = { id: 'myVizzu', stickyClass: 'vizzu-sticky', useSticky: true };
    }

    if(typeof options.vizzuContainer.id == 'undefined')
    {
        options.vizzuContainer.id = 'myVizzu';
    }

    if(typeof options.vizzuContainer.useSticky == 'undefined')
    {
        options.vizzuContainer.useSticky = true;
    }

    if(typeof options.vizzuContainer.stickyClass == 'undefined')
    {
        options.vizzuContainer.stickyClass = 'vizzu-sticky';
    }

    if(typeof options.vizzuContainer.width == 'undefined')
    {
        options.vizzuContainer.width = '80%';
    }

    if(typeof options.contClass == 'undefined')
    {
        options.contClass = 'vizzu-cont';
    }

    if(typeof options.culOffset == 'undefined')
    {
        options.culOffset = document.documentElement.clientHeight * 0.5;
    }

    if(typeof options.textAlign == 'undefined')
    {
        options.textAlign = 'right';
    }


    if(options.textAlign == 'left')
    {
        document.documentElement.style.setProperty('--scrolly-grid-size-left', options.vizzuContainer.width);
        document.documentElement.style.setProperty('--scrolly-grid-size-right', '1fr');
    }

    Vizzu.prototype.scrollyTelling.options = options;

    document.documentElement.style.setProperty('--cul-offset', options.culOffset);

    parentElement.setAttribute('class', 'scrollytelling');

    var myVizzu = document.createElement('div');
    myVizzu.id = options.vizzuContainer.id;

    if(options.vizzuContainer.useSticky)
    {
        myVizzu.classList.add(options.vizzuContainer.stickyClass);
    }

    if(options.textAlign == 'right')
    {
        document.documentElement.style.setProperty('--scrolly-grid-size-left', options.vizzuContainer.width);
        document.documentElement.style.setProperty('--scrolly-grid-size-right', '1fr');
        parentElement.appendChild(myVizzu);
    } else if(options.textAlign == 'stack')
    {
        parentElement.style.gridTemplateColumns = 'repeat(1, 1fr)';
        parentElement.appendChild(myVizzu);
    }

    if(options.textAlign == 'left')
    {
        document.documentElement.style.setProperty('--scrolly-grid-size-left', '1fr');
        document.documentElement.style.setProperty('--scrolly-grid-size-right', options.vizzuContainer.width);
        parentElement.appendChild(myVizzu);
    }

    parentElement.appendChild(articleElement);

    /*
    <div class="scrollytelling">
        <div id="myVizzu" class="sticky"></div>

        <aside id="vizuArticle">
        </aside>

    </div>
    */

    Vizzu.prototype.scrollyTelling.chart = new Vizzu(options.vizzuContainer.id);

    Vizzu.prototype.scrollyTelling.isInViewPort = function(el) {
        let top = el.offsetTop;
        let height = el.offsetHeight;
        let culOffset = parseInt(window.getComputedStyle(document.documentElement).getPropertyValue('--cul-offset'));

        while (el.offsetParent) {
            el = el.offsetParent;
            top += el.offsetTop;
        }

        return (
            top < (window.pageYOffset + window.innerHeight) &&
            (top + height) > window.pageYOffset + culOffset
        );
    }

    Vizzu.prototype.scrollyTelling.setCulOffset = function(num)
    {
        document.documentElement.style.setProperty('--cul-offset', num);
    }

    Vizzu.prototype.scrollyKeyExists = function(which)
    {
        return Object.keys(this.scrollyTelling.storedCharts).includes(which);
    }

    Vizzu.prototype.getScrollyAnimation = function(which)
    {
        try {
            return this.scrollyTelling.storedCharts[which];
        } catch (error) {
            console.error("Error: ${error}", "Scrolly key doesn't exist: " + which);
        }
    }

    Vizzu.prototype.storeScrollyAnimation = function(index=null)
    {
        let currIndex = index || Object.keys(this.scrollyTelling.storedCharts).length+1; 
        this.scrollyTelling.storedCharts[currIndex] = this.store();
    }

    window.addEventListener('resize', function() {
        document.documentElement.style.setProperty('--cul-offset', document.documentElement.clientHeight * 0.5);
    });

    window.requestedReanimation = false;
    Vizzu.prototype.scrollyTelling.toggleAnimation = function(which, vizzuOpactiy = 1, instantAnimation = false) {
        let chart = this.chart;
        window._vizzuDelayTimer = null;
        chart.scrollyTelling.requestedId = which;
        if (chart.scrollyTelling.currentVP == which) return;

        if (chart.scrollyKeyExists(chart.scrollyTelling.requestedId) || chart.scrollyTelling.storedCharts[chart.scrollyTelling.requestedId] !== undefined) {

            let animStr = '1s';
            if(instantAnimation == true) { animStr = '0s'; }
            if((chart.__proto__.scrollyTelling.options.scrollType == "animate") && chart.getScrollyAnimation(chart.scrollyTelling.currentVP))
            {
                if(chart.scrollyTelling.currentVP >= chart.scrollyTelling.requestedId)
                {
                    for(var i = chart.scrollyTelling.currentVP; i >= chart.scrollyTelling.requestedId; i--)
                    {
                        animStr = ((i == (chart.scrollyTelling.requestedId) && chart.scrollyTelling.registeredAnimations.length == 1) ? '1s' : chart.__proto__.scrollyTelling.options.animateDuration);

                        let animId = chart.getScrollyAnimation(i);
                        if(chart.scrollyTelling.registeredAnimations.indexOf(animId) == -1)
                        {
                            chart.scrollyTelling.registeredAnimations.push(animId);
                        }
                        chart.animate(animId, animStr).then(() => {
                            chart.scrollyTelling.registeredAnimations.splice(chart.scrollyTelling.registeredAnimations.indexOf(animId), 1);
                            document.getElementById(chart.__proto__.scrollyTelling.options.vizzuContainer.id).style.opacity = vizzuOpactiy;
                        });
                    }
                } else
                {
                    for(var i = chart.scrollyTelling.currentVP; i <= chart.scrollyTelling.requestedId; i++)
                    {
                        
                        animStr = ((i == (chart.scrollyTelling.requestedId) && chart.scrollyTelling.registeredAnimations.length == 1) ? '1s' : chart.__proto__.scrollyTelling.options.animateDuration);

                        let animId = chart.getScrollyAnimation(i);
                        //if chart.scrollyTelling.registeredAnimations doesn't contain the animId, then add it
                        if(chart.scrollyTelling.registeredAnimations.indexOf(animId) == -1)
                        {
                            chart.scrollyTelling.registeredAnimations.push(animId);
                        }

                        chart.animate(animId, animStr).then(() => {
                            chart.scrollyTelling.registeredAnimations.splice(chart.scrollyTelling.registeredAnimations.indexOf(animId), 1);
                            document.getElementById(chart.__proto__.scrollyTelling.options.vizzuContainer.id).style.opacity = vizzuOpactiy;
                        });
                    }
                }
            } else
            {
                chart.animate(chart.getScrollyAnimation(chart.scrollyTelling.requestedId), animStr).then(() => {
                    document.getElementById(chart.__proto__.scrollyTelling.options.vizzuContainer.id).style.opacity = vizzuOpactiy;
                });
            }
            
        } else
        {
            console.error("Animation does not exists with key: ", chart.scrollyTelling.requestedId);
            console.error(chart.scrollyTelling.storedCharts[chart.scrollyTelling.requestedId]);
        }
        chart.scrollyTelling.currentVP = chart.scrollyTelling.requestedId;
    }

    Vizzu.prototype.scrollyTelling.handleScrollEvent = function()
    {
        let chart = this.chart;
        var els = document.querySelectorAll('.'+Vizzu.prototype.scrollyTelling.options.contClass);
        for (var i = 0; i < els.length; i++) {
            if (chart.scrollyTelling.isInViewPort(els[i])) {
                let animId = els[i].getAttribute('data-vizzu-animid');
                window.requestedReanimation = true;
                chart.__proto__.scrollyTelling.toggleAnimation(animId);
                break;
            }
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        window._isScrolling = false;
        window._scrollTimer = null;

        window.addEventListener('scroll', function() {
            Vizzu.prototype.scrollyTelling.handleScrollEvent(Vizzu.prototype.scrollyTelling.chart);
        }, false);
    });
    
    let animStateIndex = 0;
    Vizzu.prototype.scrollyTelling._setupAnimStates = function(animStates)
    {
        let chart = Vizzu.prototype.scrollyTelling.chart;
        let isAtLastAnimState = false;
        let animStateFunc = animStates[0];
        let currentIndex = Object.keys(Vizzu.prototype.scrollyTelling.storedCharts).length+1;
        chart.initializing.then(() => {
            chart.setAnimation('0s');
            animStateFunc(chart).then(() => {
                chart.storeScrollyAnimation();
            }).then(() => {
                animStates.shift();
                if(animStates.length < 1)
                {
                    isAtLastAnimState = true;
                } else
                {
                    animStateIndex++;
                    Vizzu.prototype.scrollyTelling._setupAnimStates(animStates);
                }
            }).then(() => {
                if(isAtLastAnimState)
                {
                    chart.scrollyTelling.toggleAnimation(Object.keys(Vizzu.prototype.scrollyTelling.storedCharts)[0], 1, true);
                }
            });
        });
    }
    
    Vizzu.prototype.scrollyTelling._setupAnimStates(animStates);
    

    return Vizzu.prototype.scrollyTelling.chart;
}

export default ScrollyTelling;