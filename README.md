# EatPaste
A Rails Pastie "clone" with tags and keyboard shortcuts.


## Why?
* Wanted an private Pastie for internal use
* Just for fun


## What can it do currently?
* sections (based on Pastie syntax)
* tags
* refeed (repaste)
* auto-copy-to-clipboard (even on individual sections ;)
* keyboard shortcuts (new paste, refeed, search, and navigations)
* search: by id, by tags, by fulltext


## What can't it (TO)do? 
* NO edit mode (yet)
* NO delete mode (yet)
* NO private paste
* NO embeds (yet)
* NO popular tags & languages (yet)


## Dependencies & Requirements
* Rails 2.3.2
* MySQL (it uses MySQL Fulltext search, i.e. Paste table is MyISAM)
* Ultraviolet (a slightly slimmed down version of 0.10.2 is frozen in source, but Uv depends on other gems)
* Textpow (required by Uv)
* Oniguruma the Regular Expression Engine (required by Textpow and might be the biggest pain to install)
* Oniguruma Ruby binding (best install through gem once you installed Oniguruma)
* mislav-will_paginate


## Usage: Sections
Section syntax starts with ## and always ending with [].  The default language you wish to use for each section is enclosed within []:
    
    ## This is a section [ruby]
    class Foo
      def bar
        'bar'
      end
    end

If you wish to use the Paste's default language for syntax highlighting, you have to leave the []:

    ## Guess what langauge? []
    class Foo:
      def bar(self):
        return 'bar'

## Usage: Tags
Tags are comma-separated. They can include any alphanumeric and symbols except the follow characters: 
    
    < > & "  ` ( ) { } [ ] ;

These characters will be replaced by a single space for each character found.


## Usage: Search
* Use <code>#101</code> to **go** directly to paste 101
* Use <code>r#101</code> to **refeed** paste 101
* Use <code>t[t1, t2, t3]</code> to search for any paste having tags t1, t2, **and** t3.
* Use regular search terms to search for a particular word in the paste body.  
* You can mix tag search and term search. But tag search must always be the first search term.
* If you wish to search for the actual term #101, you can leave a leading space before the # symbol: " #101"


## Usage: Shortcuts
Here are all the available keyboard shortcuts:

    e:             // New Paste
    p:             // Paste Listing
    r:             // Refeed
    h:             // Previous page             (Vi)
    l:             // Next page                 (Vi)
    j:             // Select Previous Paste, UP (Vi)
    k:             // Select Next Paste, DOWN   (VI)
    enter:         // Show the selected Paste
    period:        // Go to search bar and clear it
    forward_slash: // Go to search bar but don't clear it



## Lisence
MIT License.
