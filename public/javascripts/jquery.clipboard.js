// A jQuery wrapper for zeroclipboard

(function($) {
    $.fn.clickToClipboard = function() {
        $(this).each( function() {
            var link = $(this);
            if ( link.is('a') ) {
                var clip = new ZeroClipboard.Client();
                clip.glue(this);
                clip.addEventListener('onMouseDown', function(){
                    link.html('copying...');
                    jQuery.ajax({ 
                        url: link.attr('href'),
                        success: function(content) { clip.setText(content);},
                        async: false
                    });
                });
                
                clip.addEventListener('onComplete', function(){ 
                    link.html('copied!');
                    clip.reposition();
                });
            }            
        });
    }
})(jQuery);
