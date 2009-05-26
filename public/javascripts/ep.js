var EP = {
    Hotkeys: {
        bind: function() {
            var keyHandlers = EP.Hotkeys.setKeyHandlers();
            $(document).bind('keydown.EPHotkeys', function(event) {
                if(event.ctrlKey || event.altKey || event.metaKey) { return true; }  // don't block modified keys (e.g. cmd-l)
                if ( !$(event.target).is(':input') && keyHandlers[event.keyCode] ) {
                    keyHandlers[event.keyCode]();
                    return false;
                }
            });
            return this;
        },
        setKeyHandlers: function() {
            var keys = EP.Hotkeys.keys;
            var selectors = EP.Hotkeys.selectors;
            var handlers = {};
            handlers[keys.e] = function() { $(selectors.newPaste).goToLink(); };
            handlers[keys.p] = function() { $(selectors.allPastes).goToLink(); };
            handlers[keys.forward_slash] = function() {
                $('html,body').scrollTop(0);
                $(selectors.search).focus();
                return false;
            };

            handlers[keys.period] = function() {
                $('html,body').scrollTop(0);
                $(selectors.search).val('').focus();
                return false;
            };

            // Pastes Keyboard Navigation
            if ($(selectors.pastes).length > 0) {
                var pastes = new EP.Pastes(selectors.pastes);
                handlers[keys.j] = function() { pastes.selectNext(); };
                handlers[keys.k] = function() { pastes.selectPrev(); };
                handlers[keys.h] = function() { $(selectors.prevPage).goToLink(); };
                handlers[keys.l] = function() { $(selectors.nextPage).goToLink(); };
                handlers[keys.enter] = function() { 
                    if ( pastes.current() ) {
                        window.location = pastes.current().find(selectors.showPaste).attr('href'); 
                    }
                };
            }
            return handlers;
        },
        keys: {
            e: 69,              // New
            p: 80,              // Pastes
            h: 72,              // Previous page
            l: 76,              // Next page    
            j: 74,              // Up
            k: 75,              // Down
            enter: 13,          // Show
            period: 190,        // Go to search bar and clear it
            forward_slash: 191  // Go to search bar
        },
        selectors: {
            allPastes: 'a#nav-all',
            newPaste:  'a#nav-new',
            showPaste: '.language a',
            pastes:    '#pastes .paste',
            search:    'input#q',
            prevPage:  '.pagination a.prev_page',
            nextPage:  '.pagination a.next_page'
        }
    },
    Pastes: function( pastes ) {
        this.pastes = $(pastes);
        this.index = -1; 
    }
};

EP.Pastes.prototype =  {
    current: function() {
        return this.pastes.eq(this.index);
    },
    next: function() {
        this.index = (this.index + 1) % this.pastes.length;
        return this.current();
    },
    prev: function() {
        var prevIndex = this.index - 1;
        this.index = prevIndex < 0 ? this.pastes.length - 1 : (prevIndex) % this.pastes.length;
        return this.current();
    },
    selectNext: function() {
        if ( this.current() ) { this.current().removeClass('selected'); }
        return this.next().addClass('selected').scrollToViewable();
    },   
    selectPrev: function() {
        if ( this.current() ) { this.current().removeClass('selected'); }
        return this.prev().addClass('selected').scrollToViewable();
    }
};


(function($) {    
    
    $.fn.goToLink = function() {
        var a = $(this);
        if ( a.is('a') ) { window.location = a.attr('href'); }
        return this;
    };

    
    $.fn.scrollToViewable = function( offset ) {
       var element = $(this);
       var nextTop = element.offset().top;
       var windowScrollTop = $(window).scrollTop();
       // element doesn't fit on to screen we'll scroll to the top of the element + offset
       if ( nextTop < windowScrollTop || (nextTop + element.height()) > (windowScrollTop + $(window).height()) ) {
           $('html,body').animate({scrollTop: nextTop + (offset||-50)}, 200);
       } 
       return this;
    };
    
 
})(jQuery);
